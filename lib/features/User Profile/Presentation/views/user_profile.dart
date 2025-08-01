import 'package:flutter/material.dart';

import 'widgets/user_profile_body.dart';

class UserProfile extends StatelessWidget {
  final int initialIndex;
  const UserProfile({super.key, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UserProfileBody(initialIndex: initialIndex),
    );
  }
}
