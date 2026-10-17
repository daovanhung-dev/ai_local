import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:llamadart/llamadart.dart';

import '../config/model_catalog.dart';
import '../storage/app_database.dart';
import 'context_history.dart';
import 'inference_gateway.dart';

class LocalInferenceService implements InferenceGateway {
  LlamaEngine? _engine;
  ChatSession? _session;
  ModelManifestEntry? _model;
  bool _isGenerating = false;

  @override
  String? get loadedModelId => _model?.id;

  @override
  bool get isGenerating => _isGenerating;

  @override
  Future<void> loadModel(
    ModelManifestEntry model,
    String filePath, {
    required void Function(ModelInstallStatus status) onStatus,
  }) async {
    if (_model?.id == model.id && _engine != null) return;
    await unload();
    onStatus(ModelInstallStatus.loading);
    try {
      final engine = await LlamaEngine.load(
        LlamaModel(ModelSource.path(filePath)),
        params: ModelParams(
          contextSize: model.contextSize,
          gpuLayers: Platform.isIOS ? -1 : 0,
          device: Platform.isAndroid ? ComputeDevice.cpu : ComputeDevice.auto,
          preferredBackend: Platform.isIOS ? GpuBackend.metal : GpuBackend.auto,
          numberOfThreads: 0,
          numberOfThreadsBatch: 0,
          useMmap: true,
        ),
      );
      _engine = engine;
      _model = model;
      final prompt = model.supportsThinking
          ? 'Bạn là trợ lý AI hữu ích. Trả lời bằng tiếng Việt rõ ràng, ngắn gọn. /no_think'
          : 'Bạn là trợ lý AI hữu ích. Trả lời bằng tiếng Việt rõ ràng, ngắn gọn.';
      _session = ChatSession(
        engine,
        maxContextTokens: model.contextSize - 128,
        systemPrompt: prompt,
      );
      onStatus(ModelInstallStatus.warming);
      final warmup = _session!.create(
        const [LlamaTextContent('Trả lời bằng từ OK.')],
        params: const GenerationParams(
          maxTokens: 1,
          temp: 0,
          streamBatchTokenThreshold: 1,
        ),
        enableThinking: false,
      );
      await warmup.drain<void>();
      _session!.reset();
      onStatus(ModelInstallStatus.ready);
    } catch (_) {
      await unload();
      rethrow;
    }
  }

  @override
  Future<void> activateConversation(List<ChatMessage> messages) async {
    final session = _session;
    if (session == null) return;
    session.reset();
    final recent = conversationHistoryForInference(messages);
    for (final message in recent) {
      session.addMessage(
        LlamaChatMessage.fromText(
          role: message.role == 'user'
              ? LlamaChatRole.user
              : LlamaChatRole.assistant,
          text: message.content,
        ),
      );
    }
  }

  @override
  Stream<String> generate(
    String prompt, {
    required PerformanceProfile profile,
  }) async* {
    final session = _session;
    final model = _model;
    if (session == null || model == null) {
      throw StateError('Chưa nạp model.');
    }
    if (_isGenerating) throw StateError('Model đang tạo câu trả lời khác.');

    _isGenerating = true;
    try {
      final settings = switch (profile) {
        PerformanceProfile.fast => (maxTokens: 96, temperature: 0.55),
        PerformanceProfile.balanced => (maxTokens: 128, temperature: 0.7),
        PerformanceProfile.quality => (maxTokens: 256, temperature: 0.7),
      };
      await for (final chunk in session.create(
        [LlamaTextContent(prompt)],
        params: GenerationParams(
          maxTokens: settings.maxTokens,
          temp: settings.temperature,
          topK: 20,
          topP: 0.8,
          reusePromptPrefix: true,
          streamBatchTokenThreshold: 1,
        ),
        enableThinking: false,
      )) {
        if (chunk.text.isNotEmpty) yield chunk.text;
      }
    } finally {
      _isGenerating = false;
    }
  }

  @override
  Future<void> cancelGeneration() async {
    _engine?.cancelGeneration();
  }

  @override
  Future<void> unload() async {
    final engine = _engine;
    _session = null;
    _engine = null;
    _model = null;
    _isGenerating = false;
    if (engine != null) await engine.dispose();
  }

  @override
  Future<int> countTokens(String text) async {
    final engine = _engine;
    if (engine == null || text.isEmpty) return 0;
    try {
      return (await engine.tokenize(text)).length;
    } catch (error) {
      debugPrint('Token count failed: $error');
      return 0;
    }
  }
}
