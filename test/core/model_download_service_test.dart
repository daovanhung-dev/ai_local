import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:local_ai_chatbot/core/config/model_catalog.dart';
import 'package:local_ai_chatbot/core/services/model_download_service.dart';

void main() {
  late Directory temporaryDirectory;

  setUp(() async {
    temporaryDirectory = await Directory.systemTemp.createTemp(
      'local-ai-test-',
    );
  });

  tearDown(() async {
    if (await temporaryDirectory.exists()) {
      await temporaryDirectory.delete(recursive: true);
    }
  });

  const bytes = <int>[4, 8, 15, 16, 23, 42];
  final expectedHash = sha256.convert(bytes).toString();

  ModelManifestEntry testModel({String? hash}) => ModelManifestEntry(
    id: 'test-model',
    name: 'Test model',
    description: 'Fixture',
    sourceUrl: 'https://example.test/test.gguf',
    fileName: 'test.gguf',
    sizeBytes: bytes.length,
    sha256: hash ?? expectedHash,
    license: 'Test license',
    licenseUrl: 'https://example.test/license',
    quantization: 'Q4_K_M',
    recommendedRamBytes: 1,
    contextSize: 1024,
    supportsThinking: false,
    tier: ModelTier.fast,
    sortOrder: 0,
  );

  ModelDownloadService serviceFor(http.Client client) => ModelDownloadService(
    clientFactory: () => client,
    supportDirectory: () async => temporaryDirectory,
    availableStorage: () async => null,
  );

  test('downloads, checks the pinned hash, and reports progress', () async {
    final client = MockClient(
      (_) async => http.Response.bytes(bytes, HttpStatus.ok),
    );
    final service = serviceFor(client);
    final progress = <int>[];

    final filePath = await service.download(
      testModel(),
      onProgress: (received, total) => progress.add(received),
    );

    expect(await File(filePath).readAsBytes(), bytes);
    expect(await service.verifyInstalledFile(testModel(), filePath), isTrue);
    expect(progress, contains(bytes.length));
  });

  test('resumes a partial file with a Range request', () async {
    final model = testModel();
    final service = serviceFor(
      MockClient((request) async {
        expect(request.headers['Range'], 'bytes=2-');
        return http.Response.bytes(bytes.sublist(2), HttpStatus.partialContent);
      }),
    );
    final modelDirectory = Directory(await service.modelDirectoryPath());
    final partial = File('${modelDirectory.path}/${model.fileName}.part');
    await partial.writeAsBytes(bytes.sublist(0, 2));

    final filePath = await service.download(model, onProgress: (_, _) {});

    expect(await File(filePath).readAsBytes(), bytes);
    expect(await partial.exists(), isFalse);
  });

  test('deletes a file when its checksum does not match', () async {
    final model = testModel(hash: List.filled(64, '0').join());
    final service = serviceFor(
      MockClient((_) async => http.Response.bytes(bytes, HttpStatus.ok)),
    );

    await expectLater(
      service.download(model, onProgress: (_, _) {}),
      throwsA(isA<FileSystemException>()),
    );
    final partial = File('${await service.modelFilePath(model)}.part');
    expect(await partial.exists(), isFalse);
  });

  test(
    'rejects a download when the device reports too little free storage',
    () async {
      final service = ModelDownloadService(
        clientFactory: () => MockClient((_) async => http.Response('', 200)),
        supportDirectory: () async => temporaryDirectory,
        availableStorage: () async => 1,
      );

      await expectLater(
        service.download(testModel(), onProgress: (_, _) {}),
        throwsA(isA<InsufficientStorageException>()),
      );
    },
  );
}
