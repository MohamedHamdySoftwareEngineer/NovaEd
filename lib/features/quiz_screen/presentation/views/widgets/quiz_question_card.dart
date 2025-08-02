import 'package:flutter/material.dart';
import 'package:novaed_app/features/quiz_screen/data/models/quiz_models.dart';
import '../../../../../../core/utils/constants.dart';
import '../../../../../../core/utils/styles.dart';
import '../../../../../core/utils/responsive_helper.dart';

class QuizQuestionCard extends StatelessWidget {
  final QuestionWithChoices question;
  final Size size;
  
  const QuizQuestionCard({
    super.key,
    required this.question,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final cardPadding = ResponsiveHelper.getPadding(size);
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(cardPadding * 1.5),
      decoration: BoxDecoration(
        color: backgroundBoxesColor,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getBorderRadius(size, 16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Text(
          question.questionText,
          style: Styles.mainBlackText18.copyWith(
            fontSize: ResponsiveHelper.getFontSize(size, 18),
            height: 1.5,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.right,
        ),
      ),
    );
  }
}