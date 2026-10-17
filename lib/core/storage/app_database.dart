import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DataClassName('ChatConversation')
class Conversations extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get lastModelId => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@TableIndex(
  name: 'messages_conversation_created_idx',
  columns: {#conversationId, #createdAt},
)
@DataClassName('ChatMessage')
class Messages extends Table {
  TextColumn get id => text()();
  TextColumn get conversationId =>
      text().references(Conversations, #id, onDelete: KeyAction.cascade)();
  TextColumn get role => text()();
  TextColumn get content => text()();
  TextColumn get modelId => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('complete'))();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get tokenCount => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class InstalledModels extends Table {
  TextColumn get modelId => text()();
  TextColumn get filePath => text()();
  TextColumn get status => text().withDefault(const Constant('installed'))();
  DateTimeColumn get installedAt => dateTime().nullable()();
  TextColumn get sha256 => text()();
  IntColumn get sizeBytes => integer()();

  @override
  Set<Column<Object>> get primaryKey => {modelId};
}

class Benchmarks extends Table {
  TextColumn get id => text()();
  TextColumn get deviceId => text()();
  TextColumn get modelId => text()();
  TextColumn get backend => text()();
  IntColumn get contextTokens => integer()();
  IntColumn get promptTokens => integer()();
  BoolColumn get warm => boolean()();
  IntColumn get ttftMs => integer().nullable()();
  IntColumn get loadTimeMs => integer().nullable()();
  IntColumn get switchTimeMs => integer().nullable()();
  IntColumn get prefillMs => integer().nullable()();
  RealColumn get decodeTokensPerSecond => real().nullable()();
  IntColumn get peakMemoryMb => integer().nullable()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get thermalState => text().nullable()();
  TextColumn get error => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(tables: [Conversations, Messages, InstalledModels, Benchmarks])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.addColumn(benchmarks, benchmarks.loadTimeMs);
        await migrator.addColumn(benchmarks, benchmarks.switchTimeMs);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      await customStatement(
        'CREATE INDEX IF NOT EXISTS conversations_updated_idx '
        'ON conversations (updated_at)',
      );
      if (details.wasCreated) {
        await customStatement(
          "UPDATE messages SET status = 'interrupted' "
          "WHERE status = 'generating'",
        );
      }
    },
  );

  Future<void> markInterruptedGenerations() async {
    await (update(messages)..where((row) => row.status.equals('generating')))
        .write(const MessagesCompanion(status: Value('interrupted')));
  }

  Stream<List<ChatConversation>> watchConversations() => (select(
    conversations,
  )..orderBy([(row) => OrderingTerm.desc(row.updatedAt)])).watch();

  Future<ChatConversation?> conversationById(String id) => (select(
    conversations,
  )..where((row) => row.id.equals(id))).getSingleOrNull();

  Future<List<ChatMessage>> messagesFor(String conversationId) =>
      (select(messages)
            ..where((row) => row.conversationId.equals(conversationId))
            ..orderBy([(row) => OrderingTerm.asc(row.createdAt)]))
          .get();

  Stream<List<ChatMessage>> watchMessages(String conversationId) =>
      (select(messages)
            ..where((row) => row.conversationId.equals(conversationId))
            ..orderBy([(row) => OrderingTerm.asc(row.createdAt)]))
          .watch();

  Future<void> saveConversation({
    required String id,
    required String title,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? lastModelId,
  }) => into(conversations).insertOnConflictUpdate(
    ConversationsCompanion.insert(
      id: id,
      title: title,
      createdAt: createdAt,
      updatedAt: updatedAt,
      lastModelId: Value(lastModelId),
    ),
  );

  Future<void> updateConversation({
    required String id,
    DateTime? updatedAt,
    String? title,
    String? lastModelId,
  }) => (update(conversations)..where((row) => row.id.equals(id))).write(
    ConversationsCompanion(
      updatedAt: Value(updatedAt ?? DateTime.now().toUtc()),
      title: title == null ? const Value.absent() : Value(title),
      lastModelId: Value(lastModelId),
    ),
  );

  Future<void> saveMessage({
    required String id,
    required String conversationId,
    required String role,
    required String content,
    required DateTime createdAt,
    String? modelId,
    String status = 'complete',
    int? tokenCount,
  }) => into(messages).insertOnConflictUpdate(
    MessagesCompanion.insert(
      id: id,
      conversationId: conversationId,
      role: role,
      content: content,
      createdAt: createdAt,
      modelId: Value(modelId),
      status: Value(status),
      tokenCount: Value(tokenCount),
    ),
  );

  Future<void> updateMessage({
    required String id,
    required String content,
    required String status,
    int? tokenCount,
  }) => (update(messages)..where((row) => row.id.equals(id))).write(
    MessagesCompanion(
      content: Value(content),
      status: Value(status),
      tokenCount: Value(tokenCount),
    ),
  );

  Future<void> deleteConversation(String id) async {
    await (delete(conversations)..where((row) => row.id.equals(id))).go();
  }

  Future<InstalledModel?> installedModel(String modelId) => (select(
    installedModels,
  )..where((row) => row.modelId.equals(modelId))).getSingleOrNull();

  Future<void> saveInstalledModel({
    required String modelId,
    required String filePath,
    required String sha256,
    required int sizeBytes,
  }) => into(installedModels).insertOnConflictUpdate(
    InstalledModelsCompanion.insert(
      modelId: modelId,
      filePath: filePath,
      installedAt: Value(DateTime.now().toUtc()),
      sha256: sha256,
      sizeBytes: sizeBytes,
    ),
  );

  Future<void> deleteInstalledModel(String modelId) async {
    await (delete(
      installedModels,
    )..where((row) => row.modelId.equals(modelId))).go();
  }

  Future<void> saveBenchmark(BenchmarksCompanion benchmark) async {
    await into(benchmarks).insertOnConflictUpdate(benchmark);
  }
}

LazyDatabase _openConnection() => LazyDatabase(() async {
  final supportDirectory = await getApplicationSupportDirectory();
  await supportDirectory.create(recursive: true);
  final file = File(p.join(supportDirectory.path, 'local_ai.sqlite'));
  return NativeDatabase.createInBackground(file);
});
