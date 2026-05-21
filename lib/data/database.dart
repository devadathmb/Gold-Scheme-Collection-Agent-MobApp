// lib/data/database.dart
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/customers.dart';
import 'tables/receipts.dart';
import 'tables/pending_messages.dart'; // ADDED THIS
import 'daos/customer_dao.dart';
import 'daos/receipt_dao.dart';
import 'daos/pending_message_dao.dart'; // ADDED THIS

part 'database.g.dart';

@DriftDatabase(
  tables: [Customers, Receipts, PendingMessages], // UPDATED
  daos: [CustomerDao, ReceiptDao, PendingMessageDao] // UPDATED
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3; // INCREMENTED VERSION

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(receipts);
          }
          if (from < 3) {
            await m.createTable(pendingMessages); // ADDED MIGRATION
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'collection_agent.db'));
    return NativeDatabase.createInBackground(file);
  });
}