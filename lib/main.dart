// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // ADDED THIS
import 'utils/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/splash_screen.dart';
import 'providers/auth_provider.dart';
import 'services/sms_service.dart'; // ADDED THIS

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: CollectionAgentApp(),
    ),
  );
}

class CollectionAgentApp extends ConsumerStatefulWidget {
  const CollectionAgentApp({super.key});

  @override
  ConsumerState<CollectionAgentApp> createState() => _CollectionAgentAppState();
}

class _CollectionAgentAppState extends ConsumerState<CollectionAgentApp> {
  
  @override
  void initState() {
    super.initState();
    // Listen for network changes to retry pending messages
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (!results.contains(ConnectivityResult.none)) {
        ref.read(smsServiceProvider).retryPendingMessages();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final splashState = ref.watch(splashTimerProvider);
    final isAuthenticated = ref.watch(authProvider);

    return MaterialApp(
      title: 'Collection Agent',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: splashState.when(
        data: (_) => isAuthenticated ? const HomeScreen() : const LoginScreen(),
        loading: () => const AnimatedSplashScreen(),
        error: (_, __) => isAuthenticated ? const HomeScreen() : const LoginScreen(),
      ),
    );
  }
}