// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'utils/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/splash_screen.dart'; // Import your new splash screen
import 'providers/auth_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: CollectionAgentApp(),
    ),
  );
}

class CollectionAgentApp extends ConsumerWidget {
  const CollectionAgentApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch both the splash timer and the authentication state
    final splashState = ref.watch(splashTimerProvider);
    final isAuthenticated = ref.watch(authProvider);

    return MaterialApp(
      title: 'Collection Agent',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      
      // Use the .when() method to gracefully switch screens
      home: splashState.when(
        // When the 2.2 seconds are up, show the actual app
        data: (_) => isAuthenticated ? const HomeScreen() : const LoginScreen(),
        
        // While the timer is ticking, show the cool animation
        loading: () => const AnimatedSplashScreen(),
        
        // Fallback just in case
        error: (_, __) => isAuthenticated ? const HomeScreen() : const LoginScreen(),
      ),
    );
  }
}