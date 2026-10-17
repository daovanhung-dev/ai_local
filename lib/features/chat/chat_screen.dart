import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/model_catalog.dart';
import '../../features/models/model_library_controller.dart';
import '../settings/settings_controller.dart';
import 'chat_controller.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen>
    with WidgetsBindingObserver {
  final TextEditingController _composer = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _didInitialize = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _initialize());
  }

  Future<void> _initialize() async {
    if (_didInitialize || !mounted) return;
    _didInitialize = true;
    try {
      await ref.read(modelLibraryControllerProvider.future);
      await ref.read(settingsControllerProvider.future);
      await ref.read(chatControllerProvider.notifier).initialize();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể khởi tạo dữ liệu local.')),
        );
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    if (lifecycleState == AppLifecycleState.paused ||
        lifecycleState == AppLifecycleState.inactive) {
      unawaited(ref.read(chatControllerProvider.notifier).stopGeneration());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _composer.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chat = ref.watch(chatControllerProvider);
    final modelLibrary = ref.watch(modelLibraryControllerProvider).value;
    final selectedModel = modelLibrary?.selectedModelId == null
        ? null
        : modelById(modelLibrary!.selectedModelId!);
    ref.listen(chatControllerProvider, (previous, next) {
      final oldText = previous == null || previous.messages.isEmpty
          ? ''
          : previous.messages.last.content;
      final newText = next.messages.isEmpty ? '' : next.messages.last.content;
      if (previous?.messages.length != next.messages.length ||
          oldText != newText) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }
    });

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 18,
        title: const Text('Local AI'),
        actions: [
          TextButton.icon(
            onPressed: _showModelPicker,
            icon: const Icon(Icons.memory_outlined, size: 19),
            label: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 140),
              child: Text(
                selectedModel?.name ?? 'Chọn model',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Cuộc trò chuyện mới',
            onPressed: () =>
                ref.read(chatControllerProvider.notifier).newConversation(),
            icon: const Icon(Icons.add_comment_outlined),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          if (chat.notice != null)
            MaterialBanner(
              content: Text(chat.notice!),
              leading: const Icon(Icons.info_outline),
              actions: [
                TextButton(
                  onPressed: ref
                      .read(chatControllerProvider.notifier)
                      .clearNotice,
                  child: const Text('Đóng'),
                ),
                if (chat.notice!.contains('Thư viện model'))
                  TextButton(
                    onPressed: _showModelPicker,
                    child: const Text('Chọn model'),
                  ),
              ],
            ),
          if (chat.isLoadingModel) const LinearProgressIndicator(minHeight: 2),
          Expanded(
            child: chat.messages.isEmpty
                ? _WelcomePanel(modelName: selectedModel?.name)
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                    itemCount: chat.messages.length,
                    itemBuilder: (context, index) =>
                        _MessageBubble(message: chat.messages[index]),
                  ),
          ),
          _Composer(
            controller: _composer,
            generating: chat.isGenerating,
            loadingModel: chat.isLoadingModel,
            onSend: _send,
            onStop: () =>
                ref.read(chatControllerProvider.notifier).stopGeneration(),
          ),
        ],
      ),
    );
  }

  void _send() {
    final prompt = _composer.text;
    if (prompt.trim().isEmpty) return;
    _composer.clear();
    unawaited(ref.read(chatControllerProvider.notifier).send(prompt));
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
    );
  }

  Future<void> _showModelPicker() async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => const _ModelPickerSheet(),
    );
  }
}

class _WelcomePanel extends StatelessWidget {
  const _WelcomePanel({this.modelName});

