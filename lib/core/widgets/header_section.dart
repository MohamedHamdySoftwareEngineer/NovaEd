import 'package:novaed_app/core/utils/constants.dart';
import 'package:novaed_app/core/utils/styles.dart';
import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  final String text,imagePath;
  
  const HeaderSection({super.key,required this.text  , required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            mainColor,
            mainColor.withOpacity(0.8),
          ],
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: mainColor.withOpacity(0.25),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
           imagePath,
            width: 100,
            height: 100,
          ),
          const SizedBox(width: 20),
           Text(
            text,
            style: Styles.mainText28,
          ),
        ],
      ),
    );
  }
}
