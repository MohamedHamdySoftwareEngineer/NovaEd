import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novaed_app/core/services/api_service.dart';
import 'package:novaed_app/features/choice_screen/presentation/manager/submission_cubit.dart';
import 'package:novaed_app/features/choice_screen/presentation/views/widgets/choice_screen_body.dart';
import 'package:flutter/material.dart';

class ChoiceScreen extends StatelessWidget {
  final int initialIndex;
  const ChoiceScreen({super.key, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubmissionCubit(ApiService()),
      child: PopScope(
        canPop: false,
        child: Scaffold(
          body: ChoiceScreenBody(initialIndex: initialIndex)),
      ),
    );
  }
}
