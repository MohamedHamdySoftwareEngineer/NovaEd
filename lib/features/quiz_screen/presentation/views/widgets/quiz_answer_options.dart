import 'package:flutter/material.dart';
import 'package:novaed_app/features/quiz_screen/data/models/quiz_models.dart';
import '../../../../../../core/utils/constants.dart';
import '../../../../../core/utils/responsive_helper.dart';

class QuizAnswerOptions extends StatelessWidget {
  final QuestionWithChoices question;
  final int selectedChoiceId;
  final bool isAnswered;
  final Function(Choice) onAnswerSelected;
  final Size size;

  const QuizAnswerOptions({
    super.key,
    required this.question,
    required this.selectedChoiceId,
    required this.isAnswered,
    required this.onAnswerSelected,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    
    final isClickable = !isAnswered;
    final optionSpacing = ResponsiveHelper.getSpacing(size, 12);

    return Column(
      // we used entries to get the index of each choice
      // and be able to classify them to a,b,c,d

      // question.choice is a list of Choice objects.
      // .asMap() converts that list into a Map where:
      // Keys = index (0, 1, 2...)
      // Values = elements from the list.
      // .entries gives both key and value for each item.
      // .map() creates a list of widgets using both index and choice.
      children: question.choice.asMap().entries.map<Widget>((entry) {
        final index = entry.key;
        final choice = entry.value;
        final isSelected = selectedChoiceId == choice.choiceID;

        // Option letters (أ، ب، ج، د)
        final optionLetters = ['أ', 'ب', 'ج', 'د' , 'هـ', 'و', 'ز', 'ح '];
        final optionLetter = optionLetters[index];

        return Container(
          margin: EdgeInsets.only(bottom: optionSpacing),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: GestureDetector(
              onTap: isClickable ? () => onAnswerSelected(choice) : null,
              // AnimatedContainer animates that transition instead of changing it instantly
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                padding:
                    EdgeInsets.all(ResponsiveHelper.getPadding(size) * 0.8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? mainColor.withOpacity(0.08)
                      : isClickable
                          ? backgroundBoxesColor
                          : backgroundBoxesColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getBorderRadius(size, 16),
                  ),
                  border: Border.all(
                    color: isSelected
                        ? mainColor
                        : isClickable
                            ? mainColor.withOpacity(0.2)
                            : Colors.grey.withOpacity(0.3),
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: mainColor.withOpacity(0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : [
                          BoxShadow(
                            color: secondTextColor.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          )
                        ],
                ),
                child: Row(
                  children: [
                    // Option letter circle
                    Container(
                      width: ResponsiveHelper.getSpacing(size, 32),
                      height: ResponsiveHelper.getSpacing(size, 32),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? mainColor : mainColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          optionLetter,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getFontSize(size, 14),
                            color: isSelected ? Colors.white : mainColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: ResponsiveHelper.getSpacing(size, 16)),

                    // Option text
                    Expanded(
                      child: Text(
                        choice.choiceText,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getFontSize(size, 16),
                          height: 1.5,
                          color: isClickable
                              ? (isSelected ? mainColor : mainTextColor)
                              : Colors.grey,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
