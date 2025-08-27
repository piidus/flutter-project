// lib/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Define the state of our authentication
enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthState {
  final AuthStatus status;
  final String? token;
  final String? errorMessage;

  AuthState({
    required this.status,
    this.token,
    this.errorMessage,
  });
}

// The Notifier that handles the login logic and state changes
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return AuthState(status: AuthStatus.initial);
  }

  Future<void> login(String email, String password) async {
    state = AuthState(status: AuthStatus.loading);
    const apiUri = 'http://127.0.0.1:8000';

    try {
      final response = await http.post(
        Uri.parse('$apiUri/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final String sessionToken = data['token'];
        
        // Save token to SharedPreferences for persistence
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('session_token', sessionToken);

        state = AuthState(status: AuthStatus.authenticated, token: sessionToken);
      } else {
        final Map<String, dynamic> data = jsonDecode(response.body);
        state = AuthState(status: AuthStatus.error, errorMessage: data['detail'] ?? 'Login failed');
      }
    } catch (e) {
      state = AuthState(status: AuthStatus.error, errorMessage: 'An error occurred: $e');
    }
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('session_token');
    state = AuthState(status: AuthStatus.unauthenticated);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() => AuthNotifier());