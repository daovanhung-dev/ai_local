import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/config/model_catalog.dart';
import '../../core/services/device_profile_service.dart';
import '../../core/providers/app_providers.dart';
import '../chat/chat_controller.dart';
import 'model_library_controller.dart';

class ModelLibraryScreen extends ConsumerWidget {
  const ModelLibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final library = ref.watch(modelLibraryControllerProvider);
    final device = ref.watch(deviceProfileProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Thư viện model')),
      body: library.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Không đọc được thư viện model: $error'),
          ),
        ),
        data: (state) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            _LibraryIntro(device: device.value),
            const SizedBox(height: 14),
            for (final model in modelCatalog)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ModelCard(
                  model: model,
                  local: state.model(model.id),
                  selected: state.selectedModelId == model.id,
                  loaded: state.loadedModelId == model.id,
                  switching: state.switching,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _LibraryIntro extends StatelessWidget {
  const _LibraryIntro({this.device});

  final DeviceProfile? device;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.offline_bolt, color: theme.colorScheme.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'AI chạy trên thiết bị của bạn',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Cần Internet để tải model. Sau khi tải xong, chat hoạt động offline và nội dung không rời khỏi thiết bị.',
              style: theme.textTheme.bodyMedium,
            ),
            if (device != null) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _InfoChip(
                    icon: Icons.phone_android,
                    label: device!.deviceName,
                  ),
                  _InfoChip(
                    icon: Icons.memory,
                    label: device!.totalMemoryBytes == null
                        ? 'RAM chưa xác định'
                        : '${(device!.totalMemoryBytes! / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB RAM',
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Chip(
    visualDensity: VisualDensity.compact,
    avatar: Icon(icon, size: 16),
    label: Text(label, overflow: TextOverflow.ellipsis),
  );
}

class _ModelCard extends ConsumerWidget {
  const _ModelCard({
    required this.model,
    required this.local,
    required this.selected,
    required this.loaded,
    required this.switching,
  });

  final ModelManifestEntry model;
  final ModelLocalState local;
  final bool selected;
  final bool loaded;
  final bool switching;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final device = ref.watch(deviceProfileProvider).value;
    final downloaded = local.filePath != null;
    final downloading = local.status == ModelInstallStatus.downloading;
    final installing =
        local.status == ModelInstallStatus.loading ||
        local.status == ModelInstallStatus.warming;
    final tooLarge = device != null && !device.canProbablyLoad(model);
    final tierLabel = switch (model.tier) {
      ModelTier.fast => 'FAST',
      ModelTier.balanced => 'BALANCED',
      ModelTier.quality => 'QUALITY',
    };
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(_tierIcon(model.tier), color: colors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 3),
                      Text(model.description),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: colors.secondaryContainer,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    tierLabel,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _InfoChip(
                  icon: Icons.storage_outlined,
                  label: model.formattedSize,
                ),
                _InfoChip(icon: Icons.tune, label: model.quantization),
                _InfoChip(
                  icon: Icons.memory_outlined,
                  label:
                      'RAM khuyến nghị ≥ ${(model.recommendedRamBytes / (1024 * 1024 * 1024)).round()} GB',
                ),
              ],
            ),
            if (tooLarge) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: colors.error,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Model có thể vượt quá bộ nhớ hiện còn. Hãy ưu tiên model nhỏ hơn.',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: colors.error),
                    ),
                  ),
                ],
              ),
            ],
            if (downloading) ...[
              const SizedBox(height: 14),
              LinearProgressIndicator(value: local.progress),
              const SizedBox(height: 6),
              Text(
                '${(local.progress * 100).round()}% • ${_formatBytes(local.receivedBytes)} / ${model.formattedSize}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            if (installing) ...[
              const SizedBox(height: 14),
              const LinearProgressIndicator(),
              const SizedBox(height: 6),
              Text(
                local.status == ModelInstallStatus.warming
                    ? 'Đang làm nóng model…'
                    : 'Đang nạp model…',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            if (local.status == ModelInstallStatus.error &&
                local.error != null) ...[
              const SizedBox(height: 10),
              Text(
                local.error!,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: colors.error),
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _showLicense(context),
                    icon: const Icon(Icons.policy_outlined, size: 18),
                    label: Text(model.license),
                  ),
                ),
                IconButton(
                  tooltip: 'Mở điều khoản model',
                  onPressed: () => launchUrl(
                    Uri.parse(model.licenseUrl),
                    mode: LaunchMode.externalApplication,
                  ),
                  icon: const Icon(Icons.open_in_new, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 4),
            _action(context, ref, downloaded, downloading, installing, loaded),
          ],
        ),
      ),
    );
  }

  Widget _action(
    BuildContext context,
    WidgetRef ref,
    bool downloaded,
    bool downloading,
    bool installing,
    bool loaded,
  ) {
    if (downloading) {
      return OutlinedButton.icon(
        onPressed: () => ref
            .read(modelLibraryControllerProvider.notifier)
            .cancelDownload(model.id),
        icon: const Icon(Icons.close),
        label: const Text('Huỷ tải'),
      );
    }
    if (installing || switching) {
      return OutlinedButton.icon(
        onPressed: null,
        icon: SizedBox.square(
          dimension: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        label: Text('Đang chuyển model'),
      );
    }
    if (!downloaded) {
      return FilledButton.icon(
        onPressed: () => ref
            .read(modelLibraryControllerProvider.notifier)
            .downloadModel(model.id),
        icon: const Icon(Icons.download),
        label: Text(
          local.status == ModelInstallStatus.error ? 'Thử tải lại' : 'Tải về',
        ),
      );
    }
    return Row(
      children: [
        Expanded(
          child: loaded
              ? FilledButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.check),
                  label: const Text('Đang sử dụng'),
                )
              : FilledButton.icon(
                  onPressed: () => ref
                      .read(chatControllerProvider.notifier)
                      .switchModel(model.id),
                  icon: const Icon(Icons.play_arrow),
                  label: Text(
                    local.status == ModelInstallStatus.error
                        ? 'Thử nạp lại'
                        : selected
                        ? 'Nạp model'
                        : 'Dùng model',
                  ),
                ),
        ),
        const SizedBox(width: 8),
        IconButton.outlined(
          tooltip: 'Xoá model',
          onPressed: loaded ? null : () => _confirmDelete(context, ref),
          icon: const Icon(Icons.delete_outline),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xoá model?'),
        content: Text('Tệp ${model.name} sẽ bị xoá khỏi thiết bị.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Giữ lại'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xoá'),
          ),
        ],
      ),
    );
    if (shouldDelete == true) {
      await ref
          .read(modelLibraryControllerProvider.notifier)
          .removeModel(model.id);
    }
  }

  Future<void> _showLicense(BuildContext context) => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Điều khoản • ${model.name}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Giấy phép: ${model.license}'),
          const SizedBox(height: 12),
          const Text(
            'Model được tải riêng, không nằm trong gói cài đặt ứng dụng.',
          ),
          const SizedBox(height: 12),
          SelectableText(model.licenseUrl),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Đóng'),
        ),
      ],
    ),
  );

  IconData _tierIcon(ModelTier tier) => switch (tier) {
    ModelTier.fast => Icons.bolt,
    ModelTier.balanced => Icons.balance,
    ModelTier.quality => Icons.auto_awesome,
  };

  String _formatBytes(int bytes) {
    if (bytes < 1024 * 1024) return '${(bytes / 1024).round()} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(0)} MB';
  }
}
