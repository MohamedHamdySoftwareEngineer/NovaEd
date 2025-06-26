import 'package:novaed_app/features/choice_screen/presentation/views/widgets/choice_screen_body.dart';
import 'package:flutter/material.dart';

class ChoiceScreen extends StatelessWidget {
  final int initialIndex;
  const ChoiceScreen({super.key, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: ChoiceScreenBody(initialIndex: initialIndex)
        ),
    );
  }
}
