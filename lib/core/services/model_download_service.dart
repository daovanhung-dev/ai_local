import 'dart:async';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../config/model_catalog.dart';

typedef DownloadProgressCallback = void Function(int received, int total);

class DownloadCancelledException implements Exception {
  const DownloadCancelledException();
}

class InsufficientStorageException implements Exception {
  const InsufficientStorageException(this.requiredBytes, this.availableBytes);

  final int requiredBytes;
  final int availableBytes;
}

class ModelDownloadService {
  static const _channel = MethodChannel('com.localai.chatbot/device');
  ModelDownloadService({
    http.Client Function()? clientFactory,
    Future<Directory> Function()? supportDirectory,
    Future<int?> Function()? availableStorage,
  }) : _clientFactory = clientFactory ?? http.Client.new,
       _supportDirectory = supportDirectory ?? getApplicationSupportDirectory,
       _availableStorageOverride = availableStorage;

  final http.Client Function() _clientFactory;
  final Future<Directory> Function() _supportDirectory;
  final Future<int?> Function()? _availableStorageOverride;
  final Map<String, http.Client> _activeClients = {};

  Future<String> modelDirectoryPath() async {
    final support = await _supportDirectory();
    final directory = Directory(p.join(support.path, 'models'));
    await directory.create(recursive: true);
    return directory.path;
  }

  Future<String> modelFilePath(ModelManifestEntry model) async =>
      p.join(await modelDirectoryPath(), model.fileName);

  Future<String> download(
    ModelManifestEntry model, {
    required DownloadProgressCallback onProgress,
  }) async {
    final finalPath = await modelFilePath(model);
    final target = File(finalPath);
    final part = File('$finalPath.part');

    if (await target.exists()) {
      final valid = await _isValid(target, model);
      if (valid) return finalPath;
      await target.delete();
    }

    var safeOffset = await part.exists() ? await part.length() : 0;
    if (safeOffset > model.sizeBytes) {
      await part.delete();
      safeOffset = 0;
    }
    if (safeOffset == model.sizeBytes) {
      if (await _isValid(part, model)) {
        return await part.rename(finalPath).then((file) => file.path);
      }
      await part.delete();
      safeOffset = 0;
    }
    final requiredRemaining = model.sizeBytes - safeOffset;
    final available = await _availableStorageBytes();
    if (available != null && available < requiredRemaining + 32 * 1024 * 1024) {
      throw InsufficientStorageException(
        requiredRemaining + 32 * 1024 * 1024,
        available,
      );
    }

    final client = _clientFactory();
    _activeClients[model.id] = client;
    try {
      final request = http.Request('GET', Uri.parse(model.sourceUrl));
      request.headers['Accept-Encoding'] = 'identity';
      if (safeOffset > 0) request.headers['Range'] = 'bytes=$safeOffset-';
      final response = await client.send(request);
      final append =
          safeOffset > 0 && response.statusCode == HttpStatus.partialContent;
      if (response.statusCode != HttpStatus.ok && !append) {
        throw HttpException(
          'Máy chủ trả về HTTP ${response.statusCode}.',
          uri: request.url,
        );
      }

      final startAt = append ? safeOffset : 0;
      final output = part.openWrite(
        mode: append ? FileMode.append : FileMode.write,
      );
      var received = startAt;
      onProgress(received, model.sizeBytes);
      try {
        await for (final bytes in response.stream) {
          if (!_activeClients.containsKey(model.id)) {
            throw const DownloadCancelledException();
          }
          received += bytes.length;
          if (received > model.sizeBytes) {
            throw const FileSystemException('Tệp tải về lớn hơn manifest.');
          }
          output.add(bytes);
          onProgress(received, model.sizeBytes);
        }
      } finally {
        await output.flush();
        await output.close();
      }

      if (received != model.sizeBytes) {
        throw const FileSystemException('Tệp tải về chưa đủ kích thước.');
      }
      if (!await _isValid(part, model)) {
        await part.delete();
        throw const FileSystemException('SHA-256 của model không khớp.');
      }

      if (await target.exists()) await target.delete();
      return await part.rename(finalPath).then((file) => file.path);
    } on DownloadCancelledException {
      rethrow;
    } catch (error) {
      if (!_activeClients.containsKey(model.id)) {
        throw const DownloadCancelledException();
      }
      rethrow;
    } finally {
      _activeClients.remove(model.id);
      client.close();
    }
  }

  Future<bool> verifyInstalledFile(
    ModelManifestEntry model,
    String filePath,
  ) async {
    final file = File(filePath);
    return await file.exists() && await _isValid(file, model);
  }

  Future<void> cancel(String modelId) async {
    final client = _activeClients.remove(modelId);
    client?.close();
  }

  Future<void> deleteModelFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) await file.delete();
    final partial = File('$filePath.part');
    if (await partial.exists()) await partial.delete();
  }

  Future<bool> _isValid(File file, ModelManifestEntry model) async {
    if (!await file.exists() || await file.length() != model.sizeBytes) {
      return false;
    }
    final digest = await sha256.bind(file.openRead()).first;
    return digest.toString().toLowerCase() == model.sha256.toLowerCase();
  }

  Future<int?> _availableStorageBytes() async {
    if (_availableStorageOverride != null) {
      return _availableStorageOverride();
    }
    try {
      return await _channel.invokeMethod<int>('availableStorageBytes');
    } on MissingPluginException {
      return null;
    } on PlatformException {
      return null;
    }
  }
}
