import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:novaed_app/core/services/auth_http_client.dart';
import 'package:novaed_app/features/sign_in/data/models/user_model.dart';

class AuthService {
  static const String baseUrl =
      'http://novaedapp-env.eba-ceaqmh3m.me-south-1.elasticbeanstalk.com';

  static const String webClientId =
      '401048982997-t8g45cnv8h9k51juspujusrvuhfptm93.apps.googleusercontent.com';

  final storage = const FlutterSecureStorage();
  static const accessTokenKey = 'access_token';
  static const refreshTokenKey = 'refresh_token';

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId: webClientId,
  );

  Future<User> signInWithGoogle() async {
    if (kIsWeb) {
      _googleSignIn = GoogleSignIn(
        clientId: webClientId,
        scopes: ['email', 'profile'],
      );
    }

    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception('Google sign-in was aborted by user');
    }

    final googleAuth = await googleUser.authentication;
    final googleIdToken = googleAuth.idToken;

    if (googleIdToken == null) {
      throw Exception('Failed to obtain Google ID token');
    }

    final response = await AuthHttpClient().post(
      Uri.parse('$baseUrl/api/v1/users/external-login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'provider': 'Google',
        'idToken': googleIdToken,
      }),
    );

    if (response.statusCode != 200) {
      final error =
          jsonDecode(response.body)['message'] ?? 'Authentication failed';
      throw Exception('$error (${response.statusCode})');
    }

    final auth = AuthResponse.fromJson(jsonDecode(response.body));
    await saveTokens(auth.tokens);

    return auth.user;
  }

  Future<void> saveTokens(Tokens tokens) async {
    await storage.write(key: accessTokenKey, value: tokens.accessToken);
    await storage.write(key: refreshTokenKey, value: tokens.refreshToken);
  }

  Future<void> getNewAccessTokenByRefreshToken() async {
    final refreshToken = await storage.read(key: refreshTokenKey);

    if (refreshToken == null) {
      throw Exception('No refresh token!');
    }

    final response = await AuthHttpClient().post(
      Uri.parse('$baseUrl/api/v1/auth/refresh-token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': refreshToken}),
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body)['message'] ??
          'Re Login! , getting new tokens failed';
      throw Exception('$error (${response.statusCode})');
    }

    final tokens = Tokens.fromJson(jsonDecode(response.body));
    await saveTokens(tokens);
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await storage.deleteAll();
  }

}
