import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class ApiService {
  /// Replace with your real backend base URL (no trailing slash)
  static const String baseUrl =
      'http://novaedapp-env.eba-ceaqmh3m.me-south-1.elasticbeanstalk.com';

  /// Your backend–provided OAuth Web Client ID
  static const String webClientId =
      '401048982997-t8g45cnv8h9k51juspujusrvuhfptm93.apps.googleusercontent.com';

  /// Configure GoogleSignIn to mint an ID token
  /// whose audience (`aud`) matches your backend Client ID.
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId: webClientId,
  );

  /// 1. Sign in via Google account picker
  /// 2. Retrieve Google ID token
  /// 3. Call your backend external-login endpoint
  Future<Map<String, dynamic>> signInWithGoogle() async {
    // Add platform check for web
    if (kIsWeb) {
      _googleSignIn = GoogleSignIn(
        clientId: webClientId,
        scopes: ['email', 'profile'],
      );
    }

    // --- Google Sign-In flow ---
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      // user canceled
      throw Exception('Google sign-in was aborted by user');
    }

    // get the Google-issued ID token
    final googleAuth = await googleUser.authentication;
    final googleIdToken = googleAuth.idToken;
    if (googleIdToken == null) {
      throw Exception('Failed to obtain Google ID token');
    }

    // --- Call your backend ---
    final uri = Uri.parse('$baseUrl/api/v1/users/external-login');
    final response = await http
        .post(
          uri,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'provider': 'Google',
            'idToken': googleIdToken,
          }),
        )
        .timeout(const Duration(seconds: 30));
    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return responseBody;
    } else {
      throw ApiException(
        code: response.statusCode,
        message: responseBody['message'] ?? 'Authentication failed',
      );
    }
  }

  /// Optional: sign out Google
  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

  // Add token verification helper
  Future<bool> verifyGoogleToken(String idToken) async {
    final response = await http.post(
      Uri.parse('https://www.googleapis.com/oauth2/v3/tokeninfo'),
      body: {'id_token': idToken},
    );

    return response.statusCode == 200 &&
        jsonDecode(response.body)['aud'] == webClientId;
  }
}

class ApiException implements Exception {
  final int code;
  final String message;

  ApiException({required this.code, required this.message});
}
