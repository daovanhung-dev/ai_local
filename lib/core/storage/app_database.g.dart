// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ConversationsTable extends Conversations
    with TableInfo<$ConversationsTable, ChatConversation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConversationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastModelIdMeta = const VerificationMeta(
    'lastModelId',
  );
  @override
  late final GeneratedColumn<String> lastModelId = GeneratedColumn<String>(
    'last_model_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    createdAt,
    updatedAt,
    lastModelId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'conversations';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChatConversation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('last_model_id')) {
      context.handle(
        _lastModelIdMeta,
        lastModelId.isAcceptableOrUnknown(
          data['last_model_id']!,
          _lastModelIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatConversation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatConversation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      lastModelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_model_id'],
      ),
    );
  }

  @override
  $ConversationsTable createAlias(String alias) {
    return $ConversationsTable(attachedDatabase, alias);
  }
}

class ChatConversation extends DataClass
    implements Insertable<ChatConversation> {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? lastModelId;
  const ChatConversation({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.lastModelId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || lastModelId != null) {
      map['last_model_id'] = Variable<String>(lastModelId);
    }
    return map;
  }

  ConversationsCompanion toCompanion(bool nullToAbsent) {
    return ConversationsCompanion(
      id: Value(id),
      title: Value(title),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      lastModelId: lastModelId == null && nullToAbsent
          ? const Value.absent()
          : Value(lastModelId),
    );
  }

  factory ChatConversation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatConversation(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      lastModelId: serializer.fromJson<String?>(json['lastModelId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'lastModelId': serializer.toJson<String?>(lastModelId),
    };
  }

  ChatConversation copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<String?> lastModelId = const Value.absent(),
  }) => ChatConversation(
    id: id ?? this.id,
    title: title ?? this.title,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    lastModelId: lastModelId.present ? lastModelId.value : this.lastModelId,
  );
  ChatConversation copyWithCompanion(ConversationsCompanion data) {
    return ChatConversation(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastModelId: data.lastModelId.present
          ? data.lastModelId.value
          : this.lastModelId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatConversation(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastModelId: $lastModelId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, createdAt, updatedAt, lastModelId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatConversation &&
          other.id == this.id &&
          other.title == this.title &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastModelId == this.lastModelId);
}

class ConversationsCompanion extends UpdateCompanion<ChatConversation> {
  final Value<String> id;
  final Value<String> title;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String?> lastModelId;
  final Value<int> rowid;
  const ConversationsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastModelId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConversationsCompanion.insert({
    required String id,
    required String title,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.lastModelId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ChatConversation> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? lastModelId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastModelId != null) 'last_model_id': lastModelId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConversationsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String?>? lastModelId,
    Value<int>? rowid,
  }) {
    return ConversationsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastModelId: lastModelId ?? this.lastModelId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (lastModelId.present) {
      map['last_model_id'] = Variable<String>(lastModelId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConversationsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastModelId: $lastModelId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MessagesTable extends Messages
    with TableInfo<$MessagesTable, ChatMessage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conversationIdMeta = const VerificationMeta(
    'conversationId',
  );
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
    'conversation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES conversations (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelIdMeta = const VerificationMeta(
    'modelId',
  );
  @override
  late final GeneratedColumn<String> modelId = GeneratedColumn<String>(
    'model_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('complete'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tokenCountMeta = const VerificationMeta(
    'tokenCount',
  );
  @override
  late final GeneratedColumn<int> tokenCount = GeneratedColumn<int>(
    'token_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    conversationId,
    role,
    content,
    modelId,
    status,
    createdAt,
    tokenCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChatMessage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(
          data['conversation_id']!,
          _conversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('model_id')) {
      context.handle(
        _modelIdMeta,
        modelId.isAcceptableOrUnknown(data['model_id']!, _modelIdMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('token_count')) {
      context.handle(
        _tokenCountMeta,
        tokenCount.isAcceptableOrUnknown(data['token_count']!, _tokenCountMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatMessage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatMessage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conversation_id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      modelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model_id'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      tokenCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}token_count'],
      ),
    );
  }

  @override
  $MessagesTable createAlias(String alias) {
    return $MessagesTable(attachedDatabase, alias);
  }
}

class ChatMessage extends DataClass implements Insertable<ChatMessage> {
  final String id;
  final String conversationId;
  final String role;
  final String content;
  final String? modelId;
  final String status;
  final DateTime createdAt;
  final int? tokenCount;
  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.role,
    required this.content,
    this.modelId,
    required this.status,
    required this.createdAt,
    this.tokenCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['conversation_id'] = Variable<String>(conversationId);
    map['role'] = Variable<String>(role);
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || modelId != null) {
      map['model_id'] = Variable<String>(modelId);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || tokenCount != null) {
      map['token_count'] = Variable<int>(tokenCount);
    }
    return map;
  }

  MessagesCompanion toCompanion(bool nullToAbsent) {
    return MessagesCompanion(
      id: Value(id),
      conversationId: Value(conversationId),
      role: Value(role),
      content: Value(content),
      modelId: modelId == null && nullToAbsent
          ? const Value.absent()
          : Value(modelId),
      status: Value(status),
      createdAt: Value(createdAt),
      tokenCount: tokenCount == null && nullToAbsent
          ? const Value.absent()
          : Value(tokenCount),
    );
  }

  factory ChatMessage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatMessage(
      id: serializer.fromJson<String>(json['id']),
      conversationId: serializer.fromJson<String>(json['conversationId']),
      role: serializer.fromJson<String>(json['role']),
      content: serializer.fromJson<String>(json['content']),
      modelId: serializer.fromJson<String?>(json['modelId']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      tokenCount: serializer.fromJson<int?>(json['tokenCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'conversationId': serializer.toJson<String>(conversationId),
      'role': serializer.toJson<String>(role),
      'content': serializer.toJson<String>(content),
      'modelId': serializer.toJson<String?>(modelId),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'tokenCount': serializer.toJson<int?>(tokenCount),
    };
  }

  ChatMessage copyWith({
    String? id,
    String? conversationId,
    String? role,
    String? content,
    Value<String?> modelId = const Value.absent(),
    String? status,
    DateTime? createdAt,
    Value<int?> tokenCount = const Value.absent(),
  }) => ChatMessage(
    id: id ?? this.id,
    conversationId: conversationId ?? this.conversationId,
    role: role ?? this.role,
    content: content ?? this.content,
    modelId: modelId.present ? modelId.value : this.modelId,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    tokenCount: tokenCount.present ? tokenCount.value : this.tokenCount,
  );
  ChatMessage copyWithCompanion(MessagesCompanion data) {
    return ChatMessage(
      id: data.id.present ? data.id.value : this.id,
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      role: data.role.present ? data.role.value : this.role,
      content: data.content.present ? data.content.value : this.content,
      modelId: data.modelId.present ? data.modelId.value : this.modelId,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      tokenCount: data.tokenCount.present
          ? data.tokenCount.value
          : this.tokenCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessage(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('modelId: $modelId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('tokenCount: $tokenCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    conversationId,
    role,
    content,
    modelId,
    status,
    createdAt,
    tokenCount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatMessage &&
          other.id == this.id &&
          other.conversationId == this.conversationId &&
          other.role == this.role &&
          other.content == this.content &&
          other.modelId == this.modelId &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.tokenCount == this.tokenCount);
}

class MessagesCompanion extends UpdateCompanion<ChatMessage> {
  final Value<String> id;
  final Value<String> conversationId;
  final Value<String> role;
  final Value<String> content;
  final Value<String?> modelId;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<int?> tokenCount;
  final Value<int> rowid;
  const MessagesCompanion({
    this.id = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.role = const Value.absent(),
    this.content = const Value.absent(),
    this.modelId = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.tokenCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MessagesCompanion.insert({
    required String id,
    required String conversationId,
    required String role,
    required String content,
    this.modelId = const Value.absent(),
    this.status = const Value.absent(),
    required DateTime createdAt,
    this.tokenCount = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       conversationId = Value(conversationId),
       role = Value(role),
       content = Value(content),
       createdAt = Value(createdAt);
  static Insertable<ChatMessage> custom({
    Expression<String>? id,
    Expression<String>? conversationId,
    Expression<String>? role,
    Expression<String>? content,
    Expression<String>? modelId,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<int>? tokenCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (conversationId != null) 'conversation_id': conversationId,
      if (role != null) 'role': role,
      if (content != null) 'content': content,
      if (modelId != null) 'model_id': modelId,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (tokenCount != null) 'token_count': tokenCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MessagesCompanion copyWith({
    Value<String>? id,
    Value<String>? conversationId,
    Value<String>? role,
    Value<String>? content,
    Value<String?>? modelId,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<int?>? tokenCount,
    Value<int>? rowid,
  }) {
    return MessagesCompanion(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      role: role ?? this.role,
      content: content ?? this.content,
      modelId: modelId ?? this.modelId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      tokenCount: tokenCount ?? this.tokenCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (modelId.present) {
      map['model_id'] = Variable<String>(modelId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (tokenCount.present) {
      map['token_count'] = Variable<int>(tokenCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessagesCompanion(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('modelId: $modelId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('tokenCount: $tokenCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InstalledModelsTable extends InstalledModels
    with TableInfo<$InstalledModelsTable, InstalledModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InstalledModelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _modelIdMeta = const VerificationMeta(
    'modelId',
  );
  @override
  late final GeneratedColumn<String> modelId = GeneratedColumn<String>(
    'model_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('installed'),
  );
  static const VerificationMeta _installedAtMeta = const VerificationMeta(
    'installedAt',
  );
  @override
  late final GeneratedColumn<DateTime> installedAt = GeneratedColumn<DateTime>(
    'installed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sha256Meta = const VerificationMeta('sha256');
  @override
  late final GeneratedColumn<String> sha256 = GeneratedColumn<String>(
    'sha256',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sizeBytesMeta = const VerificationMeta(
    'sizeBytes',
  );
  @override
  late final GeneratedColumn<int> sizeBytes = GeneratedColumn<int>(
    'size_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    modelId,
    filePath,
    status,
    installedAt,
    sha256,
    sizeBytes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'installed_models';
  @override
  VerificationContext validateIntegrity(
    Insertable<InstalledModel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('model_id')) {
      context.handle(
        _modelIdMeta,
        modelId.isAcceptableOrUnknown(data['model_id']!, _modelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_modelIdMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('installed_at')) {
      context.handle(
        _installedAtMeta,
        installedAt.isAcceptableOrUnknown(
          data['installed_at']!,
          _installedAtMeta,
        ),
      );
    }
    if (data.containsKey('sha256')) {
      context.handle(
        _sha256Meta,
        sha256.isAcceptableOrUnknown(data['sha256']!, _sha256Meta),
      );
    } else if (isInserting) {
      context.missing(_sha256Meta);
    }
    if (data.containsKey('size_bytes')) {
      context.handle(
        _sizeBytesMeta,
        sizeBytes.isAcceptableOrUnknown(data['size_bytes']!, _sizeBytesMeta),
      );
    } else if (isInserting) {
      context.missing(_sizeBytesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {modelId};
  @override
  InstalledModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InstalledModel(
      modelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model_id'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      installedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}installed_at'],
      ),
      sha256: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sha256'],
      )!,
      sizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size_bytes'],
      )!,
    );
  }

  @override
  $InstalledModelsTable createAlias(String alias) {
    return $InstalledModelsTable(attachedDatabase, alias);
  }
}

class InstalledModel extends DataClass implements Insertable<InstalledModel> {
  final String modelId;
  final String filePath;
  final String status;
  final DateTime? installedAt;
  final String sha256;
  final int sizeBytes;
  const InstalledModel({
    required this.modelId,
    required this.filePath,
    required this.status,
    this.installedAt,
    required this.sha256,
    required this.sizeBytes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['model_id'] = Variable<String>(modelId);
    map['file_path'] = Variable<String>(filePath);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || installedAt != null) {
      map['installed_at'] = Variable<DateTime>(installedAt);
    }
    map['sha256'] = Variable<String>(sha256);
    map['size_bytes'] = Variable<int>(sizeBytes);
    return map;
  }

  InstalledModelsCompanion toCompanion(bool nullToAbsent) {
    return InstalledModelsCompanion(
      modelId: Value(modelId),
      filePath: Value(filePath),
      status: Value(status),
      installedAt: installedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(installedAt),
      sha256: Value(sha256),
      sizeBytes: Value(sizeBytes),
    );
  }

  factory InstalledModel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InstalledModel(
      modelId: serializer.fromJson<String>(json['modelId']),
      filePath: serializer.fromJson<String>(json['filePath']),
      status: serializer.fromJson<String>(json['status']),
      installedAt: serializer.fromJson<DateTime?>(json['installedAt']),
      sha256: serializer.fromJson<String>(json['sha256']),
      sizeBytes: serializer.fromJson<int>(json['sizeBytes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'modelId': serializer.toJson<String>(modelId),
      'filePath': serializer.toJson<String>(filePath),
      'status': serializer.toJson<String>(status),
      'installedAt': serializer.toJson<DateTime?>(installedAt),
      'sha256': serializer.toJson<String>(sha256),
      'sizeBytes': serializer.toJson<int>(sizeBytes),
    };
  }

  InstalledModel copyWith({
    String? modelId,
    String? filePath,
    String? status,
    Value<DateTime?> installedAt = const Value.absent(),
    String? sha256,
    int? sizeBytes,
  }) => InstalledModel(
    modelId: modelId ?? this.modelId,
    filePath: filePath ?? this.filePath,
    status: status ?? this.status,
    installedAt: installedAt.present ? installedAt.value : this.installedAt,
    sha256: sha256 ?? this.sha256,
    sizeBytes: sizeBytes ?? this.sizeBytes,
  );
  InstalledModel copyWithCompanion(InstalledModelsCompanion data) {
    return InstalledModel(
      modelId: data.modelId.present ? data.modelId.value : this.modelId,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      status: data.status.present ? data.status.value : this.status,
      installedAt: data.installedAt.present
          ? data.installedAt.value
          : this.installedAt,
      sha256: data.sha256.present ? data.sha256.value : this.sha256,
      sizeBytes: data.sizeBytes.present ? data.sizeBytes.value : this.sizeBytes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InstalledModel(')
          ..write('modelId: $modelId, ')
          ..write('filePath: $filePath, ')
          ..write('status: $status, ')
          ..write('installedAt: $installedAt, ')
          ..write('sha256: $sha256, ')
          ..write('sizeBytes: $sizeBytes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(modelId, filePath, status, installedAt, sha256, sizeBytes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InstalledModel &&
          other.modelId == this.modelId &&
          other.filePath == this.filePath &&
          other.status == this.status &&
          other.installedAt == this.installedAt &&
          other.sha256 == this.sha256 &&
          other.sizeBytes == this.sizeBytes);
}

class InstalledModelsCompanion extends UpdateCompanion<InstalledModel> {
  final Value<String> modelId;
  final Value<String> filePath;
  final Value<String> status;
  final Value<DateTime?> installedAt;
  final Value<String> sha256;
  final Value<int> sizeBytes;
  final Value<int> rowid;
  const InstalledModelsCompanion({
    this.modelId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.status = const Value.absent(),
    this.installedAt = const Value.absent(),
    this.sha256 = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InstalledModelsCompanion.insert({
    required String modelId,
    required String filePath,
    this.status = const Value.absent(),
    this.installedAt = const Value.absent(),
    required String sha256,
    required int sizeBytes,
    this.rowid = const Value.absent(),
  }) : modelId = Value(modelId),
       filePath = Value(filePath),
       sha256 = Value(sha256),
       sizeBytes = Value(sizeBytes);
  static Insertable<InstalledModel> custom({
    Expression<String>? modelId,
    Expression<String>? filePath,
    Expression<String>? status,
    Expression<DateTime>? installedAt,
    Expression<String>? sha256,
    Expression<int>? sizeBytes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (modelId != null) 'model_id': modelId,
      if (filePath != null) 'file_path': filePath,
      if (status != null) 'status': status,
      if (installedAt != null) 'installed_at': installedAt,
      if (sha256 != null) 'sha256': sha256,
      if (sizeBytes != null) 'size_bytes': sizeBytes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InstalledModelsCompanion copyWith({
    Value<String>? modelId,
    Value<String>? filePath,
    Value<String>? status,
    Value<DateTime?>? installedAt,
    Value<String>? sha256,
    Value<int>? sizeBytes,
    Value<int>? rowid,
  }) {
    return InstalledModelsCompanion(
      modelId: modelId ?? this.modelId,
      filePath: filePath ?? this.filePath,
      status: status ?? this.status,
      installedAt: installedAt ?? this.installedAt,
      sha256: sha256 ?? this.sha256,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (modelId.present) {
      map['model_id'] = Variable<String>(modelId.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (installedAt.present) {
      map['installed_at'] = Variable<DateTime>(installedAt.value);
    }
    if (sha256.present) {
      map['sha256'] = Variable<String>(sha256.value);
    }
    if (sizeBytes.present) {
      map['size_bytes'] = Variable<int>(sizeBytes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InstalledModelsCompanion(')
          ..write('modelId: $modelId, ')
          ..write('filePath: $filePath, ')
          ..write('status: $status, ')
          ..write('installedAt: $installedAt, ')
          ..write('sha256: $sha256, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BenchmarksTable extends Benchmarks
    with TableInfo<$BenchmarksTable, Benchmark> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BenchmarksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelIdMeta = const VerificationMeta(
    'modelId',
  );
  @override
  late final GeneratedColumn<String> modelId = GeneratedColumn<String>(
    'model_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _backendMeta = const VerificationMeta(
    'backend',
  );
  @override
  late final GeneratedColumn<String> backend = GeneratedColumn<String>(
    'backend',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contextTokensMeta = const VerificationMeta(
    'contextTokens',
  );
  @override
  late final GeneratedColumn<int> contextTokens = GeneratedColumn<int>(
    'context_tokens',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _promptTokensMeta = const VerificationMeta(
    'promptTokens',
  );
  @override
  late final GeneratedColumn<int> promptTokens = GeneratedColumn<int>(
    'prompt_tokens',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _warmMeta = const VerificationMeta('warm');
  @override
  late final GeneratedColumn<bool> warm = GeneratedColumn<bool>(
    'warm',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("warm" IN (0, 1))',
    ),
  );
  static const VerificationMeta _ttftMsMeta = const VerificationMeta('ttftMs');
  @override
  late final GeneratedColumn<int> ttftMs = GeneratedColumn<int>(
    'ttft_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _loadTimeMsMeta = const VerificationMeta(
    'loadTimeMs',
  );
  @override
  late final GeneratedColumn<int> loadTimeMs = GeneratedColumn<int>(
    'load_time_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _switchTimeMsMeta = const VerificationMeta(
    'switchTimeMs',
  );
  @override
  late final GeneratedColumn<int> switchTimeMs = GeneratedColumn<int>(
    'switch_time_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _prefillMsMeta = const VerificationMeta(
    'prefillMs',
  );
  @override
  late final GeneratedColumn<int> prefillMs = GeneratedColumn<int>(
    'prefill_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _decodeTokensPerSecondMeta =
      const VerificationMeta('decodeTokensPerSecond');
  @override
  late final GeneratedColumn<double> decodeTokensPerSecond =
      GeneratedColumn<double>(
        'decode_tokens_per_second',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _peakMemoryMbMeta = const VerificationMeta(
    'peakMemoryMb',
  );
  @override
  late final GeneratedColumn<int> peakMemoryMb = GeneratedColumn<int>(
    'peak_memory_mb',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _thermalStateMeta = const VerificationMeta(
    'thermalState',
  );
  @override
  late final GeneratedColumn<String> thermalState = GeneratedColumn<String>(
    'thermal_state',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _errorMeta = const VerificationMeta('error');
  @override
  late final GeneratedColumn<String> error = GeneratedColumn<String>(
    'error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    deviceId,
    modelId,
    backend,
    contextTokens,
    promptTokens,
    warm,
    ttftMs,
    loadTimeMs,
    switchTimeMs,
    prefillMs,
    decodeTokensPerSecond,
    peakMemoryMb,
    timestamp,
    thermalState,
    error,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'benchmarks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Benchmark> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('model_id')) {
      context.handle(
        _modelIdMeta,
        modelId.isAcceptableOrUnknown(data['model_id']!, _modelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_modelIdMeta);
    }
    if (data.containsKey('backend')) {
      context.handle(
        _backendMeta,
        backend.isAcceptableOrUnknown(data['backend']!, _backendMeta),
      );
    } else if (isInserting) {
      context.missing(_backendMeta);
    }
    if (data.containsKey('context_tokens')) {
      context.handle(
        _contextTokensMeta,
        contextTokens.isAcceptableOrUnknown(
          data['context_tokens']!,
          _contextTokensMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contextTokensMeta);
    }
    if (data.containsKey('prompt_tokens')) {
      context.handle(
        _promptTokensMeta,
        promptTokens.isAcceptableOrUnknown(
          data['prompt_tokens']!,
          _promptTokensMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_promptTokensMeta);
    }
    if (data.containsKey('warm')) {
      context.handle(
        _warmMeta,
        warm.isAcceptableOrUnknown(data['warm']!, _warmMeta),
      );
    } else if (isInserting) {
      context.missing(_warmMeta);
    }
    if (data.containsKey('ttft_ms')) {
      context.handle(
        _ttftMsMeta,
        ttftMs.isAcceptableOrUnknown(data['ttft_ms']!, _ttftMsMeta),
      );
    }
    if (data.containsKey('load_time_ms')) {
      context.handle(
        _loadTimeMsMeta,
        loadTimeMs.isAcceptableOrUnknown(
          data['load_time_ms']!,
          _loadTimeMsMeta,
        ),
      );
    }
    if (data.containsKey('switch_time_ms')) {
      context.handle(
        _switchTimeMsMeta,
        switchTimeMs.isAcceptableOrUnknown(
          data['switch_time_ms']!,
          _switchTimeMsMeta,
        ),
      );
    }
    if (data.containsKey('prefill_ms')) {
      context.handle(
        _prefillMsMeta,
        prefillMs.isAcceptableOrUnknown(data['prefill_ms']!, _prefillMsMeta),
      );
    }
    if (data.containsKey('decode_tokens_per_second')) {
      context.handle(
        _decodeTokensPerSecondMeta,
        decodeTokensPerSecond.isAcceptableOrUnknown(
          data['decode_tokens_per_second']!,
          _decodeTokensPerSecondMeta,
        ),
      );
    }
    if (data.containsKey('peak_memory_mb')) {
      context.handle(
        _peakMemoryMbMeta,
        peakMemoryMb.isAcceptableOrUnknown(
          data['peak_memory_mb']!,
          _peakMemoryMbMeta,
        ),
      );
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('thermal_state')) {
      context.handle(
        _thermalStateMeta,
        thermalState.isAcceptableOrUnknown(
          data['thermal_state']!,
          _thermalStateMeta,
        ),
      );
    }
    if (data.containsKey('error')) {
      context.handle(
        _errorMeta,
        error.isAcceptableOrUnknown(data['error']!, _errorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Benchmark map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Benchmark(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      modelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model_id'],
      )!,
      backend: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}backend'],
      )!,
      contextTokens: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}context_tokens'],
      )!,
      promptTokens: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prompt_tokens'],
      )!,
      warm: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}warm'],
      )!,
      ttftMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ttft_ms'],
      ),
      loadTimeMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}load_time_ms'],
      ),
      switchTimeMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}switch_time_ms'],
      ),
      prefillMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prefill_ms'],
      ),
      decodeTokensPerSecond: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}decode_tokens_per_second'],
      ),
      peakMemoryMb: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}peak_memory_mb'],
      ),
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      thermalState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thermal_state'],
      ),
      error: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error'],
      ),
    );
  }

  @override
  $BenchmarksTable createAlias(String alias) {
    return $BenchmarksTable(attachedDatabase, alias);
  }
}

class Benchmark extends DataClass implements Insertable<Benchmark> {
  final String id;
  final String deviceId;
  final String modelId;
  final String backend;
  final int contextTokens;
  final int promptTokens;
  final bool warm;
  final int? ttftMs;
  final int? loadTimeMs;
  final int? switchTimeMs;
  final int? prefillMs;
  final double? decodeTokensPerSecond;
  final int? peakMemoryMb;
  final DateTime timestamp;
  final String? thermalState;
  final String? error;
  const Benchmark({
    required this.id,
    required this.deviceId,
    required this.modelId,
    required this.backend,
    required this.contextTokens,
    required this.promptTokens,
    required this.warm,
    this.ttftMs,
    this.loadTimeMs,
    this.switchTimeMs,
    this.prefillMs,
    this.decodeTokensPerSecond,
    this.peakMemoryMb,
    required this.timestamp,
    this.thermalState,
    this.error,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['device_id'] = Variable<String>(deviceId);
    map['model_id'] = Variable<String>(modelId);
    map['backend'] = Variable<String>(backend);
    map['context_tokens'] = Variable<int>(contextTokens);
    map['prompt_tokens'] = Variable<int>(promptTokens);
    map['warm'] = Variable<bool>(warm);
    if (!nullToAbsent || ttftMs != null) {
      map['ttft_ms'] = Variable<int>(ttftMs);
    }
    if (!nullToAbsent || loadTimeMs != null) {
      map['load_time_ms'] = Variable<int>(loadTimeMs);
    }
    if (!nullToAbsent || switchTimeMs != null) {
      map['switch_time_ms'] = Variable<int>(switchTimeMs);
    }
    if (!nullToAbsent || prefillMs != null) {
      map['prefill_ms'] = Variable<int>(prefillMs);
    }
    if (!nullToAbsent || decodeTokensPerSecond != null) {
      map['decode_tokens_per_second'] = Variable<double>(decodeTokensPerSecond);
    }
    if (!nullToAbsent || peakMemoryMb != null) {
      map['peak_memory_mb'] = Variable<int>(peakMemoryMb);
    }
    map['timestamp'] = Variable<DateTime>(timestamp);
    if (!nullToAbsent || thermalState != null) {
      map['thermal_state'] = Variable<String>(thermalState);
    }
    if (!nullToAbsent || error != null) {
      map['error'] = Variable<String>(error);
    }
    return map;
  }

  BenchmarksCompanion toCompanion(bool nullToAbsent) {
    return BenchmarksCompanion(
      id: Value(id),
      deviceId: Value(deviceId),
      modelId: Value(modelId),
      backend: Value(backend),
      contextTokens: Value(contextTokens),
      promptTokens: Value(promptTokens),
      warm: Value(warm),
      ttftMs: ttftMs == null && nullToAbsent
          ? const Value.absent()
          : Value(ttftMs),
      loadTimeMs: loadTimeMs == null && nullToAbsent
          ? const Value.absent()
          : Value(loadTimeMs),
      switchTimeMs: switchTimeMs == null && nullToAbsent
          ? const Value.absent()
          : Value(switchTimeMs),
      prefillMs: prefillMs == null && nullToAbsent
          ? const Value.absent()
          : Value(prefillMs),
      decodeTokensPerSecond: decodeTokensPerSecond == null && nullToAbsent
          ? const Value.absent()
          : Value(decodeTokensPerSecond),
      peakMemoryMb: peakMemoryMb == null && nullToAbsent
          ? const Value.absent()
          : Value(peakMemoryMb),
      timestamp: Value(timestamp),
      thermalState: thermalState == null && nullToAbsent
          ? const Value.absent()
          : Value(thermalState),
      error: error == null && nullToAbsent
          ? const Value.absent()
          : Value(error),
    );
  }

  factory Benchmark.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Benchmark(
      id: serializer.fromJson<String>(json['id']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      modelId: serializer.fromJson<String>(json['modelId']),
      backend: serializer.fromJson<String>(json['backend']),
      contextTokens: serializer.fromJson<int>(json['contextTokens']),
      promptTokens: serializer.fromJson<int>(json['promptTokens']),
      warm: serializer.fromJson<bool>(json['warm']),
      ttftMs: serializer.fromJson<int?>(json['ttftMs']),
      loadTimeMs: serializer.fromJson<int?>(json['loadTimeMs']),
      switchTimeMs: serializer.fromJson<int?>(json['switchTimeMs']),
      prefillMs: serializer.fromJson<int?>(json['prefillMs']),
      decodeTokensPerSecond: serializer.fromJson<double?>(
        json['decodeTokensPerSecond'],
      ),
      peakMemoryMb: serializer.fromJson<int?>(json['peakMemoryMb']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      thermalState: serializer.fromJson<String?>(json['thermalState']),
      error: serializer.fromJson<String?>(json['error']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'deviceId': serializer.toJson<String>(deviceId),
      'modelId': serializer.toJson<String>(modelId),
      'backend': serializer.toJson<String>(backend),
      'contextTokens': serializer.toJson<int>(contextTokens),
      'promptTokens': serializer.toJson<int>(promptTokens),
      'warm': serializer.toJson<bool>(warm),
      'ttftMs': serializer.toJson<int?>(ttftMs),
      'loadTimeMs': serializer.toJson<int?>(loadTimeMs),
      'switchTimeMs': serializer.toJson<int?>(switchTimeMs),
      'prefillMs': serializer.toJson<int?>(prefillMs),
      'decodeTokensPerSecond': serializer.toJson<double?>(
        decodeTokensPerSecond,
      ),
      'peakMemoryMb': serializer.toJson<int?>(peakMemoryMb),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'thermalState': serializer.toJson<String?>(thermalState),
      'error': serializer.toJson<String?>(error),
    };
  }

  Benchmark copyWith({
    String? id,
    String? deviceId,
    String? modelId,
    String? backend,
    int? contextTokens,
    int? promptTokens,
    bool? warm,
    Value<int?> ttftMs = const Value.absent(),
    Value<int?> loadTimeMs = const Value.absent(),
    Value<int?> switchTimeMs = const Value.absent(),
    Value<int?> prefillMs = const Value.absent(),
    Value<double?> decodeTokensPerSecond = const Value.absent(),
    Value<int?> peakMemoryMb = const Value.absent(),
    DateTime? timestamp,
    Value<String?> thermalState = const Value.absent(),
    Value<String?> error = const Value.absent(),
  }) => Benchmark(
    id: id ?? this.id,
    deviceId: deviceId ?? this.deviceId,
    modelId: modelId ?? this.modelId,
    backend: backend ?? this.backend,
    contextTokens: contextTokens ?? this.contextTokens,
    promptTokens: promptTokens ?? this.promptTokens,
    warm: warm ?? this.warm,
    ttftMs: ttftMs.present ? ttftMs.value : this.ttftMs,
    loadTimeMs: loadTimeMs.present ? loadTimeMs.value : this.loadTimeMs,
    switchTimeMs: switchTimeMs.present ? switchTimeMs.value : this.switchTimeMs,
    prefillMs: prefillMs.present ? prefillMs.value : this.prefillMs,
    decodeTokensPerSecond: decodeTokensPerSecond.present
        ? decodeTokensPerSecond.value
        : this.decodeTokensPerSecond,
    peakMemoryMb: peakMemoryMb.present ? peakMemoryMb.value : this.peakMemoryMb,
    timestamp: timestamp ?? this.timestamp,
    thermalState: thermalState.present ? thermalState.value : this.thermalState,
    error: error.present ? error.value : this.error,
  );
  Benchmark copyWithCompanion(BenchmarksCompanion data) {
    return Benchmark(
      id: data.id.present ? data.id.value : this.id,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      modelId: data.modelId.present ? data.modelId.value : this.modelId,
      backend: data.backend.present ? data.backend.value : this.backend,
      contextTokens: data.contextTokens.present
          ? data.contextTokens.value
          : this.contextTokens,
      promptTokens: data.promptTokens.present
          ? data.promptTokens.value
          : this.promptTokens,
      warm: data.warm.present ? data.warm.value : this.warm,
      ttftMs: data.ttftMs.present ? data.ttftMs.value : this.ttftMs,
      loadTimeMs: data.loadTimeMs.present
          ? data.loadTimeMs.value
          : this.loadTimeMs,
      switchTimeMs: data.switchTimeMs.present
          ? data.switchTimeMs.value
          : this.switchTimeMs,
      prefillMs: data.prefillMs.present ? data.prefillMs.value : this.prefillMs,
      decodeTokensPerSecond: data.decodeTokensPerSecond.present
          ? data.decodeTokensPerSecond.value
          : this.decodeTokensPerSecond,
      peakMemoryMb: data.peakMemoryMb.present
          ? data.peakMemoryMb.value
          : this.peakMemoryMb,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      thermalState: data.thermalState.present
          ? data.thermalState.value
          : this.thermalState,
      error: data.error.present ? data.error.value : this.error,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Benchmark(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('modelId: $modelId, ')
          ..write('backend: $backend, ')
          ..write('contextTokens: $contextTokens, ')
          ..write('promptTokens: $promptTokens, ')
          ..write('warm: $warm, ')
          ..write('ttftMs: $ttftMs, ')
          ..write('loadTimeMs: $loadTimeMs, ')
          ..write('switchTimeMs: $switchTimeMs, ')
          ..write('prefillMs: $prefillMs, ')
          ..write('decodeTokensPerSecond: $decodeTokensPerSecond, ')
          ..write('peakMemoryMb: $peakMemoryMb, ')
          ..write('timestamp: $timestamp, ')
          ..write('thermalState: $thermalState, ')
          ..write('error: $error')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    deviceId,
    modelId,
    backend,
    contextTokens,
    promptTokens,
    warm,
    ttftMs,
    loadTimeMs,
    switchTimeMs,
    prefillMs,
    decodeTokensPerSecond,
    peakMemoryMb,
    timestamp,
    thermalState,
    error,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Benchmark &&
          other.id == this.id &&
          other.deviceId == this.deviceId &&
          other.modelId == this.modelId &&
          other.backend == this.backend &&
          other.contextTokens == this.contextTokens &&
          other.promptTokens == this.promptTokens &&
          other.warm == this.warm &&
          other.ttftMs == this.ttftMs &&
          other.loadTimeMs == this.loadTimeMs &&
          other.switchTimeMs == this.switchTimeMs &&
          other.prefillMs == this.prefillMs &&
          other.decodeTokensPerSecond == this.decodeTokensPerSecond &&
          other.peakMemoryMb == this.peakMemoryMb &&
          other.timestamp == this.timestamp &&
          other.thermalState == this.thermalState &&
          other.error == this.error);
}

class BenchmarksCompanion extends UpdateCompanion<Benchmark> {
  final Value<String> id;
  final Value<String> deviceId;
  final Value<String> modelId;
  final Value<String> backend;
  final Value<int> contextTokens;
  final Value<int> promptTokens;
  final Value<bool> warm;
  final Value<int?> ttftMs;
  final Value<int?> loadTimeMs;
  final Value<int?> switchTimeMs;
  final Value<int?> prefillMs;
  final Value<double?> decodeTokensPerSecond;
  final Value<int?> peakMemoryMb;
  final Value<DateTime> timestamp;
  final Value<String?> thermalState;
  final Value<String?> error;
  final Value<int> rowid;
  const BenchmarksCompanion({
    this.id = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.modelId = const Value.absent(),
    this.backend = const Value.absent(),
    this.contextTokens = const Value.absent(),
    this.promptTokens = const Value.absent(),
    this.warm = const Value.absent(),
    this.ttftMs = const Value.absent(),
    this.loadTimeMs = const Value.absent(),
    this.switchTimeMs = const Value.absent(),
    this.prefillMs = const Value.absent(),
    this.decodeTokensPerSecond = const Value.absent(),
    this.peakMemoryMb = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.thermalState = const Value.absent(),
    this.error = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BenchmarksCompanion.insert({
    required String id,
    required String deviceId,
    required String modelId,
    required String backend,
    required int contextTokens,
    required int promptTokens,
    required bool warm,
    this.ttftMs = const Value.absent(),
    this.loadTimeMs = const Value.absent(),
    this.switchTimeMs = const Value.absent(),
    this.prefillMs = const Value.absent(),
    this.decodeTokensPerSecond = const Value.absent(),
    this.peakMemoryMb = const Value.absent(),
    required DateTime timestamp,
    this.thermalState = const Value.absent(),
    this.error = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       deviceId = Value(deviceId),
       modelId = Value(modelId),
       backend = Value(backend),
       contextTokens = Value(contextTokens),
       promptTokens = Value(promptTokens),
       warm = Value(warm),
       timestamp = Value(timestamp);
  static Insertable<Benchmark> custom({
    Expression<String>? id,
    Expression<String>? deviceId,
    Expression<String>? modelId,
    Expression<String>? backend,
    Expression<int>? contextTokens,
    Expression<int>? promptTokens,
    Expression<bool>? warm,
    Expression<int>? ttftMs,
    Expression<int>? loadTimeMs,
    Expression<int>? switchTimeMs,
    Expression<int>? prefillMs,
    Expression<double>? decodeTokensPerSecond,
    Expression<int>? peakMemoryMb,
    Expression<DateTime>? timestamp,
    Expression<String>? thermalState,
    Expression<String>? error,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deviceId != null) 'device_id': deviceId,
      if (modelId != null) 'model_id': modelId,
      if (backend != null) 'backend': backend,
      if (contextTokens != null) 'context_tokens': contextTokens,
      if (promptTokens != null) 'prompt_tokens': promptTokens,
      if (warm != null) 'warm': warm,
      if (ttftMs != null) 'ttft_ms': ttftMs,
      if (loadTimeMs != null) 'load_time_ms': loadTimeMs,
      if (switchTimeMs != null) 'switch_time_ms': switchTimeMs,
      if (prefillMs != null) 'prefill_ms': prefillMs,
      if (decodeTokensPerSecond != null)
        'decode_tokens_per_second': decodeTokensPerSecond,
      if (peakMemoryMb != null) 'peak_memory_mb': peakMemoryMb,
      if (timestamp != null) 'timestamp': timestamp,
      if (thermalState != null) 'thermal_state': thermalState,
      if (error != null) 'error': error,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BenchmarksCompanion copyWith({
    Value<String>? id,
    Value<String>? deviceId,
    Value<String>? modelId,
    Value<String>? backend,
    Value<int>? contextTokens,
    Value<int>? promptTokens,
    Value<bool>? warm,
    Value<int?>? ttftMs,
    Value<int?>? loadTimeMs,
    Value<int?>? switchTimeMs,
    Value<int?>? prefillMs,
    Value<double?>? decodeTokensPerSecond,
    Value<int?>? peakMemoryMb,
    Value<DateTime>? timestamp,
    Value<String?>? thermalState,
    Value<String?>? error,
    Value<int>? rowid,
  }) {
    return BenchmarksCompanion(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      modelId: modelId ?? this.modelId,
      backend: backend ?? this.backend,
      contextTokens: contextTokens ?? this.contextTokens,
      promptTokens: promptTokens ?? this.promptTokens,
      warm: warm ?? this.warm,
      ttftMs: ttftMs ?? this.ttftMs,
      loadTimeMs: loadTimeMs ?? this.loadTimeMs,
      switchTimeMs: switchTimeMs ?? this.switchTimeMs,
      prefillMs: prefillMs ?? this.prefillMs,
      decodeTokensPerSecond:
          decodeTokensPerSecond ?? this.decodeTokensPerSecond,
      peakMemoryMb: peakMemoryMb ?? this.peakMemoryMb,
      timestamp: timestamp ?? this.timestamp,
      thermalState: thermalState ?? this.thermalState,
      error: error ?? this.error,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (modelId.present) {
      map['model_id'] = Variable<String>(modelId.value);
    }
    if (backend.present) {
      map['backend'] = Variable<String>(backend.value);
    }
    if (contextTokens.present) {
      map['context_tokens'] = Variable<int>(contextTokens.value);
    }
    if (promptTokens.present) {
      map['prompt_tokens'] = Variable<int>(promptTokens.value);
    }
    if (warm.present) {
      map['warm'] = Variable<bool>(warm.value);
    }
    if (ttftMs.present) {
      map['ttft_ms'] = Variable<int>(ttftMs.value);
    }
    if (loadTimeMs.present) {
      map['load_time_ms'] = Variable<int>(loadTimeMs.value);
    }
    if (switchTimeMs.present) {
      map['switch_time_ms'] = Variable<int>(switchTimeMs.value);
    }
    if (prefillMs.present) {
      map['prefill_ms'] = Variable<int>(prefillMs.value);
    }
    if (decodeTokensPerSecond.present) {
      map['decode_tokens_per_second'] = Variable<double>(
        decodeTokensPerSecond.value,
      );
    }
    if (peakMemoryMb.present) {
      map['peak_memory_mb'] = Variable<int>(peakMemoryMb.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (thermalState.present) {
      map['thermal_state'] = Variable<String>(thermalState.value);
    }
    if (error.present) {
      map['error'] = Variable<String>(error.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BenchmarksCompanion(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('modelId: $modelId, ')
          ..write('backend: $backend, ')
          ..write('contextTokens: $contextTokens, ')
          ..write('promptTokens: $promptTokens, ')
          ..write('warm: $warm, ')
          ..write('ttftMs: $ttftMs, ')
          ..write('loadTimeMs: $loadTimeMs, ')
          ..write('switchTimeMs: $switchTimeMs, ')
          ..write('prefillMs: $prefillMs, ')
          ..write('decodeTokensPerSecond: $decodeTokensPerSecond, ')
          ..write('peakMemoryMb: $peakMemoryMb, ')
          ..write('timestamp: $timestamp, ')
          ..write('thermalState: $thermalState, ')
          ..write('error: $error, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ConversationsTable conversations = $ConversationsTable(this);
  late final $MessagesTable messages = $MessagesTable(this);
  late final $InstalledModelsTable installedModels = $InstalledModelsTable(
    this,
  );
  late final $BenchmarksTable benchmarks = $BenchmarksTable(this);
  late final Index messagesConversationCreatedIdx = Index(
    'messages_conversation_created_idx',
    'CREATE INDEX messages_conversation_created_idx ON messages (conversation_id, created_at)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    conversations,
    messages,
    installedModels,
    benchmarks,
    messagesConversationCreatedIdx,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'conversations',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('messages', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ConversationsTableCreateCompanionBuilder =
    ConversationsCompanion Function({
      required String id,
      required String title,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<String?> lastModelId,
      Value<int> rowid,
    });
typedef $$ConversationsTableUpdateCompanionBuilder =
    ConversationsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String?> lastModelId,
      Value<int> rowid,
    });

final class $$ConversationsTableReferences
    extends
        BaseReferences<_$AppDatabase, $ConversationsTable, ChatConversation> {
  $$ConversationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$MessagesTable, List<ChatMessage>>
  _messagesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.messages,
    aliasName: 'conversations__id__messages__conversation_id',
  );

  $$MessagesTableProcessedTableManager get messagesRefs {
    final manager = $$MessagesTableTableManager(
      $_db,
      $_db.messages,
    ).filter((f) => f.conversationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_messagesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ConversationsTableFilterComposer
    extends Composer<_$AppDatabase, $ConversationsTable> {
  $$ConversationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastModelId => $composableBuilder(
    column: $table.lastModelId,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> messagesRefs(
    Expression<bool> Function($$MessagesTableFilterComposer f) f,
  ) {
    final $$MessagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.messages,
      getReferencedColumn: (t) => t.conversationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableFilterComposer(
            $db: $db,
            $table: $db.messages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ConversationsTableOrderingComposer
    extends Composer<_$AppDatabase, $ConversationsTable> {
  $$ConversationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastModelId => $composableBuilder(
    column: $table.lastModelId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ConversationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConversationsTable> {
  $$ConversationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get lastModelId => $composableBuilder(
    column: $table.lastModelId,
    builder: (column) => column,
  );

  Expression<T> messagesRefs<T extends Object>(
    Expression<T> Function($$MessagesTableAnnotationComposer a) f,
  ) {
    final $$MessagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.messages,
      getReferencedColumn: (t) => t.conversationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableAnnotationComposer(
            $db: $db,
            $table: $db.messages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ConversationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConversationsTable,
          ChatConversation,
          $$ConversationsTableFilterComposer,
          $$ConversationsTableOrderingComposer,
          $$ConversationsTableAnnotationComposer,
          $$ConversationsTableCreateCompanionBuilder,
          $$ConversationsTableUpdateCompanionBuilder,
          (ChatConversation, $$ConversationsTableReferences),
          ChatConversation,
          PrefetchHooks Function({bool messagesRefs})
        > {
  $$ConversationsTableTableManager(_$AppDatabase db, $ConversationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConversationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConversationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConversationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> lastModelId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConversationsCompanion(
                id: id,
                title: title,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastModelId: lastModelId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<String?> lastModelId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConversationsCompanion.insert(
                id: id,
                title: title,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastModelId: lastModelId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ConversationsTable, ChatConversation>(table),
                  $$ConversationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({messagesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (messagesRefs) db.messages],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (messagesRefs)
                    await $_getPrefetchedData<
                      ChatConversation,
                      $ConversationsTable,
                      ChatMessage
                    >(
                      currentTable: table,
                      referencedTable: $$ConversationsTableReferences
                          ._messagesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ConversationsTableReferences(
                            db,
                            table,
                            p0,
                          ).messagesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.conversationId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ConversationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConversationsTable,
      ChatConversation,
      $$ConversationsTableFilterComposer,
      $$ConversationsTableOrderingComposer,
      $$ConversationsTableAnnotationComposer,
      $$ConversationsTableCreateCompanionBuilder,
      $$ConversationsTableUpdateCompanionBuilder,
      (ChatConversation, $$ConversationsTableReferences),
      ChatConversation,
      PrefetchHooks Function({bool messagesRefs})
    >;
typedef $$MessagesTableCreateCompanionBuilder =
    MessagesCompanion Function({
      required String id,
      required String conversationId,
      required String role,
      required String content,
      Value<String?> modelId,
      Value<String> status,
      required DateTime createdAt,
      Value<int?> tokenCount,
      Value<int> rowid,
    });
typedef $$MessagesTableUpdateCompanionBuilder =
    MessagesCompanion Function({
      Value<String> id,
      Value<String> conversationId,
      Value<String> role,
      Value<String> content,
      Value<String?> modelId,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<int?> tokenCount,
      Value<int> rowid,
    });

final class $$MessagesTableReferences
    extends BaseReferences<_$AppDatabase, $MessagesTable, ChatMessage> {
  $$MessagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ConversationsTable _conversationIdTable(_$AppDatabase db) => db
      .conversations
      .createAlias('messages__conversation_id__conversations__id');

  $$ConversationsTableProcessedTableManager get conversationId {
    final $_column = $_itemColumn<String>('conversation_id')!;

    final manager = $$ConversationsTableTableManager(
      $_db,
      $_db.conversations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_conversationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MessagesTableFilterComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modelId => $composableBuilder(
    column: $table.modelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tokenCount => $composableBuilder(
    column: $table.tokenCount,
    builder: (column) => ColumnFilters(column),
  );

  $$ConversationsTableFilterComposer get conversationId {
    final $$ConversationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.conversationId,
      referencedTable: $db.conversations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ConversationsTableFilterComposer(
            $db: $db,
            $table: $db.conversations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modelId => $composableBuilder(
    column: $table.modelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tokenCount => $composableBuilder(
    column: $table.tokenCount,
    builder: (column) => ColumnOrderings(column),
  );

  $$ConversationsTableOrderingComposer get conversationId {
    final $$ConversationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.conversationId,
      referencedTable: $db.conversations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ConversationsTableOrderingComposer(
            $db: $db,
            $table: $db.conversations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get modelId =>
      $composableBuilder(column: $table.modelId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get tokenCount => $composableBuilder(
    column: $table.tokenCount,
    builder: (column) => column,
  );

  $$ConversationsTableAnnotationComposer get conversationId {
    final $$ConversationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.conversationId,
      referencedTable: $db.conversations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ConversationsTableAnnotationComposer(
            $db: $db,
            $table: $db.conversations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MessagesTable,
          ChatMessage,
          $$MessagesTableFilterComposer,
          $$MessagesTableOrderingComposer,
          $$MessagesTableAnnotationComposer,
          $$MessagesTableCreateCompanionBuilder,
          $$MessagesTableUpdateCompanionBuilder,
          (ChatMessage, $$MessagesTableReferences),
          ChatMessage,
          PrefetchHooks Function({bool conversationId})
        > {
  $$MessagesTableTableManager(_$AppDatabase db, $MessagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> conversationId = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String?> modelId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int?> tokenCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MessagesCompanion(
                id: id,
                conversationId: conversationId,
                role: role,
                content: content,
                modelId: modelId,
                status: status,
                createdAt: createdAt,
                tokenCount: tokenCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String conversationId,
                required String role,
                required String content,
                Value<String?> modelId = const Value.absent(),
                Value<String> status = const Value.absent(),
                required DateTime createdAt,
                Value<int?> tokenCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MessagesCompanion.insert(
                id: id,
                conversationId: conversationId,
                role: role,
                content: content,
                modelId: modelId,
                status: status,
                createdAt: createdAt,
                tokenCount: tokenCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MessagesTable, ChatMessage>(table),
                  $$MessagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({conversationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (conversationId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.conversationId,
                                referencedTable: $$MessagesTableReferences
                                    ._conversationIdTable(db),
                                referencedColumn: $$MessagesTableReferences
                                    ._conversationIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MessagesTable,
      ChatMessage,
      $$MessagesTableFilterComposer,
      $$MessagesTableOrderingComposer,
      $$MessagesTableAnnotationComposer,
      $$MessagesTableCreateCompanionBuilder,
      $$MessagesTableUpdateCompanionBuilder,
      (ChatMessage, $$MessagesTableReferences),
      ChatMessage,
      PrefetchHooks Function({bool conversationId})
    >;
typedef $$InstalledModelsTableCreateCompanionBuilder =
    InstalledModelsCompanion Function({
      required String modelId,
      required String filePath,
      Value<String> status,
      Value<DateTime?> installedAt,
      required String sha256,
      required int sizeBytes,
      Value<int> rowid,
    });
typedef $$InstalledModelsTableUpdateCompanionBuilder =
    InstalledModelsCompanion Function({
      Value<String> modelId,
      Value<String> filePath,
      Value<String> status,
      Value<DateTime?> installedAt,
      Value<String> sha256,
      Value<int> sizeBytes,
      Value<int> rowid,
    });

class $$InstalledModelsTableFilterComposer
    extends Composer<_$AppDatabase, $InstalledModelsTable> {
  $$InstalledModelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get modelId => $composableBuilder(
    column: $table.modelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get installedAt => $composableBuilder(
    column: $table.installedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sha256 => $composableBuilder(
    column: $table.sha256,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InstalledModelsTableOrderingComposer
    extends Composer<_$AppDatabase, $InstalledModelsTable> {
  $$InstalledModelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get modelId => $composableBuilder(
    column: $table.modelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get installedAt => $composableBuilder(
    column: $table.installedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sha256 => $composableBuilder(
    column: $table.sha256,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InstalledModelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InstalledModelsTable> {
  $$InstalledModelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get modelId =>
      $composableBuilder(column: $table.modelId, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get installedAt => $composableBuilder(
    column: $table.installedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sha256 =>
      $composableBuilder(column: $table.sha256, builder: (column) => column);

  GeneratedColumn<int> get sizeBytes =>
      $composableBuilder(column: $table.sizeBytes, builder: (column) => column);
}

class $$InstalledModelsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InstalledModelsTable,
          InstalledModel,
          $$InstalledModelsTableFilterComposer,
          $$InstalledModelsTableOrderingComposer,
          $$InstalledModelsTableAnnotationComposer,
          $$InstalledModelsTableCreateCompanionBuilder,
          $$InstalledModelsTableUpdateCompanionBuilder,
          (
            InstalledModel,
            BaseReferences<
              _$AppDatabase,
              $InstalledModelsTable,
              InstalledModel
            >,
          ),
          InstalledModel,
          PrefetchHooks Function()
        > {
  $$InstalledModelsTableTableManager(
    _$AppDatabase db,
    $InstalledModelsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InstalledModelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InstalledModelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InstalledModelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> modelId = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> installedAt = const Value.absent(),
                Value<String> sha256 = const Value.absent(),
                Value<int> sizeBytes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InstalledModelsCompanion(
                modelId: modelId,
                filePath: filePath,
                status: status,
                installedAt: installedAt,
                sha256: sha256,
                sizeBytes: sizeBytes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String modelId,
                required String filePath,
                Value<String> status = const Value.absent(),
                Value<DateTime?> installedAt = const Value.absent(),
                required String sha256,
                required int sizeBytes,
                Value<int> rowid = const Value.absent(),
              }) => InstalledModelsCompanion.insert(
                modelId: modelId,
                filePath: filePath,
                status: status,
                installedAt: installedAt,
                sha256: sha256,
                sizeBytes: sizeBytes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$InstalledModelsTable, InstalledModel>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $InstalledModelsTable,
                    InstalledModel
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InstalledModelsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InstalledModelsTable,
      InstalledModel,
      $$InstalledModelsTableFilterComposer,
      $$InstalledModelsTableOrderingComposer,
      $$InstalledModelsTableAnnotationComposer,
      $$InstalledModelsTableCreateCompanionBuilder,
      $$InstalledModelsTableUpdateCompanionBuilder,
      (
        InstalledModel,
        BaseReferences<_$AppDatabase, $InstalledModelsTable, InstalledModel>,
      ),
      InstalledModel,
      PrefetchHooks Function()
    >;
typedef $$BenchmarksTableCreateCompanionBuilder =
    BenchmarksCompanion Function({
      required String id,
      required String deviceId,
      required String modelId,
      required String backend,
      required int contextTokens,
      required int promptTokens,
      required bool warm,
      Value<int?> ttftMs,
      Value<int?> loadTimeMs,
      Value<int?> switchTimeMs,
      Value<int?> prefillMs,
      Value<double?> decodeTokensPerSecond,
      Value<int?> peakMemoryMb,
      required DateTime timestamp,
      Value<String?> thermalState,
      Value<String?> error,
      Value<int> rowid,
    });
typedef $$BenchmarksTableUpdateCompanionBuilder =
    BenchmarksCompanion Function({
      Value<String> id,
      Value<String> deviceId,
      Value<String> modelId,
      Value<String> backend,
      Value<int> contextTokens,
      Value<int> promptTokens,
      Value<bool> warm,
      Value<int?> ttftMs,
      Value<int?> loadTimeMs,
      Value<int?> switchTimeMs,
      Value<int?> prefillMs,
      Value<double?> decodeTokensPerSecond,
      Value<int?> peakMemoryMb,
      Value<DateTime> timestamp,
      Value<String?> thermalState,
      Value<String?> error,
      Value<int> rowid,
    });

class $$BenchmarksTableFilterComposer
    extends Composer<_$AppDatabase, $BenchmarksTable> {
  $$BenchmarksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modelId => $composableBuilder(
    column: $table.modelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get backend => $composableBuilder(
    column: $table.backend,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get contextTokens => $composableBuilder(
    column: $table.contextTokens,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get promptTokens => $composableBuilder(
    column: $table.promptTokens,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get warm => $composableBuilder(
    column: $table.warm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ttftMs => $composableBuilder(
    column: $table.ttftMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get loadTimeMs => $composableBuilder(
    column: $table.loadTimeMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get switchTimeMs => $composableBuilder(
    column: $table.switchTimeMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get prefillMs => $composableBuilder(
    column: $table.prefillMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get decodeTokensPerSecond => $composableBuilder(
    column: $table.decodeTokensPerSecond,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get peakMemoryMb => $composableBuilder(
    column: $table.peakMemoryMb,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thermalState => $composableBuilder(
    column: $table.thermalState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BenchmarksTableOrderingComposer
    extends Composer<_$AppDatabase, $BenchmarksTable> {
  $$BenchmarksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modelId => $composableBuilder(
    column: $table.modelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get backend => $composableBuilder(
    column: $table.backend,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get contextTokens => $composableBuilder(
    column: $table.contextTokens,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get promptTokens => $composableBuilder(
    column: $table.promptTokens,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get warm => $composableBuilder(
    column: $table.warm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ttftMs => $composableBuilder(
    column: $table.ttftMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get loadTimeMs => $composableBuilder(
    column: $table.loadTimeMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get switchTimeMs => $composableBuilder(
    column: $table.switchTimeMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get prefillMs => $composableBuilder(
    column: $table.prefillMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get decodeTokensPerSecond => $composableBuilder(
    column: $table.decodeTokensPerSecond,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get peakMemoryMb => $composableBuilder(
    column: $table.peakMemoryMb,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thermalState => $composableBuilder(
    column: $table.thermalState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BenchmarksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BenchmarksTable> {
  $$BenchmarksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get modelId =>
      $composableBuilder(column: $table.modelId, builder: (column) => column);

  GeneratedColumn<String> get backend =>
      $composableBuilder(column: $table.backend, builder: (column) => column);

  GeneratedColumn<int> get contextTokens => $composableBuilder(
    column: $table.contextTokens,
    builder: (column) => column,
  );

  GeneratedColumn<int> get promptTokens => $composableBuilder(
    column: $table.promptTokens,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get warm =>
      $composableBuilder(column: $table.warm, builder: (column) => column);

  GeneratedColumn<int> get ttftMs =>
      $composableBuilder(column: $table.ttftMs, builder: (column) => column);

  GeneratedColumn<int> get loadTimeMs => $composableBuilder(
    column: $table.loadTimeMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get switchTimeMs => $composableBuilder(
    column: $table.switchTimeMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get prefillMs =>
      $composableBuilder(column: $table.prefillMs, builder: (column) => column);

  GeneratedColumn<double> get decodeTokensPerSecond => $composableBuilder(
    column: $table.decodeTokensPerSecond,
    builder: (column) => column,
  );

  GeneratedColumn<int> get peakMemoryMb => $composableBuilder(
    column: $table.peakMemoryMb,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get thermalState => $composableBuilder(
    column: $table.thermalState,
    builder: (column) => column,
  );

  GeneratedColumn<String> get error =>
      $composableBuilder(column: $table.error, builder: (column) => column);
}

class $$BenchmarksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BenchmarksTable,
          Benchmark,
          $$BenchmarksTableFilterComposer,
          $$BenchmarksTableOrderingComposer,
          $$BenchmarksTableAnnotationComposer,
          $$BenchmarksTableCreateCompanionBuilder,
          $$BenchmarksTableUpdateCompanionBuilder,
          (
            Benchmark,
            BaseReferences<_$AppDatabase, $BenchmarksTable, Benchmark>,
          ),
          Benchmark,
          PrefetchHooks Function()
        > {
  $$BenchmarksTableTableManager(_$AppDatabase db, $BenchmarksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BenchmarksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BenchmarksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BenchmarksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> modelId = const Value.absent(),
                Value<String> backend = const Value.absent(),
                Value<int> contextTokens = const Value.absent(),
                Value<int> promptTokens = const Value.absent(),
                Value<bool> warm = const Value.absent(),
                Value<int?> ttftMs = const Value.absent(),
                Value<int?> loadTimeMs = const Value.absent(),
                Value<int?> switchTimeMs = const Value.absent(),
                Value<int?> prefillMs = const Value.absent(),
                Value<double?> decodeTokensPerSecond = const Value.absent(),
                Value<int?> peakMemoryMb = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<String?> thermalState = const Value.absent(),
                Value<String?> error = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BenchmarksCompanion(
                id: id,
                deviceId: deviceId,
                modelId: modelId,
                backend: backend,
                contextTokens: contextTokens,
                promptTokens: promptTokens,
                warm: warm,
                ttftMs: ttftMs,
                loadTimeMs: loadTimeMs,
                switchTimeMs: switchTimeMs,
                prefillMs: prefillMs,
                decodeTokensPerSecond: decodeTokensPerSecond,
                peakMemoryMb: peakMemoryMb,
                timestamp: timestamp,
                thermalState: thermalState,
                error: error,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String deviceId,
                required String modelId,
                required String backend,
                required int contextTokens,
                required int promptTokens,
                required bool warm,
                Value<int?> ttftMs = const Value.absent(),
                Value<int?> loadTimeMs = const Value.absent(),
                Value<int?> switchTimeMs = const Value.absent(),
                Value<int?> prefillMs = const Value.absent(),
                Value<double?> decodeTokensPerSecond = const Value.absent(),
                Value<int?> peakMemoryMb = const Value.absent(),
                required DateTime timestamp,
                Value<String?> thermalState = const Value.absent(),
                Value<String?> error = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BenchmarksCompanion.insert(
                id: id,
                deviceId: deviceId,
                modelId: modelId,
                backend: backend,
                contextTokens: contextTokens,
                promptTokens: promptTokens,
                warm: warm,
                ttftMs: ttftMs,
                loadTimeMs: loadTimeMs,
                switchTimeMs: switchTimeMs,
                prefillMs: prefillMs,
                decodeTokensPerSecond: decodeTokensPerSecond,
                peakMemoryMb: peakMemoryMb,
                timestamp: timestamp,
                thermalState: thermalState,
                error: error,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BenchmarksTable, Benchmark>(table),
                  BaseReferences<_$AppDatabase, $BenchmarksTable, Benchmark>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BenchmarksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BenchmarksTable,
      Benchmark,
      $$BenchmarksTableFilterComposer,
      $$BenchmarksTableOrderingComposer,
      $$BenchmarksTableAnnotationComposer,
      $$BenchmarksTableCreateCompanionBuilder,
      $$BenchmarksTableUpdateCompanionBuilder,
      (Benchmark, BaseReferences<_$AppDatabase, $BenchmarksTable, Benchmark>),
      Benchmark,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ConversationsTableTableManager get conversations =>
      $$ConversationsTableTableManager(_db, _db.conversations);
  $$MessagesTableTableManager get messages =>
      $$MessagesTableTableManager(_db, _db.messages);
  $$InstalledModelsTableTableManager get installedModels =>
      $$InstalledModelsTableTableManager(_db, _db.installedModels);
  $$BenchmarksTableTableManager get benchmarks =>
      $$BenchmarksTableTableManager(_db, _db.benchmarks);
}
