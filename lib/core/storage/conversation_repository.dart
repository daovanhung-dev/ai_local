import 'package:uuid/uuid.dart';

import 'app_database.dart';

class ConversationRepository {
  ConversationRepository(this._database);

  final AppDatabase _database;
  final Uuid _uuid = const Uuid();

  Stream<List<ChatConversation>> watchConversations() =>
      _database.watchConversations();

  Stream<List<ChatMessage>> watchMessages(String conversationId) =>
      _database.watchMessages(conversationId);

  Future<List<ChatMessage>> messagesFor(String conversationId) =>
      _database.messagesFor(conversationId);

  Future<ChatConversation?> conversationById(String id) =>
      _database.conversationById(id);

  Future<String> createConversation({String? modelId}) async {
    final id = _uuid.v4();
    final now = DateTime.now().toUtc();
    await _database.saveConversation(
      id: id,
      title: 'Cuộc trò chuyện mới',
      createdAt: now,
      updatedAt: now,
      lastModelId: modelId,
    );
    return id;
  }

  Future<String> addMessage({
    required String conversationId,
    required String role,
    required String content,
    required String status,
    String? modelId,
    int? tokenCount,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now().toUtc();
    await _database.saveMessage(
      id: id,
      conversationId: conversationId,
      role: role,
      content: content,
      modelId: modelId,
      status: status,
      tokenCount: tokenCount,
      createdAt: now,
    );
    await _database.updateConversation(
      id: conversationId,
      updatedAt: now,
      lastModelId: modelId,
      title: role == 'user' && content.trim().isNotEmpty
          ? _shortTitle(content)
          : null,
    );
    return id;
  }

  Future<void> updateMessage({
    required String id,
    required String content,
    required String status,
    int? tokenCount,
  }) => _database.updateMessage(
    id: id,
    content: content,
    status: status,
    tokenCount: tokenCount,
  );

  Future<void> deleteConversation(String id) =>
      _database.deleteConversation(id);

  Future<void> markInterruptedGenerations() =>
      _database.markInterruptedGenerations();

  String _shortTitle(String content) {
    final normalized = content.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (normalized.length <= 40) return normalized;
    return '${normalized.substring(0, 39)}…';
  }
}
