import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:novaed_app/core/services/auth_http_client.dart';
import 'package:novaed_app/features/quiz_screen/data/models/quiz_models.dart';

class ApiService {
  final baseUrl = dotenv.env['baseUrl']!;
  final myHttp = AuthHttpClient();
  

  Future<int> createSubmission(int collectionId) async {
    final uri = Uri.parse('$baseUrl/api/v1/submitions')
        .replace(queryParameters: {'CollectionID': '$collectionId'});

    final response = await myHttp.post(uri);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return int.parse(response.body.trim());
    } else {
      throw Exception(
          'Failed to create submission (status ${response.statusCode})');
    }
  }

  Future<List<QuestionWithChoices>> getQuestions(int collectionId) async {
    final uri = Uri.parse('$baseUrl/api/v1/questions/random')
        .replace(queryParameters: {'CollectionID': '$collectionId'});

    final response =
        await myHttp.get(uri);

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      if (parsed is! List) {
        debugPrint('Unexpected response format: ${response.body}');
        throw Exception('Unexpected response format');
      }

      final questions = parsed
          .map((data) =>
              QuestionWithChoices.fromJson(data as Map<String, dynamic>))
          .toList();
      return questions;
    } else {
      
      throw Exception(
          'Failed to load questions (status ${response.statusCode})');
    }
  }

  Future<ChoiceResult> submitChoice(int choiceID, int submitionID) async {
    final uri = Uri.parse('$baseUrl/api/v1/choices/chosen');
    final response = await myHttp.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'choiceID': choiceID,
        'submitionID': submitionID,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Submit choice failed : ${response.statusCode}');
    }

    return ChoiceResult.fromJson(json.decode(response.body));
  }

  Future<Explanation> getExplanation(int questionID) async {
    final uri =
        Uri.parse('$baseUrl/api/v1/questions/right-answer-with-explanation/$questionID');

    final response = await myHttp.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Fetch explanation failed: ${response.statusCode}');
    }

    final Map<String, dynamic> jsonMap = json.decode(response.body);
    return Explanation.fromJson(jsonMap);
  }
  
}