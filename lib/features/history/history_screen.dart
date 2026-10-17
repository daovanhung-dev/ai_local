import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/app_providers.dart';
import '../chat/chat_controller.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({required this.onOpen, super.key});

  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversations = ref.watch(conversationsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Lịch sử chat')),
      body: conversations.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('Không đọc được lịch sử: $error')),
        data: (items) {
          if (items.isEmpty) {
            return const Center(
              child: Text('Các cuộc trò chuyện sẽ xuất hiện ở đây.'),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  leading: const CircleAvatar(
                    child: Icon(Icons.chat_bubble_outline),
                  ),
                  title: Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(_formatDate(item.updatedAt)),
                  onTap: () => onOpen(item.id),
                  trailing: PopupMenuButton<String>(
                    onSelected: (action) async {
                      if (action != 'delete') return;
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Xoá cuộc trò chuyện?'),
                          content: const Text(
                            'Tin nhắn trong cuộc trò chuyện này sẽ bị xoá khỏi thiết bị.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Huỷ'),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Xoá'),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        await ref
                            .read(conversationRepositoryProvider)
                            .deleteConversation(item.id);
                        final chat = ref.read(chatControllerProvider);
                        if (chat.conversationId == item.id) {
                          await ref
                              .read(chatControllerProvider.notifier)
                              .newConversation();
                        }
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: 'delete',
                        child: Text('Xoá khỏi thiết bị'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    String two(int value) => value.toString().padLeft(2, '0');
    return '${two(local.day)}/${two(local.month)}/${local.year} • ${two(local.hour)}:${two(local.minute)}';
  }
}
