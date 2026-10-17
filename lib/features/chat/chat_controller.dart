import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/model_catalog.dart';
import '../../core/providers/app_providers.dart';
import '../../core/services/inference_gateway.dart';
import '../../core/storage/app_database.dart';
import '../models/model_library_controller.dart';
import '../settings/settings_controller.dart';

final chatControllerProvider = NotifierProvider<ChatController, ChatUiState>(
  ChatController.new,
);

class ChatLine {
  const ChatLine({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
    this.modelId,
    this.status = 'complete',
  });

  final String id;
  final String role;
  final String content;
  final DateTime createdAt;
  final String? modelId;
  final String status;

  ChatLine copyWith({String? content, String? status}) => ChatLine(
    id: id,
    role: role,
    content: content ?? this.content,
    createdAt: createdAt,
    modelId: modelId,
    status: status ?? this.status,
  );

  factory ChatLine.fromRecord(ChatMessage message) => ChatLine(
    id: message.id,
    role: message.role,
    content: message.content,
    modelId: message.modelId,
    status: message.status,
    createdAt: message.createdAt,
  );
}

class ChatUiState {
  const ChatUiState({
    this.initialized = false,
    this.conversationId,
    this.messages = const [],
    this.isGenerating = false,
    this.isLoadingModel = false,
    this.notice,
  });

  final bool initialized;
  final String? conversationId;
  final List<ChatLine> messages;
  final bool isGenerating;
  final bool isLoadingModel;
  final String? notice;

  ChatUiState copyWith({
    bool? initialized,
    String? conversationId,
    List<ChatLine>? messages,
    bool? isGenerating,
    bool? isLoadingModel,
    String? notice,
    bool clearNotice = false,
  }) => ChatUiState(
    initialized: initialized ?? this.initialized,
    conversationId: conversationId ?? this.conversationId,
    messages: messages ?? this.messages,
    isGenerating: isGenerating ?? this.isGenerating,
    isLoadingModel: isLoadingModel ?? this.isLoadingModel,
    notice: clearNotice ? null : (notice ?? this.notice),
  );
}

class ChatController extends Notifier<ChatUiState> {
  bool _stopRequested = false;
  bool _sendInProgress = false;
  Completer<void>? _sendCompletion;

  @override
  ChatUiState build() => const ChatUiState();

  Future<void> initialize() async {
    if (state.initialized) return;
    final modelLibrary = ref.read(modelLibraryControllerProvider).value;
    final id = await ref
        .read(conversationRepositoryProvider)
        .createConversation(modelId: modelLibrary?.selectedModelId);
    state = state.copyWith(initialized: true, conversationId: id);
    final selected = modelLibrary?.selectedModelId;
    if (selected != null &&
        modelLibrary!.model(selected).status == ModelInstallStatus.installed) {
      state = state.copyWith(isLoadingModel: true);
      try {
        await ref
            .read(modelLibraryControllerProvider.notifier)
            .selectModel(selected, conversation: const []);
      } catch (error) {
        state = state.copyWith(notice: _friendlyError(error));
      } finally {
        state = state.copyWith(isLoadingModel: false);
      }
    }
  }

  Future<void> newConversation() async {
    if (state.isGenerating) await stopGeneration();
    final selected = ref
        .read(modelLibraryControllerProvider)
        .value
        ?.selectedModelId;
    final id = await ref
        .read(conversationRepositoryProvider)
        .createConversation(modelId: selected);
    state = ChatUiState(initialized: true, conversationId: id);
    await ref.read(inferenceGatewayProvider).activateConversation(const []);
  }

  Future<void> openConversation(String conversationId) async {
    if (state.isGenerating) await stopGeneration();
    final repository = ref.read(conversationRepositoryProvider);
    final conversation = await repository.conversationById(conversationId);
    if (conversation == null) return;
    final records = await repository.messagesFor(conversationId);
    state = ChatUiState(
      initialized: true,
      conversationId: conversationId,
      messages: records.map(ChatLine.fromRecord).toList(growable: false),
    );
    final library = ref.read(modelLibraryControllerProvider).value;
    final modelId = conversation.lastModelId ?? library?.selectedModelId;
    if (modelId == null || library == null) return;
    if (library.model(modelId).status == ModelInstallStatus.installed ||
        library.model(modelId).status == ModelInstallStatus.ready) {
      state = state.copyWith(isLoadingModel: true);
      try {
        await ref
            .read(modelLibraryControllerProvider.notifier)
            .selectModel(modelId, conversation: records);
      } catch (error) {
        state = state.copyWith(notice: _friendlyError(error));
      } finally {
        state = state.copyWith(isLoadingModel: false);
      }
    } else {
      state = state.copyWith(
        notice:
            'Hội thoại này dùng model ${modelById(modelId).name}. Hãy tải model để tiếp tục.',
      );
    }
  }

