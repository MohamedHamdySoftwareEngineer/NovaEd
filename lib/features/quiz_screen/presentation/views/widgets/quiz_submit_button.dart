import 'package:flutter/material.dart';
import '../../../../../../core/utils/constants.dart';
import '../../../../../core/utils/responsive_helper.dart';

class QuizSubmitButton extends StatelessWidget {
  final bool hasSelectedAnswer;
  final bool isAnswered;
  final bool isSubmitting;
  final VoidCallback onSubmit;
  final Size size;

  const QuizSubmitButton({
    super.key,
    required this.hasSelectedAnswer,
    required this.isAnswered,
    required this.isSubmitting,
    required this.onSubmit,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final isButtonEnabled = hasSelectedAnswer && !isAnswered && !isSubmitting;
    final isTablet = ResponsiveHelper.isTablet(size);
    final isLargeScreen = ResponsiveHelper.isLargeScreen(size);
    final padding = ResponsiveHelper.getPadding(size);

    return Padding(
      padding: EdgeInsets.fromLTRB(padding, 0, padding, padding),
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: isLargeScreen ? 600 : (isTablet ? 400 : double.infinity),
          ),
          child: SizedBox(
            width: double.infinity,
            height: isTablet ? 64 : 56,
            child: ElevatedButton(
              onPressed: isButtonEnabled ? onSubmit : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isButtonEnabled ? mainColor : Colors.grey,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getBorderRadius(size, 16),
                  ),
                ),
              ),
              child: isSubmitting
                  ? SizedBox(
                      width: isTablet ? 28 : 24,
                      height: isTablet ? 28 : 24,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      isAnswered ? 'تم الإجابة' : 'تأكيد الإجابة',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getFontSize(size, 18),
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
