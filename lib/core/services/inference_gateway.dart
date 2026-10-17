import '../config/model_catalog.dart';
import '../storage/app_database.dart';

abstract interface class InferenceGateway {
  String? get loadedModelId;

  bool get isGenerating;

  Future<void> loadModel(
    ModelManifestEntry model,
    String filePath, {
    required void Function(ModelInstallStatus status) onStatus,
  });

  Future<void> activateConversation(List<ChatMessage> messages);

  Stream<String> generate(String prompt, {required PerformanceProfile profile});

  Future<void> cancelGeneration();

  Future<void> unload();

  Future<int> countTokens(String text);
}

enum PerformanceProfile { fast, balanced, quality }