  final String? modelName;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: color.primaryContainer,
                borderRadius: BorderRadius.circular(26),
              ),
              child: Icon(Icons.auto_awesome, size: 34, color: color.primary),
            ),
            const SizedBox(height: 20),
            Text(
              'Trò chuyện riêng tư, ngay trên thiết bị',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Text(
              modelName == null
                  ? 'Tải một model trong Thư viện model để bắt đầu.'
                  : 'Đang chọn $modelName. Hãy nhập câu hỏi để bắt đầu.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: color.onSurfaceVariant),
            ),
            const SizedBox(height: 14),
            const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.wifi_off, size: 16),
                SizedBox(width: 6),
                Text('Inference chạy offline'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final ChatLine message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';
    final colors = Theme.of(context).colorScheme;
    final matchingModel = modelCatalog.where(
      (model) => model.id == message.modelId,
    );
    final modelName = matchingModel.isEmpty ? null : matchingModel.first.name;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.84,
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            color: isUser ? colors.primaryContainer : colors.surfaceContainer,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
              bottomLeft: Radius.circular(isUser ? 20 : 5),
              bottomRight: Radius.circular(isUser ? 5 : 20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isUser && modelName != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    modelName,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              if (message.content.isNotEmpty)
                SelectableText(message.content)
              else if (message.status == 'generating')
                const SizedBox(
                  width: 20,
                  height: 18,
                  child: Center(
                    child: SizedBox.square(
                      dimension: 15,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
              if (!isUser &&
                  message.status != 'complete' &&
                  message.status != 'generating')
                Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: Text(
                    switch (message.status) {
                      'stopped' => 'Đã dừng',
                      'interrupted' => 'Đã gián đoạn',
                      'error' => 'Có lỗi khi tạo câu trả lời',
                      _ => '',
                    },
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: colors.error),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.generating,
    required this.loadingModel,
    required this.onSend,
    required this.onStop,
  });

  final TextEditingController controller;
  final bool generating;
  final bool loadingModel;
  final VoidCallback onSend;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                decoration: const InputDecoration(
                  hintText: 'Nhắn tin cho Local AI…',
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 48,
              height: 48,
              child: FilledButton(
                onPressed: generating
                    ? onStop
                    : loadingModel
                    ? null
                    : onSend,
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: const CircleBorder(),
                  backgroundColor: generating ? colors.error : colors.primary,
                ),
                child: Icon(
                  generating ? Icons.stop_rounded : Icons.arrow_upward,
                  color: generating ? colors.onError : colors.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModelPickerSheet extends ConsumerWidget {
  const _ModelPickerSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final library = ref.watch(modelLibraryControllerProvider);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Chọn model', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Chỉ một model được nạp tại một thời điểm.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Flexible(
              child: library.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Text('Không đọc được model: $error'),
                data: (state) => ListView(
                  shrinkWrap: true,
                  children: [
                    for (final model in modelCatalog)
                      _PickerModelTile(
                        model: model,
                        local: state.model(model.id),
                        selected: state.selectedModelId == model.id,
                        onTap: () async {
                          final controller = ref.read(
                            modelLibraryControllerProvider.notifier,
                          );
                          final local = state.model(model.id);
                          if (local.status == ModelInstallStatus.installed ||
                              local.status == ModelInstallStatus.ready ||
                              (local.status == ModelInstallStatus.error &&
                                  local.filePath != null)) {
                            await ref
                                .read(chatControllerProvider.notifier)
                                .switchModel(model.id);
                            if (context.mounted) Navigator.pop(context);
                            return;
                          }
                          if (local.status == ModelInstallStatus.downloading) {
                            await controller.cancelDownload(model.id);
                            return;
                          }
                          await controller.downloadModel(model.id);
                          final updated = ref
                              .read(modelLibraryControllerProvider)
                              .value
                              ?.model(model.id);
                          if ((updated?.status ==
                                      ModelInstallStatus.installed ||
                                  updated?.filePath != null) &&
                              context.mounted) {
                            await ref
                                .read(chatControllerProvider.notifier)
                                .switchModel(model.id);
                            if (context.mounted) Navigator.pop(context);
                          }
                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PickerModelTile extends StatelessWidget {
  const _PickerModelTile({
    required this.model,
    required this.local,
    required this.selected,
    required this.onTap,
  });

  final ModelManifestEntry model;
  final ModelLocalState local;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ready = local.status == ModelInstallStatus.ready;
    final installed = local.status == ModelInstallStatus.installed || ready;
    final downloading = local.status == ModelInstallStatus.downloading;
    final tierLabel = switch (model.tier) {
      ModelTier.fast => 'Nhanh',
      ModelTier.balanced => 'Cân bằng',
      ModelTier.quality => 'Chất lượng',
    };
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        child: Icon(switch (model.tier) {
          ModelTier.fast => Icons.bolt,
          ModelTier.balanced => Icons.balance,
          ModelTier.quality => Icons.auto_awesome,
        }),
      ),
      title: Text(model.name),
      subtitle: Text(
        downloading
            ? 'Đang tải ${(local.progress * 100).round()}%'
            : '${model.formattedSize} • $tierLabel',
      ),
      trailing: downloading
          ? const Icon(Icons.close)
          : selected && ready
          ? const Icon(Icons.check_circle)
          : Icon(installed ? Icons.play_arrow : Icons.download_outlined),
      onTap: onTap,
    );
  }
}
