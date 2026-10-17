import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/config/model_catalog.dart';
import '../../core/providers/app_providers.dart';
import '../../core/services/model_download_service.dart';
import '../../core/storage/app_database.dart';

final modelLibraryControllerProvider =
    AsyncNotifierProvider<ModelLibraryController, ModelLibraryState>(
      ModelLibraryController.new,
    );

class ModelLocalState {
  const ModelLocalState({
    this.status = ModelInstallStatus.notInstalled,
    this.progress = 0,
    this.receivedBytes = 0,
    this.filePath,
    this.error,
  });

  final ModelInstallStatus status;
  final double progress;
  final int receivedBytes;
  final String? filePath;
  final String? error;

  ModelLocalState copyWith({
    ModelInstallStatus? status,
    double? progress,
    int? receivedBytes,
    String? filePath,
    String? error,
    bool clearError = false,
    bool clearFilePath = false,
  }) => ModelLocalState(
    status: status ?? this.status,
    progress: progress ?? this.progress,
    receivedBytes: receivedBytes ?? this.receivedBytes,
    filePath: clearFilePath ? null : (filePath ?? this.filePath),
    error: clearError ? null : (error ?? this.error),
  );
}

class ModelLibraryState {
  const ModelLibraryState({
    required this.models,
    required this.selectedModelId,
    this.loadedModelId,
    this.switching = false,
  });

  final Map<String, ModelLocalState> models;
  final String? selectedModelId;
  final String? loadedModelId;
  final bool switching;

  ModelLocalState model(String id) => models[id] ?? const ModelLocalState();

  ModelLibraryState copyWith({
    Map<String, ModelLocalState>? models,
    String? selectedModelId,
    String? loadedModelId,
    bool? switching,
    bool clearLoadedModelId = false,
  }) => ModelLibraryState(
    models: models ?? this.models,
    selectedModelId: selectedModelId ?? this.selectedModelId,
    loadedModelId: clearLoadedModelId
        ? null
        : (loadedModelId ?? this.loadedModelId),
    switching: switching ?? this.switching,
  );
}

class ModelLibraryController extends AsyncNotifier<ModelLibraryState> {
  SharedPreferences? _preferences;
  Future<void> _selectionQueue = Future<void>.value();

  @override
  Future<ModelLibraryState> build() async {
    final database = ref.read(appDatabaseProvider);
    _preferences = await SharedPreferences.getInstance();
    final models = <String, ModelLocalState>{
      for (final model in modelCatalog) model.id: const ModelLocalState(),
    };
    final rows = await database.select(database.installedModels).get();
    for (final row in rows) {
      if (!models.containsKey(row.modelId)) continue;
      final file = File(row.filePath);
      if (await file.exists() && await file.length() == row.sizeBytes) {
        models[row.modelId] = ModelLocalState(
          status: ModelInstallStatus.installed,
          progress: 1,
          receivedBytes: row.sizeBytes,
          filePath: row.filePath,
        );
      } else {
        await database.deleteInstalledModel(row.modelId);
      }
    }
    final savedSelection = _preferences?.getString('selectedModelId');
    final selected = models.containsKey(savedSelection)
        ? savedSelection
        : 'qwen3-06b-q4';
    await database.markInterruptedGenerations();
    return ModelLibraryState(models: models, selectedModelId: selected);
  }

  Future<void> downloadModel(String modelId) async {
    final current = state.requireValue;
    final existing = current.model(modelId);
    if (existing.status == ModelInstallStatus.downloading) return;
    final model = modelById(modelId);
    _setModel(
      modelId,
      existing.copyWith(
        status: ModelInstallStatus.downloading,
        progress: 0,
        receivedBytes: 0,
        clearError: true,
      ),
    );
    try {
      final path = await ref
          .read(modelDownloadServiceProvider)
          .download(
            model,
            onProgress: (received, total) {
              final progress = total == 0 ? 0.0 : received / total;
              _setModel(
                modelId,
                state.requireValue
                    .model(modelId)
                    .copyWith(
                      status: ModelInstallStatus.downloading,
                      progress: progress.clamp(0.0, 1.0),
                      receivedBytes: received,
                    ),
              );
            },
          );
      await ref
          .read(appDatabaseProvider)
          .saveInstalledModel(
            modelId: modelId,
            filePath: path,
            sha256: model.sha256,
            sizeBytes: model.sizeBytes,
          );
      _setModel(
        modelId,
        ModelLocalState(
          status: ModelInstallStatus.installed,
          progress: 1,
          receivedBytes: model.sizeBytes,
          filePath: path,
        ),
      );
    } on DownloadCancelledException {
      final latest = state.requireValue.model(modelId);
      _setModel(
        modelId,
        latest.copyWith(
          status: ModelInstallStatus.notInstalled,
          clearError: true,
        ),
      );
    } catch (error) {
      _setModel(
        modelId,
        state.requireValue
            .model(modelId)
            .copyWith(
              status: ModelInstallStatus.error,
              error: _downloadError(error),
            ),
      );
    }
  }

  Future<void> cancelDownload(String modelId) async {
    await ref.read(modelDownloadServiceProvider).cancel(modelId);
  }

