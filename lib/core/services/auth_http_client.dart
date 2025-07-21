import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:novaed_app/core/services/auth_service.dart';

class AuthHttpClient extends http.BaseClient {
  final _inner = http.Client();
  final _storage = const FlutterSecureStorage();
  final _authService = AuthService();
  bool _isRefreshing = false;

  // Helper to parse JWT and get expiration time
  int? _getTokenExpiration(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      
      final payload = base64Url.decode(
        parts[1].padRight(
          parts[1].length + (4 - parts[1].length % 4) % 4,
          '='
        )
      );
      
      final payloadMap = json.decode(utf8.decode(payload));
      debugPrint('time: ${payloadMap['exp'] as int?}');
      return payloadMap['exp'] as int?;

    } catch (e) {
      return null;
    }
  }

  // Check if token is expired or near expiration
  bool _isTokenExpiredOrClose(int? expiration) {
    if (expiration == null) return true;
    
    final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final expiresIn = expiration - currentTime;
    
    // we updated this 
    // Only this debug print added
    if (expiresIn < 0) {
    debugPrint('Token expired ${(-expiresIn/60).toStringAsFixed(1)} minutes ago');
  }
    else if (expiresIn >= 60) {
      debugPrint('Token expires in: ${(expiresIn/60).toStringAsFixed(1)} minutes');
    } else {
      debugPrint('Token expires in: $expiresIn seconds');
    }
    
    return expiresIn < 30;
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // Skip token checks for refresh requests
    final isRefreshRequest = request.url.path.endsWith('/refresh-token');
    
    if (!isRefreshRequest) {
      final accessToken = await _storage.read(key: AuthService.accessTokenKey);
      final refreshToken = await _storage.read(key: AuthService.refreshTokenKey);
      
      if (accessToken != null && refreshToken != null) {
        final expiration = _getTokenExpiration(accessToken);
        
        if (_isTokenExpiredOrClose(expiration)) {
          try {
            if (!_isRefreshing) {
              _isRefreshing = true;
              await _authService.getNewAccessTokenByRefreshToken();
              _isRefreshing = false;
            }
            
            final newToken = await _storage.read(key: AuthService.accessTokenKey);
            if (newToken != null) {
              request.headers['Authorization'] = 'Bearer $newToken';
            }
          } catch (e) {
            _isRefreshing = false;
            await _authService.signOut();
            rethrow;
          }
        } else {
          request.headers['Authorization'] = 'Bearer $accessToken';
        }
      }
    }

    return await _inner.send(request);
  }
}