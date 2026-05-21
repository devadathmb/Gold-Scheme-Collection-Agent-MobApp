// lib/providers/search_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database.dart';
import 'database_provider.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = StreamProvider<List<Customer>>((ref) {
  final query = ref.watch(searchQueryProvider);
  final dao = ref.watch(customerDaoProvider);
  if (query.trim().isEmpty) return dao.watchAllCustomers();
  return dao.searchCustomers(query.trim());
});

final totalReceivedProvider = FutureProvider<double>((ref) {
  ref.watch(searchResultsProvider); // re-run when DB changes
  return ref.watch(customerDaoProvider).getTotalReceived();
});

final collectedCountProvider = FutureProvider<int>((ref) {
  ref.watch(searchResultsProvider);
  return ref.watch(customerDaoProvider).getCollectedCount();
});

final totalCustomersProvider = StreamProvider<int>((ref) {
  return ref
      .watch(customerDaoProvider)
      .watchAllCustomers()
      .map((list) => list.length);
});