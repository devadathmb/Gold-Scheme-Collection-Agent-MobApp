// lib/providers/excel_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/excel_service.dart';
import 'database_provider.dart';

final excelServiceProvider = Provider<ExcelService>((ref) {
  return ExcelService(
    ref.watch(customerDaoProvider),
    ref.watch(receiptDaoProvider),
  );
});

class ImportState {
  final bool isLoading;
  final ImportResult? result;
  final String? error;

  const ImportState({this.isLoading = false, this.result, this.error});

  ImportState copyWith({bool? isLoading, ImportResult? result, String? error}) =>
      ImportState(
        isLoading: isLoading ?? this.isLoading,
        result: result ?? this.result,
        error: error ?? this.error,
      );
}

class ImportNotifier extends StateNotifier<ImportState> {
  final ExcelService _service;

  ImportNotifier(this._service) : super(const ImportState());

  Future<void> importExcel({bool clearExisting = false}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _service.importFromExcel(clearExisting: clearExisting);
      if (result == null) {
        state = state.copyWith(isLoading: false);
        return;
      }
      state = ImportState(isLoading: false, result: result);
    } catch (e) {
      state = ImportState(isLoading: false, error: e.toString());
    }
  }

  void reset() => state = const ImportState();
}

final importProvider = StateNotifierProvider<ImportNotifier, ImportState>((ref) {
  return ImportNotifier(ref.watch(excelServiceProvider));
});

final exportLoadingProvider = StateProvider<bool>((ref) => false);

Future<void> exportExcel(WidgetRef ref) async {
  ref.read(exportLoadingProvider.notifier).state = true;
  try {
    await ref.read(excelServiceProvider).exportToExcel();
  } finally {
    ref.read(exportLoadingProvider.notifier).state = false;
  }
}