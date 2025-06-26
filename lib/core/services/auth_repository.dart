// This file Hides the API details behind a simple authentication function.
// This allows the rest of the app to use the authentication function without
// needing to know the details of how it works.


import 'package:novaed_app/core/services/api_service.dart';

class AuthRepository {
  final ApiService apiService;
  AuthRepository({required this.apiService});

  
}
