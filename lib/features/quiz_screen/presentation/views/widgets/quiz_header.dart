import 'package:flutter/material.dart';
import '../../../../../../core/utils/assets.dart';
import '../../../../../../core/utils/constants.dart';
import '../../../../../core/utils/responsive_helper.dart';

class QuizHeader extends StatelessWidget {
  final int totalQuestions;
  final int currentQuestionIndex;
  final VoidCallback onClosePressed;
  final Size size;

  const QuizHeader({
    super.key,
    required this.totalQuestions,
    required this.currentQuestionIndex,
    required this.onClosePressed,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final height = size.height;
    final width = size.width;
    final isTablet = ResponsiveHelper.isTablet(size);
    final headerPadding = ResponsiveHelper.getPadding(size);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: headerPadding),
        child: Row(
          children: [
            // App Icon on the left - responsive size
            Image.asset(
              AssetsData.quizIconLogo,
              width: height * (isTablet ? 0.055 : 0.065),
              height: height * (isTablet ? 0.055 : 0.065),
            ),

            SizedBox(width: width * 0.02),

            // Progress indicator in the middle with RTL direction
            // we use Expanded to fill available space
            Expanded(
              child: Directionality(
                textDirection: Directionality.of(context),
                child: Container(
                  height: isTablet ? 16 : 14,
                  decoration: BoxDecoration(
                    color: mainColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.getBorderRadius(size, 16),
                    ),
                  ),
                  // we used Stack to allow for the background and progress bar to overlap 
                  // overlap means the progress bar will be on top of the background
                  // main color on top of the background color
                  child: Stack(
                    children: [
                      // Background
                      Container(
                        decoration: BoxDecoration(
                          color: boldBorderColor,
                          borderRadius: BorderRadius.circular(isTablet ? 8 : 7),
                        ),
                      ),
                      // Progress bar with border radius
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final progress = getProgress();
                          return Align(
                            // we use centerRight not left to align the progress bar to the right
                            // means the progress bar will grow from right to left
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: constraints.maxWidth * progress,
                              height: isTablet ? 16 : 14,
                              decoration: BoxDecoration(
                                color: mainColor,
                                borderRadius:
                                    BorderRadius.circular(isTablet ? 8 : 7),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(width: width * 0.03),

            // Close button on the right - responsive size
            GestureDetector(
              onTap: onClosePressed,
              child: Icon(
                Icons.close,
                color: Colors.grey,
                size: isTablet ? 45 : 40,
              ),
            ),
          ],
        ),
      ),
    );
  }

  getProgress() {
    if (totalQuestions <= 0) return 0.0;
    if (currentQuestionIndex < 0) return 0.0;

    final progress = (currentQuestionIndex / totalQuestions) + 0.2;
    return progress.clamp(0.0, 1.0);
  }
}
