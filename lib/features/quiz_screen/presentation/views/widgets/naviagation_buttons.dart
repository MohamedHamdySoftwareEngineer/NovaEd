import 'package:flutter/material.dart';
import 'package:novaed_app/core/utils/responsive_helper.dart';

class NavigationButtons extends StatelessWidget {

  final VoidCallback onNext;
  final Color mainColor;
  final Size size;

  const NavigationButtons({
    super.key,
    
    required this.onNext,
    required this.mainColor,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = size.width > 600;
    final buttonHeight = isTablet ? 56.0 : 48.0;

    return Row(
      children: [
       
          Expanded(
            child: SizedBox(
              height: buttonHeight,
              child: ElevatedButton(
                onPressed: onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.getBorderRadius(size, 12),
                    ),
                  ),
                ),
                child: Text(
                  'السؤال التالي',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getFontSize(size, 16),
                  ),
                ),
              ),
            ),
          ),
       
      ],
    );
  }
}
