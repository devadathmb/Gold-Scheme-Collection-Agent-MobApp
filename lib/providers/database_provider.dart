// lib/providers/database_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database.dart';
import '../data/daos/receipt_dao.dart';
import '../data/daos/pending_message_dao.dart'; // ADDED THIS IMPORT

/// Global database instance — single source of truth.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// Exposes the CustomerDao directly.
final customerDaoProvider = Provider((ref) {
  return ref.watch(databaseProvider).customerDao;
});

final receiptDaoProvider = Provider<ReceiptDao>((ref) {
  return ref.watch(databaseProvider).receiptDao;
});

/// Exposes the PendingMessageDao for the SMS queue.
final pendingMessageDaoProvider = Provider<PendingMessageDao>((ref) {
  return ref.watch(databaseProvider).pendingMessageDao;
}); // ADDED THIS PROVIDER