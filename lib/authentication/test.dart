// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_watch/authentication/authprovider.dart';
// import 'package:your_app/providers/authprovider.dart'; // Make sure to use the correct path

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final usernameController = TextEditingController(text: 'sudiipkumarbasu@gmail.com');
  final passwordController = TextEditingController(text: '123456');

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final email = usernameController.text;
    final password = passwordController.text;
    ref.read(authProvider.notifier).login(email, password);
  }

  @override
  Widget build(BuildContext context) {
    // Listen to the state of the authProvider
    final authState = ref.watch(authProvider);

    // Show a loading indicator if the status is loading
    if (authState.status == AuthStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    // You can handle authentication status here, e.g., navigate to another screen
    if (authState.status == AuthStatus.authenticated) {
      // Navigate to the home screen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // You would typically use Navigator to navigate here
        print('User authenticated! Token: ${authState.token}');
      });
    }

    // Build the login form
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'User Name',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleLogin,
              child: const Text('Login'),
            ),
            if (authState.status == AuthStatus.error)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  authState.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}