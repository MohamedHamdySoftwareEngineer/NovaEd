import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:novaed_app/features/quiz_screen/data/models/quiz_models.dart';
import 'package:novaed_app/features/quiz_screen/presentation/manager/question_cubit.dart';
import 'package:novaed_app/features/quiz_screen/presentation/manager/question_state.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../../../../core/utils/styles.dart';
import 'quiz_answer_options.dart';
import 'quiz_exit_dialog.dart';
import 'quiz_explanation_bottom_sheet.dart';
import 'quiz_header.dart';
import 'quiz_question_card.dart';
import 'quiz_shimmer_skeleton.dart';
import 'quiz_submit_button.dart';

class QuizScreenBody extends StatefulWidget {
  final int submissionId;
  final int collectionId;
  const QuizScreenBody({
    super.key,
    required this.submissionId,
    required this.collectionId,
  });

  @override
  QuizScreenBodyState createState() => QuizScreenBodyState();
}

class QuizScreenBodyState extends State<QuizScreenBody> {
  int selectedChoiceId = -1;
  bool isLoading = false;
  int currentQuestionIndex = 0;
  Choice? selectedChoice;
  List<QuestionWithChoices> _questions = [];
  dynamic currentExplanation;
  bool isAnswered = false;
  bool isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final isLargeScreen = size.width > 900;

    return BlocConsumer<QuestionCubit, QuestionState>(
      listener: (ctx, state) {
        if (state is QuestionSuccess) {
          setState(() {
            // Check if this is a new set of questions (when _questions was not empty before)
            final wasReloadingQuestions = _questions.isNotEmpty;
            
            _questions = state.questions;
            
            // Only reset when reloading questions (not initial load)
            if (wasReloadingQuestions) {
              currentQuestionIndex = 0;
              selectedChoiceId = -1;
              selectedChoice = null;
              currentExplanation = null;
              isAnswered = false;
              isSubmitting = false;
            }
          });
        }
        if (state is ChoiceSubmitSuccess) {
          setState(() {
            isSubmitting = false;
          });
          final q = _questions[currentQuestionIndex];
          debugPrint('Fetching explanation for question ID: ${q.questionID}');
          ctx.read<QuestionCubit>().getExplanation(q.questionID);
        }
        if (state is ExplanationSuccess) {
          setState(() {
            currentExplanation = state.explanation;
            isAnswered = true;
          });

          QuizExplanationSheet.show(
            selectedChoiceId: selectedChoiceId,
            size: size,
            context: context,
            explanation: state.explanation,
            onNextPressed: _navigateToNext,
            isLastQuestion: currentQuestionIndex == _questions.length - 1,
          );
        }
      },
      builder: (context, state) {
        // Only show loading shimmer for initial load (when _questions is empty)
        if (state is QuestionLoading && _questions.isEmpty) {
          return QuizShimmerSkeleton(
            size: size,
            padding: ResponsiveHelper.getPadding(size),
            isTablet: isTablet,
          );
        }
        
        if (state is QuestionFailure) {
          return Center(
            child: Container(
              constraints: BoxConstraints(
                  maxWidth: isLargeScreen ? 600 : double.infinity),
              child: Text(
                state.errorMessage,
                style: Styles.mainBlackText18.copyWith(
                  fontSize: ResponsiveHelper.getFontSize(size, 18),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (_questions.isNotEmpty) {
          return Container(
            color: backgroundColor,
            child: Column(
              children: [
                QuizHeader(
                  size: size,
                  onClosePressed: () => QuizExitDialog.show(context, size),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Center(
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: isLargeScreen
                              ? 800
                              : (isTablet ? 600 : double.infinity),
                        ),
                        padding:
                            EdgeInsets.all(ResponsiveHelper.getPadding(size)),
                        child: Column(
                          children: [
                            QuizQuestionCard(
                              size: size,
                              question: _questions[currentQuestionIndex],
                            ),
                            SizedBox(
                                height: ResponsiveHelper.getSpacing(size, 20)),
                            QuizAnswerOptions(
                              size: size,
                              question: _questions[currentQuestionIndex],
                              selectedChoiceId: selectedChoiceId,
                              isAnswered: isAnswered,
                              onAnswerSelected: _handleAnswerSelection,
                            ),
                            SizedBox(
                                height: ResponsiveHelper.getSpacing(size, 20)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                QuizSubmitButton(
                  size: size,
                  hasSelectedAnswer: selectedChoiceId != -1,
                  isAnswered: isAnswered,
                  isSubmitting: isSubmitting,
                  onSubmit: _submitAnswer,
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  void _submitAnswer() {
    if (selectedChoice != null && !isAnswered) {
      setState(() {
        isSubmitting = true;
      });

      context.read<QuestionCubit>().submitChoice(
            selectedChoice!.choiceID,
            widget.submissionId,
          );
    }
  }

  void _navigateToNext() {
    if (!mounted) return;

    Navigator.of(context).pop(); // close the explanation sheet

    // Check if this is the last question BEFORE incrementing
    final isLastQuestion = currentQuestionIndex >= _questions.length - 1;

    if (isLastQuestion) {
      // Fetch new questions - no loading flag needed
      // The current questions stay visible until new ones arrive
      context.read<QuestionCubit>().getQuestions(widget.collectionId);
    } else {
      // Move to next question in current batch
      setState(() {
        currentQuestionIndex++;
        selectedChoiceId = -1;
        selectedChoice = null;
        currentExplanation = null;
        isAnswered = false;
        isSubmitting = false;
      });
    }
  }

  void _handleAnswerSelection(Choice choice) {
    if (!isAnswered) {
      setState(() {
        selectedChoiceId = choice.choiceID;
        selectedChoice = choice;
      });
    }
  }
}