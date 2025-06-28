import 'package:novaed_app/core/widgets/base_scaffold.dart';
import 'package:novaed_app/core/widgets/header_section.dart';
import 'package:flutter/material.dart';
import '../../../../../core/utils/app_router.dart';
import '../../../../../core/utils/assets.dart';
import '../../../../../core/utils/constants.dart';

class ChoiceScreenBody extends StatelessWidget {
  final int initialIndex;
  const ChoiceScreenBody({super.key, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBartTitle: 'المواد الدراسية',
      initialIndex: initialIndex,
      child: Container(
        color: backgroundColor,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const HeaderSection(text: 'اختر المادة',imagePath: AssetsData.choicesLogo,),
                const SizedBox(height: 30),
                _buildSubjectsGrid(context),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
 
  
  Widget _buildSubjectsGrid(BuildContext context) {
    final subjects = [
      {
        'title': 'رياضيات',
        'icon': Icons.calculate_rounded,
        'color': const Color(0xFFFF8A65),
        'lightColor': const Color(0xFFFFE0B2),
      },
      {
        'title': 'فيزياء',
        'icon': Icons.rocket_launch_rounded,
        'color': const Color(0xFFFF7043),
        'lightColor': const Color(0xFFFFCCBC),
      },
      {
        'title': 'أحياء',
        'icon': Icons.eco_rounded,
        'color': const Color(0xFF66BB6A),
        'lightColor': const Color(0xFFC8E6C9),
      },
      {
        'title': 'كيمياء',
        'icon': Icons.science_rounded,
        'color': const Color(0xFF42A5F5),
        'lightColor': const Color(0xFFBBDEFB),
      },
    ];

    return Column(
      children: subjects.map((subject) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: _buildSubjectCard(
            context: context,
            title: subject['title'] as String,
            icon: subject['icon'] as IconData,
            color: subject['color'] as Color,
            lightColor: subject['lightColor'] as Color,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSubjectCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required Color lightColor,
  }) {
    return GestureDetector(
      onTap: () {
        AppRouter.toQuizScreen(context);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundBoxesColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: secondTextColor.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon section
            Icon(
              icon,
              color: color,
              size: 55,
            ),
            const SizedBox(width: 20),
            // Text section
            Expanded(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: mainTextColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
