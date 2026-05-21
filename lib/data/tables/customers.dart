// lib/data/tables/customers.dart
import 'package:drift/drift.dart';

/// Customers table — mirrors the head office Excel import columns
/// plus locally entered [receivedAmount]. Eq.Wt is calculated at
/// export time from the current gold rate.
class Customers extends Table {
  // Internal auto-increment primary key
  IntColumn get id => integer().autoIncrement()();

  // ── Imported from head office Excel ────────────────────────────────────────
  TextColumn get passBookNo => text().named('pass_book_no')();
  TextColumn get name => text()();
  TextColumn get phone => text().withDefault(const Constant(''))();

  // Sanctioned/outstanding amount from Excel
  RealColumn get amount => real().withDefault(const Constant(0.0))();

  // Eq.Wt as imported from Excel (reference value)
  RealColumn get eqWt => real().named('eq_wt').withDefault(const Constant(0.0))();

  // ── Entered by agent ───────────────────────────────────────────────────────
  // Amount received by the agent during collection
  RealColumn get receivedAmount =>
      real().named('received_amount').withDefault(const Constant(0.0))();

  // Optional agent notes
  TextColumn get notes => text().withDefault(const Constant(''))();

  // ── Timestamps ─────────────────────────────────────────────────────────────
  DateTimeColumn get importedAt =>
      dateTime().named('imported_at').withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().named('updated_at').withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {passBookNo}
      ];
}