  Future<void> selectModel(
    String modelId, {
    List<ChatMessage> conversation = const [],
  }) {
    final selection = _selectionQueue.then(
      (_) => _selectModel(modelId, conversation: conversation),
    );
    _selectionQueue = selection.then<void>((_) {}, onError: (_, _) {});
    return selection;
  }

  Future<void> _selectModel(
    String modelId, {
    required List<ChatMessage> conversation,
  }) async {
    final current = state.requireValue;
    final local = current.model(modelId);
    if (local.status != ModelInstallStatus.installed &&
        local.status != ModelInstallStatus.ready &&
        !(local.status == ModelInstallStatus.error && local.filePath != null)) {
      throw StateError('Hãy tải model về thiết bị trước khi chọn.');
    }
    final filePath = local.filePath;
    if (filePath == null) throw StateError('Không tìm thấy tệp model.');
    final modelFile = File(filePath);
    if (!await modelFile.exists() ||
        await modelFile.length() != modelById(modelId).sizeBytes) {
      await ref.read(appDatabaseProvider).deleteInstalledModel(modelId);
      _setModel(modelId, const ModelLocalState());
      throw StateError('Tệp model bị thiếu hoặc sai kích thước. Hãy tải lại.');
    }

    final models = Map<String, ModelLocalState>.of(current.models);
    if (current.loadedModelId != null && current.loadedModelId != modelId) {
      final oldState = models[current.loadedModelId];
      if (oldState != null) {
        models[current.loadedModelId!] = oldState.copyWith(
          status: ModelInstallStatus.installed,
        );
      }
    }
    state = AsyncData(current.copyWith(models: models, switching: true));

    final inference = ref.read(inferenceGatewayProvider);
    final previousModelId = inference.loadedModelId;
    final transitionTimer = Stopwatch()..start();
    try {
      await inference.cancelGeneration();
      await inference.loadModel(
        modelById(modelId),
        filePath,
        onStatus: (status) {
          _setModel(
            modelId,
            state.requireValue.model(modelId).copyWith(status: status),
          );
        },
      );
      await inference.activateConversation(conversation);
      transitionTimer.stop();
      await _preferences?.setString('selectedModelId', modelId);
      _setModel(
        modelId,
        state.requireValue
            .model(modelId)
            .copyWith(status: ModelInstallStatus.ready, clearError: true),
      );
      final updated = state.requireValue;
      state = AsyncData(
        updated.copyWith(
          selectedModelId: modelId,
          loadedModelId: modelId,
          switching: false,
        ),
      );
      if (previousModelId != modelId) {
        try {
          await ref
              .read(performanceServiceProvider)
              .recordModelTransition(
                modelId: modelId,
                previousModelId: previousModelId,
                durationMs: transitionTimer.elapsedMilliseconds,
              );
        } catch (_) {
          // A local metrics write must not turn a successful model load into an error.
        }
      }
    } catch (error) {
      _setModel(
        modelId,
        state.requireValue
            .model(modelId)
            .copyWith(
              status: ModelInstallStatus.error,
              error: _loadError(error),
            ),
      );
      state = AsyncData(
        state.requireValue.copyWith(clearLoadedModelId: true, switching: false),
      );
      rethrow;
    }
  }

  Future<void> removeModel(String modelId) async {
    final current = state.requireValue;
    if (current.loadedModelId == modelId) {
      await ref.read(inferenceGatewayProvider).unload();
    }
    final filePath = current.model(modelId).filePath;
    if (filePath != null) {
      await ref.read(modelDownloadServiceProvider).deleteModelFile(filePath);
    }
    await ref.read(appDatabaseProvider).deleteInstalledModel(modelId);
    final nextModels = Map<String, ModelLocalState>.of(current.models)
      ..[modelId] = const ModelLocalState();
    state = AsyncData(
      current.copyWith(
        models: nextModels,
        clearLoadedModelId: current.loadedModelId == modelId,
      ),
    );
  }

  void _setModel(String id, ModelLocalState localState) {
    final current = state.requireValue;
    state = AsyncData(
      current.copyWith(
        models: Map<String, ModelLocalState>.of(current.models)
          ..[id] = localState,
      ),
    );
  }

  String _downloadError(Object error) {
    if (error is InsufficientStorageException) {
      return 'Không đủ dung lượng trống. Hãy giải phóng thêm bộ nhớ rồi thử lại.';
    }
    if (error is FileSystemException && error.message.contains('SHA-256')) {
      return 'Tệp tải về không khớp checksum nên đã bị xoá. Hãy thử lại.';
    }
    if (error is SocketException || error is HttpException) {
      return 'Không thể tải model. Kiểm tra kết nối mạng rồi thử lại.';
    }
    return 'Tải model thất bại: ${error.toString()}';
  }

  String _loadError(Object error) {
    final message = error.toString().toLowerCase();
    if (message.contains('memory') || message.contains('alloc')) {
      return 'Không đủ bộ nhớ để nạp model. Hãy đóng ứng dụng khác hoặc chọn model nhỏ hơn.';
    }
    return 'Không thể nạp model này trên thiết bị: ${error.toString()}';
  }
}
