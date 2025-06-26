import 'package:novaed_app/core/utils/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/utils/assets.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody> {
  @override
  void initState() {
    super.initState();
    navigateToHome();
  }

  void navigateToHome() {
    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) context.go(AppRouter.rSignIn);
    });
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
