// custom_bottom_bar.dart
import 'package:novaed_app/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:smart_nav_bar/smart_nav_bar.dart';

import '../utils/app_router.dart';
import '../utils/assets.dart';

class CustomBottomBar extends StatefulWidget {
  final int currentIndex;
  const CustomBottomBar({super.key, required this.currentIndex});

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    return SmartBottomNav(
      currentIndex: _currentIndex,
      items: const [
        SmartNavItem(
          iconPath: AssetsData.profileIcon,
          label: 'Profile',
          activeColor: mainColor,
          inactiveColor: secondTextColor,
        ),
        SmartNavItem(
          iconPath: AssetsData.subjectsIcon,
          label: 'Subjects',
          activeColor: mainColor,
          inactiveColor: secondTextColor,
        ),
      ],
      onTap: (index) {
        if (index == _currentIndex) return;
        setState(() => _currentIndex = index);
        _navigateToScreen(index, context);
      },
    );
  }

  void _navigateToScreen(int index, BuildContext context) {
    switch (index) {
      case 0:
        AppRouter.toUserProfile(context);
      case 1:
        AppRouter.toChoiceScreen(context);
        break;
    }
  }
}
