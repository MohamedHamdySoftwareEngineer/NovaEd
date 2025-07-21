import 'package:flutter/material.dart';
import '../../../../../../core/utils/app_router.dart';
import '../../../../../../core/utils/constants.dart';
import '../../../../../core/utils/responsive_helper.dart';


class QuizExitDialog {
  static void show(BuildContext context, Size size) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: backgroundBoxesColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.getBorderRadius(size, 16),
              ),
            ),
            title: Text(
              'مغادرة الاختبار',
              style: TextStyle(
                color: mainTextColor,
                fontWeight: FontWeight.bold,
                fontSize: ResponsiveHelper.getFontSize(size, 18),
              ),
            ),
            content: Text(
              'هل أنت متأكد من أنك تريد مغادرة الاختبار؟ سيتم فقدان تقدمك.',
              style: TextStyle(
                color: secondTextColor,
                fontSize: ResponsiveHelper.getFontSize(size, 16),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();// Close the dialog
                },
                child: Text(
                  'إلغاء',
                  style: TextStyle(
                    color: secondTextColor,
                    fontSize: ResponsiveHelper.getFontSize(size, 16),
                  ),
                ),
              ),
              
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  AppRouter.toChoiceScreen(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  'مغادرة',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getFontSize(size, 16),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}