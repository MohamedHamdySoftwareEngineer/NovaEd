import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novaed_app/features/user_profile/presentation/manager/user_cubit.dart';
import 'package:novaed_app/features/user_profile/presentation/views/widgets/user_profile_body.dart';
import 'package:flutter/material.dart';

import '../../../sign_in/data/models/user_model.dart';

class UserProfile extends StatelessWidget {
  final User user;
  final int initialIndex;
  const UserProfile({super.key, required this.initialIndex,required this.user});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BlocProvider(
        create: (context) => UserCubit()..setUser(user),
        child: Scaffold(
          body: UserProfileBody(initialIndex: initialIndex),
        ),
      ),
    );
  }
}
