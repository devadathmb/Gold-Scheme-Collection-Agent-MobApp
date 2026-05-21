// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../utils/app_theme.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _pinController = TextEditingController();
  bool _isError = false;

  Future<void> _processLogin() async {
    if (_pinController.text.length < 4) return;
    
    final success = await ref.read(authProvider.notifier).login(_pinController.text);
    if (!success && mounted) {
      setState(() => _isError = true);
    }
  }

  void _showSetupConfirmation() {
    if (_pinController.text.length < 4) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm PIN Setup'),
        content: Text(
            'Are you sure you want to set "${_pinController.text}" as your permanent access PIN?\n\n'
            'You will need this PIN every time you open the app to record collections.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              _processLogin();        // Save the PIN and log the user in
            },
            child: const Text('Yes, Set PIN'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch the provider to see if a PIN is already saved
    final hasPinAsync = ref.watch(hasPinProvider);

    return hasPinAsync.when(
      // THE FIX: Return a blank white screen instead of the spinner.
      loading: () => const Scaffold(
        backgroundColor: Colors.white, 
        body: SizedBox.shrink()
      ),
      error: (e, _) => const Scaffold(
        body: Center(child: Text('Error loading security data'))
      ),
      data: (hasPin) {
        final isFirstTime = !hasPin;

        return Scaffold(
          backgroundColor: Colors.white, // Ensure this matches your splash background
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isFirstTime ? Icons.security_outlined : Icons.lock_outline, 
                    size: 64, 
                    color: AppTheme.primary
                  ),
                  const SizedBox(height: 24),
                  Text(
                    isFirstTime ? 'Set Agent PIN' : 'Agent Login', 
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isFirstTime 
                        ? 'Create a 4-digit PIN for future access.' 
                        : 'Enter your 4-digit PIN to access.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _pinController,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24, letterSpacing: 8),
                    decoration: InputDecoration(
                      errorText: _isError ? 'Incorrect PIN' : null,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onChanged: (_) => setState(() => _isError = false),
                    // Route the keyboard submit button dynamically
                    onSubmitted: (_) => isFirstTime ? _showSetupConfirmation() : _processLogin(),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                      // Route the physical button dynamically
                      onPressed: () => isFirstTime ? _showSetupConfirmation() : _processLogin(),
                      child: Text(
                        isFirstTime ? 'Save PIN & Enter' : 'Login', 
                        style: const TextStyle(fontSize: 16)
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}