import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/api_service.dart';
import '../manager/profile_cubit.dart';
import 'widgets/user_profile_body.dart';

class UserProfile extends StatelessWidget {
  final int initialIndex;
  const UserProfile({super.key, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(ApiService())..getUserInfo(),
      child: Scaffold(
        body: UserProfileBody(initialIndex: initialIndex),
      ),
    );
  }
}
