// lib/data/tables/receipts.dart
import 'package:drift/drift.dart';

class Receipts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get passBookId => text()();
  TextColumn get name => text()();
  DateTimeColumn get entryDate => dateTime().withDefault(currentDateAndTime)();
  RealColumn get goldRate => real()();
  RealColumn get amountReceived => real()();
  RealColumn get eqWtAdded => real()();
  TextColumn get paymentMethod => text()();
  TextColumn get remarks => text().withDefault(const Constant(''))();
  BoolColumn get isCancelled => boolean().withDefault(const Constant(false))(); 
}