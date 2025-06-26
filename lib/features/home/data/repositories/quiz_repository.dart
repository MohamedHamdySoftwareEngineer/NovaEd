import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/quiz_model.dart';

class QuizRepository {
  final Dio dio;
  final FlutterSecureStorage storage;

  QuizRepository({required this.dio, required this.storage});

  Future <List<QuizModel>> fetchQuiz (int lessonId) async{
    // read the saved JWT
    final token = await storage.read(key:'jwt_token');
    if (token == null){
      throw Exception('No JWT token found, please log in first.');
    }    

    // call you api with header
    final response = await dio.get(
      'questions/$lessonId',
      options: Options(headers: {
        'Authorization' : 'Bearer $token',
      }),
    );
    // parse and return the response data
    // parse means convert the response data to a list of QuizModel
    return (response.data as List)
        .map((e) => QuizModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
