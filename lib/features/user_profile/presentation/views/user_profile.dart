import 'package:novaed_app/features/user_profile/presentation/views/widgets/user_profile_body.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  final int initialIndex;
  const UserProfile({super.key, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return  PopScope(
      canPop: false,
      child: Scaffold(
        body: UserProfileBody(initialIndex: initialIndex),
      ),
    );
  }
}