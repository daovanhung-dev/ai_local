import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_ai_chatbot/core/storage/app_database.dart';
import 'package:local_ai_chatbot/core/storage/conversation_repository.dart';

void main() {
  late AppDatabase database;
  late ConversationRepository repository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = ConversationRepository(database);
  });

  tearDown(() async => database.close());

  test(
    'persists a conversation and marks an unfinished answer interrupted',
    () async {
      final conversationId = await repository.createConversation(
        modelId: 'qwen3-06b-q4',
      );
      await repository.addMessage(
        conversationId: conversationId,
        role: 'user',
        content: 'Xin chào',
        status: 'complete',
        modelId: 'qwen3-06b-q4',
      );
      await repository.addMessage(
        conversationId: conversationId,
        role: 'assistant',
        content: 'Xin chào bạn',
        status: 'generating',
        modelId: 'qwen3-06b-q4',
      );

      await repository.markInterruptedGenerations();
      final savedConversation = await repository.conversationById(
        conversationId,
      );
      final savedMessages = await repository.messagesFor(conversationId);

      expect(savedConversation?.title, 'Xin chào');
      expect(savedConversation?.lastModelId, 'qwen3-06b-q4');
      expect(savedMessages, hasLength(2));
      expect(savedMessages.last.status, 'interrupted');
    },
  );
}
