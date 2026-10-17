import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_ai_chatbot/core/config/model_catalog.dart';
import 'package:local_ai_chatbot/core/providers/app_providers.dart';
import 'package:local_ai_chatbot/core/services/device_profile_service.dart';
import 'package:local_ai_chatbot/features/models/model_library_controller.dart';
import 'package:local_ai_chatbot/features/models/model_library_screen.dart';

class _FakeModelLibraryController extends ModelLibraryController {
  @override
  Future<ModelLibraryState> build() async => ModelLibraryState(
    models: {
      for (final model in modelCatalog) model.id: const ModelLocalState(),
    },
    selectedModelId: 'qwen3-06b-q4',
  );
}

void main() {
  testWidgets('shows the three verified models and download actions', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          modelLibraryControllerProvider.overrideWith(
            _FakeModelLibraryController.new,
          ),
          deviceProfileProvider.overrideWith(
            (ref) async => const DeviceProfile(
              deviceId: 'test-device',
              deviceName: 'Test device',
              platform: 'test',
              totalMemoryBytes: 8 * 1024 * 1024 * 1024,
              availableMemoryBytes: 7 * 1024 * 1024 * 1024,
              availableStorageBytes: 16 * 1024 * 1024 * 1024,
            ),
          ),
        ],
        child: const MaterialApp(home: ModelLibraryScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Gemma 3 270M'), findsOneWidget);
    expect(find.text('Qwen3 0.6B'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Qwen3 1.7B'),
      420,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Qwen3 1.7B'), findsOneWidget);
    expect(find.text('Tải về'), findsWidgets);
  });
}
