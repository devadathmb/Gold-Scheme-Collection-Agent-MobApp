// lib/data/daos/pending_message_dao.dart
import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/pending_messages.dart';

part 'pending_message_dao.g.dart';

@DriftAccessor(tables: [PendingMessages])
class PendingMessageDao extends DatabaseAccessor<AppDatabase> with _$PendingMessageDaoMixin {
  PendingMessageDao(AppDatabase db) : super(db);

  Future<int> insertMessage(PendingMessagesCompanion msg) => into(pendingMessages).insert(msg);
  Future<List<PendingMessage>> getAllPending() => select(pendingMessages).get();
  Future<void> deleteMessage(int id) => (delete(pendingMessages)..where((t) => t.id.equals(id))).go();
}