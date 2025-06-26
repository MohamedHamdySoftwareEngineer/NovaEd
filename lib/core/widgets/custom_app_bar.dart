import 'package:novaed_app/core/utils/app_router.dart';
import 'package:novaed_app/core/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../utils/styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String appBarTitle;
  const CustomAppBar({super.key, required this.appBarTitle});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      shadowColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      // left: back arrow
      leading: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined, size: 28),
          onPressed: () {
            final currentRouteName = ModalRoute.of(context)?.settings.name;
            if (currentRouteName == AppRouter.rChoiceScreen) {
              AppRouter.toHomeView(context);
            } else {
              AppRouter.toChoiceScreen(context);
            }
          },
          padding: EdgeInsets.zero,
        ),
      ),
      // right: user profile icon
      title: Text(
        appBarTitle,
        style: Styles.mainText23,
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
