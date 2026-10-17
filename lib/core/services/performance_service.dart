import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:uuid/uuid.dart';

import 'device_profile_service.dart';
import 'inference_gateway.dart';
import '../storage/app_database.dart';

class PerformanceService {
  PerformanceService({
    required AppDatabase database,
    required DeviceProfileService deviceProfileService,
    required InferenceGateway inference,
  }) : _database = database,
       _deviceProfileService = deviceProfileService,
       _inference = inference;

  final AppDatabase _database;
  final DeviceProfileService _deviceProfileService;
  final InferenceGateway _inference;
  final Uuid _uuid = const Uuid();

  Future<void> recordModelTransition({
    required String modelId,
    required String? previousModelId,
    required int durationMs,
  }) async {
    final profile = await _deviceProfileService.readProfile();
    final backend = Platform.isIOS ? 'Metal' : 'CPU';
    await _database.saveBenchmark(
      BenchmarksCompanion.insert(
        id: _uuid.v4(),
        deviceId: profile.deviceId,
        modelId: modelId,
        backend: backend,
        contextTokens: 0,
        promptTokens: 0,
        warm: false,
        loadTimeMs: Value(durationMs),
        switchTimeMs: Value(previousModelId == null ? null : durationMs),
        timestamp: DateTime.now().toUtc(),
        thermalState: Value(profile.thermalState),
      ),
    );
  }

  Future<void> recordTurn({
    required String modelId,
    required String backend,
    required bool warm,
    required int promptTokens,
    required int outputTokens,
    required int? ttftMs,
    required int elapsedMs,
    required int memoryBeforeBytes,
  }) async {
    final profile = await _deviceProfileService.readProfile();
    final peakEstimate = ProcessInfo.currentRss > memoryBeforeBytes
        ? ProcessInfo.currentRss
        : memoryBeforeBytes;
    final decodeMs = elapsedMs - (ttftMs ?? elapsedMs);
    final decodeTps = decodeMs > 0 && outputTokens > 0
        ? outputTokens / (decodeMs / 1000)
        : null;
    await _database.saveBenchmark(
      BenchmarksCompanion.insert(
        id: _uuid.v4(),
        deviceId: profile.deviceId,
        modelId: modelId,
        backend: backend,
        contextTokens: promptTokens,
        promptTokens: promptTokens,
        warm: warm,
        ttftMs: Value(ttftMs),
        prefillMs: const Value.absent(),
        decodeTokensPerSecond: Value(decodeTps),
        peakMemoryMb: Value((peakEstimate / (1024 * 1024)).round()),
        timestamp: DateTime.now().toUtc(),
        thermalState: Value(profile.thermalState),
        error: const Value.absent(),
      ),
    );
  }

  Future<void> recordError({
    required String modelId,
    required String backend,
    required bool warm,
    required int promptTokens,
    required String error,
  }) async {
    final profile = await _deviceProfileService.readProfile();
    await _database.saveBenchmark(
      BenchmarksCompanion.insert(
        id: _uuid.v4(),
        deviceId: profile.deviceId,
        modelId: modelId,
        backend: backend,
        contextTokens: promptTokens,
        promptTokens: promptTokens,
        warm: warm,
        timestamp: DateTime.now().toUtc(),
        thermalState: Value(profile.thermalState),
        error: Value(error),
      ),
    );
  }

  Future<int> countTokens(String text) => _inference.countTokens(text);
}
