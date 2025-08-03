import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:novaed_app/core/services/auth_http_client.dart';
import 'package:novaed_app/features/LogIn/data/models/user_model.dart';

class AuthService {
  final String baseUrl = dotenv.env['baseUrl']!;
  final String clientId = dotenv.env['clientId']!;

  static const accessTokenKey = 'access_token';
  static const refreshTokenKey = 'refresh_token';
  final _storage = const FlutterSecureStorage();
  final _googleSignIn = GoogleSignIn.instance;

  AuthService() {
    // Just initialize; no lightweight auth or extra sheets
    _googleSignIn.initialize(
      clientId: clientId,
      serverClientId: clientId,
    );
  }
  
  Future<void> ensureLoggedIn(BuildContext context) async {
  try {
    final rt = await _storage.read(key: refreshTokenKey);
    if (rt == null) {
      throw Exception('No refresh token');
    }

    await getNewAccessTokenByRefreshToken();
  } catch (e) {
    debugPrint('Refresh token expired/invalid: $e');
    await _storage.deleteAll();  // Clear invalid tokens
    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }
}


  /// Shows the account‑picker every time.
  Future<User> signInWithGoogle() async {
    final account = await _googleSignIn.authenticate();

    final auth = account.authentication;

    
    final idToken = auth.idToken;
    if (idToken == null || idToken.isEmpty) {
      throw Exception('Failed to retrievse ID token.');
    }

    final resp = await AuthHttpClient().post(
      Uri.parse('$baseUrl/api/v1/users/external-login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'provider': 'Google',
        'idToken': idToken,
      }),
    );
    // debugPrint('Response JSON: ${resp.body}');

    if (resp.statusCode != 200) {
      final err = jsonDecode(resp.body)['message'] ?? 'Authentication failed';
      throw Exception('$err (${resp.statusCode})');
    }

    final authResp = AuthResponse.fromJson(jsonDecode(resp.body));
    await _saveTokens(authResp.tokens);
    debugPrint('accessToken: ${authResp.tokens.accessToken}');
    debugPrint('refreshToken: ${authResp.tokens.refreshToken}');

    return authResp.user;
  }

  Future<void> _saveTokens(Tokens t) async {
    await _storage.write(key: 'access_token', value: t.accessToken);
    await _storage.write(key: 'refresh_token', value: t.refreshToken);
  }

  Future<void> getNewAccessTokenByRefreshToken() async {
    final rt = await _storage.read(key: refreshTokenKey);
    if (rt == null) throw Exception('No refresh token on disk.');

    final res = await AuthHttpClient().post(
      Uri.parse('$baseUrl/api/v1/auth/refresh-token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': rt}),
    );
    if (res.statusCode != 200) {
      final err = jsonDecode(res.body)['message'] ?? 'Refresh failed';
      throw Exception('$err (${res.statusCode})');
    }
    final newTokens = Tokens.fromJson(jsonDecode(res.body));
    await _saveTokens(newTokens);
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _storage.deleteAll();
  }
}
