import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:novaed_app/core/services/auth_service.dart';

class AuthHttpClient extends BaseClient {
  final inner = Client();
  final storage = const FlutterSecureStorage();
  final authService = AuthService();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // read the access token
    final token = await storage.read(key: AuthService.accessTokenKey);
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    // send the request
    var response = await inner.send(request);

    // if 401, try refresh + retry once
    if (response.statusCode == 401) {
      try {
        await authService.getNewAccessTokenByRefreshToken();
        final newToken = await storage.read(key: AuthService.accessTokenKey);
        if (newToken != null) {
          request.headers['Authorization'] = 'Bearer $newToken';
          response = await inner.send(request);
        }
      } catch (_) {
        // refresh failed -> force sign out
        await authService.signOut();
        rethrow;
      }
    }
    return response;
  }
}

