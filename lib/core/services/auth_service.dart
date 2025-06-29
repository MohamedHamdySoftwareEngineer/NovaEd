import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:novaed_app/core/services/auth_http_client.dart';
import 'package:novaed_app/features/sign_in/data/models/user_model.dart';

class AuthService {
  final baseUrl = dotenv.env['baseUrl']!;
  final clientId = dotenv.env['clientId']!;

  final storage = const FlutterSecureStorage();
  static const accessTokenKey = 'access_token';
  static const refreshTokenKey = 'refresh_token';

  late final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId: clientId,
  );

  Future<User> signInWithGoogle() async {
    // Show Google account chooser
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception('You Should use a Google Account To Continue!');
    }

    // Getting google Id Token after the user chooces his account
    final googleAuth = await googleUser.authentication;
    final googleIdToken = googleAuth.idToken;

    if (googleIdToken == null) {
      throw Exception(
          'Failed to obtain Google ID token, try again later or choose another account');
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

    final authResponse = AuthResponse.fromJson(jsonDecode(response.body));
    await saveTokens(authResponse.tokens);

    return authResponse.user;
  }

  Future<void> saveTokens(Tokens tokens) async {
    await storage.write(key: accessTokenKey, value: tokens.accessToken);
    await storage.write(key: refreshTokenKey, value: tokens.refreshToken);
  }

  // getting new accessToken and stored
  Future<void> getNewAccessTokenByRefreshToken() async {
    final refreshToken = await storage.read(key: refreshTokenKey);

    if (refreshToken == null) {
      throw Exception('No refresh token!');
    }

    final response = await http.post(
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
