import 'package:novaed_app/core/utils/app_router.dart';
import 'package:novaed_app/core/utils/constants.dart';
import 'package:flutter/material.dart';

class ExitButton extends StatelessWidget {
    const ExitButton({super.key});

    @override
    Widget build(BuildContext context) {
      return Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red.withOpacity(0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: OutlinedButton.icon(
          onPressed: () {
            AppRouter.toSignIn(context);
          },
          icon: const Icon(Icons.logout, color: Colors.red, size: 20),
          label: const Text(
            'تسجيل الخروج',
            style: TextStyle(
              color: Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: OutlinedButton.styleFrom(
            backgroundColor: backgroundBoxesColor,
            side: BorderSide.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      );
    }
  }