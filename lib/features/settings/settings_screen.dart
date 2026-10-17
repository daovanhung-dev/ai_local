import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/providers/app_providers.dart';
import '../../core/config/model_catalog.dart';
import '../../core/services/inference_gateway.dart';
import '../../core/storage/app_database.dart';
import 'settings_controller.dart';

final benchmarkHistoryProvider = FutureProvider<List<Benchmark>>((ref) async {
  final database = ref.watch(appDatabaseProvider);
  return (database.select(database.benchmarks)
        ..orderBy([(row) => OrderingTerm.desc(row.timestamp)])
        ..limit(10))
      .get();
});

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);
    final device = ref.watch(deviceProfileProvider);
    final benchmarks = ref.watch(benchmarkHistoryProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Cài đặt')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _SectionCard(
            title: 'Hiệu năng',
            icon: Icons.speed,
            child: settings.when(
              loading: () => const LinearProgressIndicator(),
              error: (error, stack) => Text('Không đọc được cài đặt: $error'),
              data: (selected) => RadioGroup<PerformanceProfile>(
                groupValue: selected,
                onChanged: (value) {
                  if (value != null) {
                    ref
                        .read(settingsControllerProvider.notifier)
                        .setProfile(value);
                  }
                },
                child: Column(
                  children: [
                    for (final profile in PerformanceProfile.values)
                      RadioListTile<PerformanceProfile>(
                        value: profile,
                        title: Text(_profileName(profile)),
                        subtitle: Text(_profileDescription(profile)),
                        contentPadding: EdgeInsets.zero,
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _SectionCard(
            title: 'Thiết bị',
            icon: Icons.phone_android,
            child: device.when(
              loading: () => const LinearProgressIndicator(),
              error: (error, stack) =>
                  const Text('Chưa đọc được thông tin thiết bị.'),
              data: (profile) => Column(
                children: [
                  _DetailRow(label: 'Thiết bị', value: profile.deviceName),
                  _DetailRow(label: 'Nền tảng', value: profile.platform),
                  _DetailRow(
                    label: 'RAM',
                    value: profile.totalMemoryBytes == null
                        ? 'Chưa xác định'
                        : '${(profile.totalMemoryBytes! / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB',
                  ),
                  _DetailRow(
                    label: 'Dung lượng trống',
                    value: profile.availableStorageBytes == null
                        ? 'Chưa xác định'
                        : '${(profile.availableStorageBytes! / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB',
                  ),
                  _DetailRow(label: 'Nhiệt độ', value: profile.thermalState),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _SectionCard(
            title: 'Đo hiệu năng gần đây',
            icon: Icons.monitor_heart_outlined,
            child: benchmarks.when(
              loading: () => const LinearProgressIndicator(),
              error: (error, stack) =>
                  const Text('Chưa đọc được dữ liệu benchmark.'),
              data: (items) => items.isEmpty
                  ? const Text(
                      'Chưa có kết quả. Thông số được ghi local sau mỗi lượt chat.',
                    )
                  : Column(
                      children: [
                        for (final item in items.take(5))
                          _DetailRow(
                            label: item.modelId,
                            value: item.error != null
                                ? 'Lỗi'
                                : item.loadTimeMs != null
                                ? 'Nạp ${item.loadTimeMs} ms${item.switchTimeMs == null ? '' : ' • chuyển ${item.switchTimeMs} ms'}'
                                : item.ttftMs == null
                                ? 'TTFT —'
                                : 'TTFT ${item.ttftMs} ms${item.warm ? ' • warm' : ' • cold'}',
                          ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 12),
          _SectionCard(
            title: 'Quyền riêng tư',
            icon: Icons.lock_outline,
            child: const Text(
              'Tin nhắn và lịch sử lưu trên thiết bị. Không có tài khoản, đồng bộ hay telemetry. Kết nối mạng chỉ dùng khi tải model hoặc mở trang điều khoản.',
            ),
          ),
          const SizedBox(height: 12),
          _SectionCard(
            title: 'Giấy phép model',
            icon: Icons.policy_outlined,
            child: Column(
              children: [
                for (final model in modelCatalog)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(model.name),
                    subtitle: Text(model.license),
                    trailing: const Icon(Icons.open_in_new),
                    onTap: () => launchUrl(
                      Uri.parse(model.licenseUrl),
                      mode: LaunchMode.externalApplication,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Center(child: Text('Local AI • MVP • llamadart 0.13.1')),
        ],
      ),
    );
  }

  String _profileName(PerformanceProfile profile) => switch (profile) {
    PerformanceProfile.fast => 'Nhanh',
    PerformanceProfile.balanced => 'Cân bằng',
    PerformanceProfile.quality => 'Chất lượng',
  };

  String _profileDescription(PerformanceProfile profile) => switch (profile) {
    PerformanceProfile.fast => 'Câu trả lời ngắn hơn, ưu tiên độ trễ thấp.',
    PerformanceProfile.balanced =>
      'Thiết lập mặc định cho hội thoại thường ngày.',
    PerformanceProfile.quality =>
      'Cho phép câu trả lời dài hơn; cân nhắc chọn model lớn.',
  };
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 9),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    ),
  );
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Text(label)),
        const SizedBox(width: 10),
        Flexible(child: Text(value, textAlign: TextAlign.end)),
      ],
    ),
  );
}
