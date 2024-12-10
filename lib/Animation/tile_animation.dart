import 'package:flutter/material.dart';

class SlidingTileAnimation extends StatelessWidget {
  final int index;
  final Widget child;

  const SlidingTileAnimation({
    super.key,
    required this.index,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<Offset>(
        begin: const Offset(-1, 0), // Start off-screen to the left
        end: Offset.zero, // Animate to its position
      ),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      builder: (context, Offset offset, child) {
        return Transform.translate(
          offset: Offset(offset.dx * MediaQuery.of(context).size.width, 0),
          child: child,
        );
      },
      child: child,
    );
  }
}
