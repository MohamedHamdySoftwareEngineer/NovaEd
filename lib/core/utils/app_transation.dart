import 'package:flutter/material.dart';


/// A PageTransitionsBuilder that fades the new page in.
class FadeTransitionsBuilder extends PageTransitionsBuilder {
  const FadeTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // You could wrap this in a SlideTransition or ScaleTransition instead.
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
