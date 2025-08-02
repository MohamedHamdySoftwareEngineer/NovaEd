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
  // submissionId is used to uniquely identify the quiz session for the user.
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
  // -1 meaning “no answer selected.” , Valid choice IDs will always be positive
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

    // BlocConsumer listens to the QuestionCubit state changes. It rebuilds
    //the UI when the state changes (via builder) and performs side effects
    // like showing explanations (via listener). It’s used to separate
    //state-handling logic from UI rendering.
    return BlocConsumer<QuestionCubit, QuestionState>(
      listener: (ctx, state) {
        if (state is QuestionSuccess) {
          _questions = state.questions;
        }
        if (state is ChoiceSubmitSuccess) {
          setState(() {
            isSubmitting = false;
          });
          final q = _questions[currentQuestionIndex];
          // to listen on changes, we didn't but in onPresesed method because his appear doesn't related with button clicked
          // and we want to show explanation when the answer is submitted
          // this line returns the explanation and gave him to the cubit
          debugPrint('Fetching explanation for question ID: ${q.questionID}');
          ctx.read<QuestionCubit>().getExplanation(q.questionID);
        }
        if (state is ExplanationSuccess) {
          setState(() {
            currentExplanation = state.explanation;
            isAnswered = true;
          });

          // Show bottom sheet with explanation
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

        // Always show the quiz UI if we have questions
        if (_questions.isNotEmpty) {
          return Container(
            color: backgroundColor,
            child: Column(
              children: [
                // Custom header with progress, close button, and app icon
                QuizHeader(
                  size: size,
                  onClosePressed: () => QuizExitDialog.show(context, size),
                ),

                // Scrollable content with responsive constraints
                Expanded(
                  child: SingleChildScrollView(
                    // to make keyboard dismissible when scrolling
                    // i didn't need it but i used it
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

                // Submit button at bottom with responsive width
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
    // debugPrint(
    //     '🔄 Current question: ${currentQuestionIndex + 1}/${_questions.length}');
    // debugPrint(
    //     '🔄 Is last question: ${currentQuestionIndex >= _questions.length - 1}');

    if (!mounted || !Navigator.of(context).canPop()) return;

    Navigator.of(context).pop(); // close the explanation sheet

    // Check if this is the last question BEFORE incrementing
    final isLastQuestion = currentQuestionIndex >= _questions.length - 1;

    if (isLastQuestion) {
      // 1. Fetch a fresh batch of questions
      context.read<QuestionCubit>().getQuestions(widget.collectionId);

      // 2. Reset our pointer and UI flags (so new list starts at 0)
      setState(() {
        currentQuestionIndex = 0;
        selectedChoiceId = -1;
        selectedChoice = null;
        currentExplanation = null;
        isAnswered = false;
        isSubmitting = false;
      });

      // // Only navigate to choice screen if we've actually finished all questions
      // AppRouter.toChoiceScreen(context);
    } else {
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
    // If the question is already answered, do not allow re-selection
    // but if an answer is selected, allow changing the selection
    if (!isAnswered) {
      setState(() {
        selectedChoiceId = choice.choiceID;
        selectedChoice = choice;
      });
    }
  }
}
