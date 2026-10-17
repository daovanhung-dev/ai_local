import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';

import '../config/model_catalog.dart';

class DeviceProfile {
  const DeviceProfile({
    required this.deviceId,
    required this.deviceName,
    required this.platform,
    this.totalMemoryBytes,
    this.availableMemoryBytes,
    this.availableStorageBytes,
    this.thermalState = 'unknown',
  });

  final String deviceId;
  final String deviceName;
  final String platform;
  final int? totalMemoryBytes;
  final int? availableMemoryBytes;
  final int? availableStorageBytes;
  final String thermalState;

  ModelTier get recommendedTier {
    final memory = totalMemoryBytes;
    if (memory == null || memory < 4 * 1024 * 1024 * 1024) {
      return ModelTier.fast;
    }
    if (memory < 7 * 1024 * 1024 * 1024) return ModelTier.balanced;
    return ModelTier.quality;
  }

  bool canProbablyLoad(ModelManifestEntry model) {
    final memory = availableMemoryBytes ?? totalMemoryBytes;
    if (memory == null) return true;
    return memory >= model.recommendedRamBytes;
  }
}

class DeviceProfileService {
  static const _channel = MethodChannel('com.localai.chatbot/device');
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  Future<DeviceProfile> readProfile() async {
    final nativeStats = await _readNativeStats();
    var deviceName = Platform.operatingSystem;
    var deviceId = Platform.operatingSystem;

    try {
      if (Platform.isAndroid) {
        final info = await _deviceInfo.androidInfo;
        deviceId = '${info.manufacturer}-${info.model}'.toLowerCase();
        deviceName = '${info.manufacturer} ${info.model}'.trim();
      } else if (Platform.isIOS) {
        final info = await _deviceInfo.iosInfo;
        deviceId = info.utsname.machine;
        deviceName = info.name;
      }
    } catch (_) {
      // The native runtime stats remain useful when device identification fails.
    }

    return DeviceProfile(
      deviceId: deviceId,
      deviceName: deviceName,
      platform: Platform.operatingSystem,
      totalMemoryBytes: nativeStats?['totalMemoryBytes'] as int?,
      availableMemoryBytes: nativeStats?['availableMemoryBytes'] as int?,
      availableStorageBytes: nativeStats?['availableStorageBytes'] as int?,
      thermalState: nativeStats?['thermalState'] as String? ?? 'unknown',
    );
  }

  Future<Map<String, Object?>?> _readNativeStats() async {
    try {
      return await _channel.invokeMapMethod<String, Object?>('deviceStats');
    } on MissingPluginException {
      return null;
    } on PlatformException {
      return null;
    }
  }
}
