import 'package:flutter/material.dart';
import 'package:novaed_app/features/quiz_screen/data/models/quiz_models.dart';
import '../../../../../../core/utils/constants.dart';
import '../../../../../../core/utils/styles.dart';
import '../../../../../core/utils/responsive_helper.dart';

class QuizQuestionCard extends StatelessWidget {
  final QuestionWithChoices question;
  final int currentQuestionIndex;
  final Size size;

  const QuizQuestionCard({
    super.key,
    required this.question,
    required this.currentQuestionIndex,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final cardPadding = ResponsiveHelper.getPadding(size);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: cardPadding * 1.2,
        vertical: cardPadding * 0.8,
      ),
      decoration: BoxDecoration(
        color: backgroundBoxesColor,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getBorderRadius(size, 20),
        ),
        border: Border.all(
          width: 1.5,
          color: boldBorderColor.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: secondTextColor.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question number indicator
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getSpacing(size, 12),
                vertical: ResponsiveHelper.getSpacing(size, 6),
              ),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.getBorderRadius(size, 12),
                ),
              ),
              child: Text(
                'السؤال ${currentQuestionIndex + 1}',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getFontSize(size, 12),
                  color: mainColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            SizedBox(height: ResponsiveHelper.getSpacing(size, 16)),

            // Question text
            Text(
              question.questionText,
              style: Styles.mainBlackText18.copyWith(
                fontSize: ResponsiveHelper.getFontSize(size, 18),
                height: 1.6,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
    );
  }
}