  Future<void> switchModel(String modelId) async {
    if (state.isGenerating) await stopGeneration();
    final library = ref.read(modelLibraryControllerProvider).value;
    if (library == null) return;
    if (library.model(modelId).status != ModelInstallStatus.installed &&
        library.model(modelId).status != ModelInstallStatus.ready &&
        !(library.model(modelId).status == ModelInstallStatus.error &&
            library.model(modelId).filePath != null)) {
      state = state.copyWith(notice: 'Hãy tải model về trước khi sử dụng.');
      return;
    }
    state = state.copyWith(isLoadingModel: true, clearNotice: true);
    try {
      final history = state.conversationId == null
          ? const <ChatMessage>[]
          : await ref
                .read(conversationRepositoryProvider)
                .messagesFor(state.conversationId!);
      await ref
          .read(modelLibraryControllerProvider.notifier)
          .selectModel(modelId, conversation: history);
      final conversationId = state.conversationId;
      if (conversationId != null) {
        await ref
            .read(appDatabaseProvider)
            .updateConversation(id: conversationId, lastModelId: modelId);
      }
    } catch (error) {
      state = state.copyWith(notice: _friendlyError(error));
    } finally {
      state = state.copyWith(isLoadingModel: false);
    }
  }

  Future<void> send(String text) async {
    final prompt = text.trim();
    if (prompt.isEmpty ||
        state.isGenerating ||
        state.isLoadingModel ||
        _sendInProgress) {
      return;
    }
    _sendInProgress = true;
    final completion = Completer<void>();
    _sendCompletion = completion;
    try {
      await _sendPrompt(prompt);
    } finally {
      _sendInProgress = false;
      if (!completion.isCompleted) completion.complete();
      if (identical(_sendCompletion, completion)) _sendCompletion = null;
    }
  }

