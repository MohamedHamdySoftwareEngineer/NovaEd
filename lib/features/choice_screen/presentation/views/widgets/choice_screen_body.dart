import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novaed_app/core/widgets/base_scaffold.dart';
import 'package:novaed_app/core/widgets/header_section.dart';
import 'package:flutter/material.dart';
import 'package:novaed_app/features/choice_screen/presentation/manager/submission_cubit.dart';
import 'package:novaed_app/features/choice_screen/presentation/manager/submission_state.dart';
import '../../../../../core/utils/app_router.dart';
import '../../../../../core/utils/assets.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../../core/utils/responsive_helper.dart';

class ChoiceScreenBody extends StatelessWidget {
  final int initialIndex;
  const ChoiceScreenBody({super.key, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                const HeaderSection(
                  text: 'اختر المادة',
                  imagePath: AssetsData.choicesLogo,
                ),
                SizedBox(height:  ResponsiveHelper.getSpacing(size, 30)),
                _buildSubjectsGrid(context,size),
                SizedBox(height: ResponsiveHelper.getSpacing(size, 50)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectsGrid(BuildContext context , Size size) {
    final subjects = [
      {
        'title': 'رياضيات',
        'icon': Icons.calculate_rounded,
        'color': const Color(0xFFFF8A65),
        'lightColor': const Color(0xFFFFE0B2),
        'collectionId': 1091,
      },
      {
        'title': 'فيزياء',
        'icon': Icons.rocket_launch_rounded,
        'color': const Color(0xFFFF7043),
        'lightColor': const Color(0xFFFFCCBC),
        'collectionId': 1091,
      },
      {
        'title': 'أحياء',
        'icon': Icons.eco_rounded,
        'color': const Color(0xFF66BB6A),
        'lightColor': const Color(0xFFC8E6C9),
        'collectionId': 1091,
      },
      {
        'title': 'كيمياء',
        'icon': Icons.science_rounded,
        'color': const Color(0xFF42A5F5),
        'lightColor': const Color(0xFFBBDEFB),
        'collectionId': 1091,
      },
    ];

    return Column(
      children: subjects.map((subject) {
        return BlocListener<SubmissionCubit, SubmissionState>(
           listener: (context, state) {
                    if (state is SubmissionSuccess) {
                      AppRouter.toQuizScreen(context,
                          submissionId: state.submissionId,collectionId: subject['collectionId'] as int);
                    } else if (state is SubmissionFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.errorMessage)),
                      );
                    }
                  },
          child: Container(
            margin: EdgeInsets.only(bottom: ResponsiveHelper.getSpacing(size, 20)),
            child: _buildSubjectCard(
              context: context,
              title: subject['title'] as String,
              icon: subject['icon'] as IconData,
              color: subject['color'] as Color,
              lightColor: subject['lightColor'] as Color,
              collectionId: subject['collectionId'] as int,
            ),
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
    required int collectionId,
  }) {
    // context.read<SubmissionCubit>() is used to access the SubmissionCubit instance
    // from the BlocProvider in the widget tree. It allows us to call methods on the
    // cubit without needing to listen to its state changes in this widget.
    // This is useful for triggering actions like creating a submission when the user taps on a subject
    // card without needing to rebuild the widget when the state changes.
    // and didn't use BlocListener or BlocBuilder here because we only need to trigger an action
    // (creating a submission) when the user taps on the card, not to rebuild the
    // widget based on the cubit's state.
    // means we are not interested in the state changes of the cubit in this widget,
    // we just want to call a method on it when the user interacts with the widget.
    final cubit = context.read<SubmissionCubit>();
    return GestureDetector(
      onTap: () {
        cubit.create(collectionId);
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
