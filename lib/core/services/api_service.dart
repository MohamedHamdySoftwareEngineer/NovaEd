

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:novaed_app/core/services/auth_http_client.dart';
import 'package:novaed_app/core/services/auth_service.dart';

class ApiService {
  final baseUrl = dotenv.env['baseUrl']!;
  final accessToken =
      const FlutterSecureStorage().read(key: AuthService.accessTokenKey);
  ApiService();

  Future<int> createSubmission(int collectionId) async {
    final uri = Uri.parse('$baseUrl/api/v1/submitions')
        .replace(queryParameters: {'CollectionID': '$collectionId'});
    final response = await AuthHttpClient().post(uri, headers: {
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      return int.parse(response.body.trim());
    } else {
      throw Exception(
          'Failed to create submission (status ${response.statusCode})');
    }
  }
}
