import 'package:novaed_app/features/quiz_screen/presentation/views/widgets/quiz_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class QuizScreen extends StatefulWidget {
  final int lessonId;
  const QuizScreen({super.key, required this.lessonId});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  Widget build(BuildContext context) {
    return const PopScope(
      canPop: false,
      child: Scaffold(
        body: QuizScreenBody(),
      ),
    );
  }
}
