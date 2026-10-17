import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/providers/app_providers.dart';
import '../../core/services/inference_gateway.dart';

final settingsControllerProvider =
    AsyncNotifierProvider<SettingsController, PerformanceProfile>(
      SettingsController.new,
    );

class SettingsController extends AsyncNotifier<PerformanceProfile> {
  SharedPreferences? _preferences;

  @override
  Future<PerformanceProfile> build() async {
    _preferences = await SharedPreferences.getInstance();
    final saved = _preferences?.getString('performanceProfile');
    if (saved != null) {
      return PerformanceProfile.values.firstWhere(
        (profile) => profile.name == saved,
        orElse: () => PerformanceProfile.balanced,
      );
    }
    final device = await ref.read(deviceProfileServiceProvider).readProfile();
    return switch (device.recommendedTier.name) {
      'fast' => PerformanceProfile.fast,
      'quality' => PerformanceProfile.quality,
      _ => PerformanceProfile.balanced,
    };
  }

  Future<void> setProfile(PerformanceProfile profile) async {
    state = AsyncData(profile);
    await _preferences?.setString('performanceProfile', profile.name);
  }
}
