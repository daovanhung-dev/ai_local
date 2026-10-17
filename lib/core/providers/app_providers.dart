import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/device_profile_service.dart';
import '../services/inference_gateway.dart';
import '../services/local_inference_service.dart';
import '../services/model_download_service.dart';
import '../services/performance_service.dart';
import '../storage/app_database.dart';
import '../storage/conversation_repository.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(() => database.close());
  return database;
});

final conversationRepositoryProvider = Provider<ConversationRepository>(
  (ref) => ConversationRepository(ref.watch(appDatabaseProvider)),
);

final modelDownloadServiceProvider = Provider<ModelDownloadService>(
  (ref) => ModelDownloadService(),
);

final inferenceGatewayProvider = Provider<InferenceGateway>((ref) {
  final service = LocalInferenceService();
  ref.onDispose(() => service.unload());
  return service;
});

final deviceProfileServiceProvider = Provider<DeviceProfileService>(
  (ref) => DeviceProfileService(),
);

final performanceServiceProvider = Provider<PerformanceService>(
  (ref) => PerformanceService(
    database: ref.watch(appDatabaseProvider),
    deviceProfileService: ref.watch(deviceProfileServiceProvider),
    inference: ref.watch(inferenceGatewayProvider),
  ),
);

final conversationsProvider = StreamProvider((ref) {
  return ref.watch(conversationRepositoryProvider).watchConversations();
});

final deviceProfileProvider = FutureProvider(
  (ref) => ref.watch(deviceProfileServiceProvider).readProfile(),
);
