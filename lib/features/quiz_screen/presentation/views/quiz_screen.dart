import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novaed_app/core/services/api_service.dart';
import 'package:novaed_app/features/quiz_screen/presentation/manager/question_cubit.dart';
import 'package:novaed_app/features/quiz_screen/presentation/views/widgets/quiz_screen_body.dart';
import 'package:flutter/material.dart';

class QuizScreen extends StatelessWidget {
  final int submissionId, collectionId;
  const QuizScreen({
    super.key,
    required this.submissionId,
    required this.collectionId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
       create: (context) =>
              QuestionCubit(ApiService())..getQuestions(collectionId),
      
      child: PopScope(
        canPop: false,
        child: Scaffold(
          body: QuizScreenBody(
            submissionId: submissionId,
          ),
        ),
      ),
    );
  }
}
