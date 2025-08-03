import 'dart:async';

import 'package:novaed_app/core/utils/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/services/auth_service.dart';
import '../../../../../core/utils/assets.dart';
import '../../../../home/presentation/views/home_view.dart';
import '../../../../LogIn/presentation/views/login.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await AuthService().ensureLoggedIn(context)
      .timeout(const Duration(seconds:5));
      AppRouter.toHomeView(context);
    } on TimeoutException {
      AppRouter.toSignIn(context);
    } catch (e) {
      AppRouter.toSignIn(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AssetsData.logoIcon,
      height: 250,
      width: 250,
      fit: BoxFit.contain,
    );
  }
}