  Future<void> _sendPrompt(String prompt) async {
    final timer = Stopwatch()..start();
    if (!state.initialized) await initialize();

    final library = ref.read(modelLibraryControllerProvider).value;
    final modelId = library?.selectedModelId;
    if (modelId == null || library == null) {
      state = state.copyWith(notice: 'Đang khởi tạo thư viện model.');
      return;
    }
    final localModel = library.model(modelId);
    if (localModel.status != ModelInstallStatus.installed &&
        localModel.status != ModelInstallStatus.ready &&
        !(localModel.status == ModelInstallStatus.error &&
            localModel.filePath != null)) {
      state = state.copyWith(
        notice:
            'Hãy tải ${modelById(modelId).name} trong Thư viện model trước khi chat.',
      );
      return;
    }

    final wasWarm = library.loadedModelId == modelId;
    if (!wasWarm || localModel.status != ModelInstallStatus.ready) {
      state = state.copyWith(isLoadingModel: true, clearNotice: true);
      try {
        final history = state.conversationId == null
            ? const <ChatMessage>[]
            : await ref
                  .read(conversationRepositoryProvider)
                  .messagesFor(state.conversationId!);
        await ref
            .read(modelLibraryControllerProvider.notifier)
            .selectModel(modelId, conversation: history);
      } catch (error) {
        state = state.copyWith(
          isLoadingModel: false,
          notice: _friendlyError(error),
        );
        return;
      }
      state = state.copyWith(isLoadingModel: false);
    }

    final conversationId = state.conversationId;
    if (conversationId == null) return;
    final repository = ref.read(conversationRepositoryProvider);
    final now = DateTime.now().toUtc();
    final userId = await repository.addMessage(
      conversationId: conversationId,
      role: 'user',
      content: prompt,
      status: 'complete',
      modelId: modelId,
    );
    final assistantId = await repository.addMessage(
      conversationId: conversationId,
      role: 'assistant',
      content: '',
      status: 'generating',
      modelId: modelId,
    );
    final messages = [
      ...state.messages,
      ChatLine(
        id: userId,
        role: 'user',
        content: prompt,
        modelId: modelId,
        createdAt: now,
      ),
      ChatLine(
        id: assistantId,
        role: 'assistant',
        content: '',
        modelId: modelId,
        status: 'generating',
        createdAt: DateTime.now().toUtc(),
      ),
    ];
    state = state.copyWith(
      messages: messages,
      isGenerating: true,
      clearNotice: true,
    );

    final inference = ref.read(inferenceGatewayProvider);
    final performance = ref.read(performanceServiceProvider);
    final selectedProfile =
        ref.read(settingsControllerProvider).value ??
        PerformanceProfile.balanced;
    final memoryBefore = ProcessInfo.currentRss;
    int? ttftMs;
    var output = StringBuffer();
    var lastUiFlush = Duration.zero;
    var lastDatabaseFlush = Duration.zero;
    Object? generationError;
    _stopRequested = false;

    try {
      await for (final delta in inference.generate(
        prompt,
        profile: selectedProfile,
      )) {
        if (delta.isEmpty) continue;
        final isFirstVisibleText = ttftMs == null;
        ttftMs ??= timer.elapsedMilliseconds;
        output.write(delta);
        final elapsed = timer.elapsed;
        if (isFirstVisibleText ||
            elapsed - lastUiFlush >= const Duration(milliseconds: 40)) {
          _replaceLine(
            assistantId,
            content: output.toString(),
            status: 'generating',
          );
          lastUiFlush = elapsed;
        }
        if (elapsed - lastDatabaseFlush >= const Duration(milliseconds: 400)) {
          await repository.updateMessage(
            id: assistantId,
            content: output.toString(),
            status: 'generating',
          );
          lastDatabaseFlush = elapsed;
        }
      }
    } catch (error) {
      generationError = error;
    } finally {
      timer.stop();
      final content = output.toString();
      final status = _stopRequested
          ? 'stopped'
          : generationError == null
          ? 'complete'
          : 'error';
      final outputTokens = content.isEmpty
          ? 0
          : await performance.countTokens(content);
      final promptTokens = await performance.countTokens(prompt);
      await repository.updateMessage(
        id: assistantId,
        content: content,
        status: status,
        tokenCount: outputTokens,
      );
      _replaceLine(assistantId, content: content, status: status);
      state = state.copyWith(
        isGenerating: false,
        notice: generationError == null
            ? null
            : _friendlyError(generationError),
      );
      if (generationError == null) {
        await performance.recordTurn(
          modelId: modelId,
          backend: Platform.isIOS ? 'Metal' : 'CPU',
          warm: wasWarm,
          promptTokens: promptTokens,
          outputTokens: outputTokens,
          ttftMs: ttftMs,
          elapsedMs: timer.elapsedMilliseconds,
          memoryBeforeBytes: memoryBefore,
        );
      } else {
        await performance.recordError(
          modelId: modelId,
          backend: Platform.isIOS ? 'Metal' : 'CPU',
          warm: wasWarm,
          promptTokens: promptTokens,
          error: generationError.toString(),
        );
      }
    }
  }

  Future<void> stopGeneration() async {
    if (!state.isGenerating) return;
    _stopRequested = true;
    final completion = _sendCompletion;
    await ref.read(inferenceGatewayProvider).cancelGeneration();
    if (completion != null) await completion.future;
  }

  void clearNotice() {
    state = state.copyWith(clearNotice: true);
  }

  void _replaceLine(
    String id, {
    required String content,
    required String status,
  }) {
    final index = state.messages.indexWhere((message) => message.id == id);
    if (index < 0) return;
    final updated = [...state.messages];
    updated[index] = updated[index].copyWith(content: content, status: status);
    state = state.copyWith(messages: updated);
  }

  String _friendlyError(Object error) {
    final text = error.toString().toLowerCase();
    if (text.contains('memory') || text.contains('alloc')) {
      return 'Thiết bị không đủ bộ nhớ cho model này. Hãy thử model nhỏ hơn.';
    }
    if (text.contains('cancel')) return 'Đã dừng tạo câu trả lời.';
    return 'Có lỗi khi chạy model. Hãy thử lại hoặc chọn model khác.';
  }
}
