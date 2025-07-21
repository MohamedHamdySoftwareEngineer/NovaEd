import 'package:flutter/material.dart';
import 'package:novaed_app/core/utils/responsive_helper.dart';
import 'package:novaed_app/features/quiz_screen/data/models/quiz_models.dart';
import '../../../../../../core/utils/constants.dart';
import 'naviagation_buttons.dart';

class QuizExplanationSheet {
  static void show({
    required BuildContext context,
    required Explanation explanation,
    required VoidCallback onNextPressed,
    required bool isLastQuestion,
    required Size size,
    required int selectedChoiceId,
  }) {
    showModalBottomSheet(
      context: context,
      // Makes it possible to show the modal full-screen height.
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      // User cannot tap outside to close the sheet.
      isDismissible: false,
      // User cannot drag (move down) to close the sheet.
      enableDrag: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft:
                    Radius.circular(ResponsiveHelper.getBorderRadius(size, 24)),
                topRight:
                    Radius.circular(ResponsiveHelper.getBorderRadius(size, 24)),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(ResponsiveHelper.getPadding(size)),
              child: Column(
                // min keeps the sheet size compact, only expanding based on
                // the content (like explanation and buttons).
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ExplanationCard(
                      explanation: explanation,
                      size: size,
                      selectedChoiceId: selectedChoiceId),
                  SizedBox(height: ResponsiveHelper.getSpacing(size, 20)),
                  NavigationButtons(
                    size: size,
                    isLastQuestion: isLastQuestion,
                    onNext: onNextPressed,
                    mainColor: mainColor,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ExplanationCard extends StatelessWidget {
  final int selectedChoiceId;
  final Explanation explanation;
  final Size size;

  const _ExplanationCard({
    required this.explanation,
    required this.size,
    required this.selectedChoiceId,
  });

  @override
  Widget build(BuildContext context) {
    final isCorrect = (explanation.rightAnswerChoiceID == selectedChoiceId);
    debugPrint('Selected Choice ID: $selectedChoiceId');
    debugPrint('Right Answer Choice ID: ${explanation.rightAnswerChoiceID}');
    final isTablet = ResponsiveHelper.isTablet(size);
    final cardPadding = ResponsiveHelper.getPadding(size) + 8;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: backgroundBoxesColor,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getBorderRadius(size, 24),
        ),
        border: Border.all(
          color: isCorrect ? correctAnswerColor : wrongAnswerColor,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: secondTextColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isTablet ? 16 : 12),
                  decoration: BoxDecoration(
                    color: isCorrect
                        ? correctAnswerColor.withOpacity(0.1)
                        : wrongAnswerColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isCorrect ? Icons.check_circle : Icons.cancel,
                    color: isCorrect ? correctAnswerColor : wrongAnswerColor,
                    size: isTablet ? 36 : 32,
                  ),
                ),
                SizedBox(width: ResponsiveHelper.getSpacing(size, 16)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isCorrect ? 'إجابة صحيحة!' : 'إجابة خاطئة!',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getFontSize(size, 20),
                          fontWeight: FontWeight.bold,
                          color:
                              isCorrect ? correctAnswerColor : wrongAnswerColor,
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.getSpacing(size, 4)),
                      Text(
                        isCorrect
                            ? 'أحسنت! لقد اخترت الإجابة الصحيحة'
                            : 'لا بأس، تعلم من الخطأ',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getFontSize(size, 14),
                          color: secondTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveHelper.getSpacing(size, 24)),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(ResponsiveHelper.getPadding(size)),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.getBorderRadius(size, 16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الشرح:',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getFontSize(size, 16),
                      fontWeight: FontWeight.w600,
                      color: mainColor,
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.getSpacing(size, 12)),
                  Text(
                    explanation.explanationText,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getFontSize(size, 18),
                      fontWeight: FontWeight.w500,
                      color: mainTextColor,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
            SizedBox(height: ResponsiveHelper.getSpacing(size, 16)),
          ],
        ),
      ),
    );
  }
}
