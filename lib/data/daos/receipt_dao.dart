// lib/data/daos/receipt_dao.dart
import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/receipts.dart';

part 'receipt_dao.g.dart';

@DriftAccessor(tables: [Receipts])
class ReceiptDao extends DatabaseAccessor<AppDatabase> with _$ReceiptDaoMixin {
  ReceiptDao(super.db);

  Future<List<Receipt>> getAllReceipts() => select(receipts).get();

  Future<int> insertReceipt(ReceiptsCompanion entry) => into(receipts).insert(entry);
  
  Stream<List<Receipt>> watchAllReceipts() => select(receipts).watch();

  // lib/data/daos/receipt_dao.dart
// Add these two methods inside the ReceiptDao class:

  Stream<Receipt?> watchLastReceipt() => 
      (select(receipts)..orderBy([(t) => OrderingTerm.desc(t.id)])..limit(1)).watchSingleOrNull();

  Future<void> cancelReceipt(int id) => 
      (update(receipts)..where((t) => t.id.equals(id))).write(const ReceiptsCompanion(isCancelled: Value(true)));

  // Updated clearAll to reset the auto-increment ID
  Future<void> clearAll() async {
    // 1. Delete all existing rows
    await delete(receipts).go();
    
    // 2. Reset the SQLite auto-increment counter back to 0
    // So the next entry will naturally start at 1
    await customUpdate("DELETE FROM sqlite_sequence WHERE name = 'receipts'");
  }
}