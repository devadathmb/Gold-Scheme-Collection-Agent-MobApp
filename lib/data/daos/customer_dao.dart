// lib/data/daos/customer_dao.dart
import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/customers.dart';

part 'customer_dao.g.dart';

@DriftAccessor(tables: [Customers])
class CustomerDao extends DatabaseAccessor<AppDatabase>
    with _$CustomerDaoMixin {
  CustomerDao(super.db);

  // ─── Queries ──────────────────────────────────────────────────────────────

  Stream<List<Customer>> watchAllCustomers() =>
      (select(customers)..orderBy([(c) => OrderingTerm.asc(c.passBookNo)]))
          .watch();

  /// Search by passbook no, name, or phone — live reactive stream.
  Stream<List<Customer>> searchCustomers(String query) {
    final term = '%${query.trim()}%';
    return (select(customers)
          ..where(
            (c) =>
                c.passBookNo.like(term) |
                c.name.like(term) |
                c.phone.like(term),
          )
          ..orderBy([(c) => OrderingTerm.asc(c.passBookNo)]))
        .watch();
  }

  Future<Customer?> getCustomerById(int id) =>
      (select(customers)..where((c) => c.id.equals(id))).getSingleOrNull();

  /// Total received amount across all customers.
  Future<double> getTotalReceived() async {
    final query = selectOnly(customers)
      ..addColumns([customers.receivedAmount.sum()]);
    final result = await query.getSingle();
    return result.read(customers.receivedAmount.sum()) ?? 0.0;
  }

  /// Count of customers who have had any amount received.
  Future<int> getCollectedCount() async {
    final results = await (select(customers)
          ..where((c) => c.receivedAmount.isBiggerThanValue(0)))
        .get();
    return results.length;
  }

  /// All customers for export.
  Future<List<Customer>> getAllCustomers() async {
    final list = await (select(customers)
          ..orderBy([(c) => OrderingTerm.asc(c.name)]))
        .get();

    // This will print the phone numbers to your VS Code debug console
    for (var customer in list) {
      print(
          'PB: ${customer.passBookNo} | Name: ${customer.name} | Phone: "${customer.phone}"');
    }

    return list;
  }
  // ─── Mutations ────────────────────────────────────────────────────────────

  Future<void> upsertAll(List<CustomersCompanion> entries) async {
    await batch((b) {
      for (final entry in entries) {
        b.insert(
          customers,
          entry,
          onConflict: DoUpdate(
            (old) => CustomersCompanion(
              // Update these fields from the new Excel data
              name: entry.name,
              phone: entry.phone,
              amount: entry.amount,
              eqWt: entry.eqWt,
              updatedAt: Value(DateTime.now()),

              // CRITICAL: We deliberately omit receivedAmount and notes here.
              // This ensures that if the row already exists, the agent's
              // local collection data is preserved and not overwritten.
            ),
            // Tell SQLite to look for conflicts on the passBookNo column
            target: [customers.passBookNo],
          ),
        );
      }
    });
  }

  Future<void> updateCollection({
    required int id,
    required double receivedAmount,
    required String notes,
  }) =>
      (update(customers)..where((c) => c.id.equals(id))).write(
        CustomersCompanion(
          receivedAmount: Value(receivedAmount),
          notes: Value(notes),
          updatedAt: Value(DateTime.now()),
        ),
      );

  Future<void> clearAll() => delete(customers).go();
}
