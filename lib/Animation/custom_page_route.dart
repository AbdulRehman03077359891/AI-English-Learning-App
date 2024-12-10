import 'package:flutter/material.dart';

class CustomPageRoute {
  static PageRouteBuilder slideTransition({
    required Widget page,
    Offset begin = const Offset(1.0, 0.0), // Default: slide from right
    Offset end = Offset.zero,
    Curve curve = Curves.ease,
    Duration duration = const Duration(milliseconds: 500),
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: duration,
    );
  }
}
