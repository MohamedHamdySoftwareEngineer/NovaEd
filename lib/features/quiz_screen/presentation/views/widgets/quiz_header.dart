import 'package:flutter/material.dart';
import '../../../../../../core/utils/assets.dart';
import '../../../../../core/utils/responsive_helper.dart';

class QuizHeader extends StatelessWidget {
  final VoidCallback onClosePressed;
  final Size size;

  const QuizHeader({
    super.key,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // App Icon on the left - responsive size
            Image.asset(
              AssetsData.quizIconLogo,
              width: height * (isTablet ? 0.055 : 0.065),
              height: height * (isTablet ? 0.055 : 0.065),
            ),

            SizedBox(width: width * 0.02),

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

 
}
