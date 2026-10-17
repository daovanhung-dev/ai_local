import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_ai_chatbot/core/config/model_catalog.dart';
import 'package:local_ai_chatbot/core/providers/app_providers.dart';
import 'package:local_ai_chatbot/core/services/device_profile_service.dart';
import 'package:local_ai_chatbot/core/services/inference_gateway.dart';
import 'package:local_ai_chatbot/core/storage/app_database.dart';
import 'package:local_ai_chatbot/core/storage/conversation_repository.dart';
import 'package:local_ai_chatbot/features/chat/chat_controller.dart';
import 'package:local_ai_chatbot/features/models/model_library_controller.dart';
import 'package:local_ai_chatbot/features/settings/settings_controller.dart';

class _FakeInference implements InferenceGateway {
  _FakeInference({this.waitForCancel = false});

  final bool waitForCancel;
  final Completer<void> started = Completer<void>();
  int generateCalls = 0;
  StreamController<String>? _stream;

  @override
  String? get loadedModelId => 'qwen3-06b-q4';

  @override
  bool get isGenerating => false;

  @override
  Future<void> loadModel(
    ModelManifestEntry model,
    String filePath, {
    required void Function(ModelInstallStatus status) onStatus,
  }) async {}

  @override
  Future<void> activateConversation(List<ChatMessage> messages) async {}

  @override
  Stream<String> generate(
    String prompt, {
    required PerformanceProfile profile,
  }) {
    generateCalls++;
    started.complete();
    if (!waitForCancel) return Stream.fromIterable(['Local ', 'answer']);
    _stream = StreamController<String>();
    return _stream!.stream;
  }

  @override
  Future<void> cancelGeneration() async {
    await _stream?.close();
  }

  @override
  Future<void> unload() async {}

  @override
  Future<int> countTokens(String text) async =>
      text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;
}

class _FakeModelLibraryController extends ModelLibraryController {
  @override
  Future<ModelLibraryState> build() async => ModelLibraryState(
    models: {
      for (final model in modelCatalog)
        model.id: ModelLocalState(
          status: ModelInstallStatus.ready,
          filePath: '/mock/${model.fileName}',
        ),
    },
    selectedModelId: 'qwen3-06b-q4',
    loadedModelId: 'qwen3-06b-q4',
  );
}

class _FakeSettingsController extends SettingsController {
  @override
  Future<PerformanceProfile> build() async => PerformanceProfile.balanced;
}

class _FakeDeviceProfileService extends DeviceProfileService {
  @override
  Future<DeviceProfile> readProfile() async => const DeviceProfile(
    deviceId: 'test-device',
    deviceName: 'Test device',
    platform: 'test',
    totalMemoryBytes: 8 * 1024 * 1024 * 1024,
    thermalState: 'normal',
  );
}

void main() {
  late AppDatabase database;
  late ProviderContainer container;

  ProviderContainer createContainer(_FakeInference inference) {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    return ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        conversationRepositoryProvider.overrideWithValue(
          ConversationRepository(database),
        ),
        inferenceGatewayProvider.overrideWithValue(inference),
        deviceProfileServiceProvider.overrideWith(
          (ref) => _FakeDeviceProfileService(),
        ),
        modelLibraryControllerProvider.overrideWith(
          _FakeModelLibraryController.new,
        ),
        settingsControllerProvider.overrideWith(_FakeSettingsController.new),
      ],
    );
  }

  setUp(() async {
    final inference = _FakeInference();
    container = createContainer(inference);
    await container.read(modelLibraryControllerProvider.future);
    await container.read(settingsControllerProvider.future);
  });

  tearDown(() async {
    container.dispose();
    await database.close();
  });

  test('streams and persists an assistant answer', () async {
    final controller = container.read(chatControllerProvider.notifier);
    await controller.initialize();
    await controller.send('Xin chào');

    final state = container.read(chatControllerProvider);
    expect(state.isGenerating, isFalse);
    expect(state.messages.map((message) => message.content), [
      'Xin chào',
      'Local answer',
    ]);
    expect(state.messages.last.status, 'complete');
    final persisted = await container
        .read(conversationRepositoryProvider)
        .messagesFor(state.conversationId!);
    expect(persisted.last.content, 'Local answer');
  });

  test('stop keeps the partial response and marks it stopped', () async {
    container.dispose();
    await database.close();
    final inference = _FakeInference(waitForCancel: true);
    container = createContainer(inference);
    await container.read(modelLibraryControllerProvider.future);
    await container.read(settingsControllerProvider.future);
    final controller = container.read(chatControllerProvider.notifier);
    await controller.initialize();
    final sending = controller.send('Viết một câu');
    await controller.send('Không được gửi trùng');
    await inference.started.future;
    inference._stream!.add('Phần đã tạo');
    await Future<void>.delayed(Duration.zero);
    await controller.stopGeneration();
    await sending;

    final state = container.read(chatControllerProvider);
    expect(state.messages.last.content, 'Phần đã tạo');
    expect(state.messages.last.status, 'stopped');
    expect(state.isGenerating, isFalse);
    expect(inference.generateCalls, 1);
    expect(
      state.messages.where((message) => message.role == 'user'),
      hasLength(1),
    );
  });
}
