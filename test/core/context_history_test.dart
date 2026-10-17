import 'package:flutter_test/flutter_test.dart';
import 'package:local_ai_chatbot/core/services/context_history.dart';
import 'package:local_ai_chatbot/core/storage/app_database.dart';

void main() {
  ChatMessage message(String id, String role, String status, String content) =>
      ChatMessage(
        id: id,
        conversationId: 'conversation',
        role: role,
        content: content,
        status: status,
        createdAt: DateTime.utc(2026, 10, 16),
      );

  test('keeps only recent complete user and assistant messages', () {
    final input = [
      message('old', 'user', 'complete', 'oldest'),
      message('u1', 'user', 'complete', 'question'),
      message('a1', 'assistant', 'complete', 'answer'),
      message('u2', 'user', 'complete', 'next question'),
      message('a2', 'assistant', 'generating', 'partial'),
      message('system', 'system', 'complete', 'ignored'),
    ];

    final result = conversationHistoryForInference(input, maxMessages: 3);

    expect(result.map((item) => item.id), ['u1', 'a1', 'u2']);
  });
}
