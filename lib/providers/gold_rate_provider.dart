// lib/providers/gold_rate_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kGoldRateKey = 'gold_rate_per_gram';

/// Persists and exposes the current gold rate (₹ per gram).
/// Survives app restarts via SharedPreferences.
class GoldRateNotifier extends StateNotifier<double> {
  GoldRateNotifier() : super(0.0) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getDouble(_kGoldRateKey) ?? 0.0;
  }

  Future<void> setRate(double rate) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_kGoldRateKey, rate);
    state = rate;
  }
}

final goldRateProvider =
    StateNotifierProvider<GoldRateNotifier, double>((ref) {
  return GoldRateNotifier();
});

/// Eq.Wt = receivedAmount / goldRate  (grams)
/// Returns 0 if gold rate is not set.
double calculateEqWt(double receivedAmount, double goldRate) {
  if (goldRate <= 0) return 0.0;
  return receivedAmount / goldRate;
}