import 'package:novaed_app/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

import 'custom_bottom_bar.dart';

class BaseScaffold extends StatelessWidget {
  final Widget child;
  final String appBartTitle;
  final int initialIndex;

  const BaseScaffold({
    super.key,
    required this.child,
    required this.appBartTitle,
    this.initialIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:  CustomBottomBar(currentIndex: initialIndex),
      body: Column(
        children: [
          CustomAppBar(appBarTitle: appBartTitle),
          Expanded(child: child),
        ],
      ),
    );
  }
}
