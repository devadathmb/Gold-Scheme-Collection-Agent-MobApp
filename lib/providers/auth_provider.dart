// lib/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Add this to the top of your lib/providers/auth_provider.dart

final splashTimerProvider = FutureProvider<void>((ref) async {
  // This dictates how long the splash screen stays on screen
  await Future.delayed(const Duration(milliseconds: 2200));
});

final hasPinProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('agent_pin') != null;
});

final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) => AuthNotifier());

class AuthNotifier extends StateNotifier<bool> {
  AuthNotifier() : super(false);

  Future<bool> login(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    final savedPin = prefs.getString('agent_pin');
    
    if (savedPin == null) {
      // First time app launch: set the PIN
      await prefs.setString('agent_pin', pin);
      state = true;
      return true;
    }
    
    if (savedPin == pin) {
      state = true;
      return true;
    }
    return false;
  }

  void logout() {
    state = false;
  }
}