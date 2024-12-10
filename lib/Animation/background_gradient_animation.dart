import 'package:flutter/material.dart';

class BackgroundGradientAnimation extends StatefulWidget {
  final Widget child;

  const BackgroundGradientAnimation({super.key, required this.child});

  @override
  State<BackgroundGradientAnimation> createState() =>
      _BackgroundGradientAnimationState();
}

class _BackgroundGradientAnimationState
    extends State<BackgroundGradientAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    _animation = Tween<Alignment>(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: _animation.value,
              end: Alignment.centerRight,
              colors: const [
                Color.fromARGB(255, 236, 236, 230),
                Color.fromARGB(255, 180, 182, 179),
              ],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}
