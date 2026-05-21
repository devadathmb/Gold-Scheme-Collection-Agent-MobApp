// lib/data/tables/pending_messages.dart
import 'package:drift/drift.dart';

class PendingMessages extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get phone => text()();
  TextColumn get message => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}