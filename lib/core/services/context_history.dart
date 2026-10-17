import '../storage/app_database.dart';

List<ChatMessage> conversationHistoryForInference(
  List<ChatMessage> messages, {
  int maxMessages = 16,
}) {
  final relevant = messages
      .where(
        (message) =>
            (message.role == 'user' || message.role == 'assistant') &&
            message.status != 'generating' &&
            message.content.isNotEmpty,
      )
      .toList(growable: false);
  if (relevant.length <= maxMessages) return relevant;
  return relevant.sublist(relevant.length - maxMessages);
}
