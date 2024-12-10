import 'package:flutter/material.dart';

class E1Button extends StatelessWidget {
  final Color backColor;
  final Color textColor;
  final String text;
  final double size;
  final VoidCallback? onPressed;
  final Color? shadowColor;
  final double elevation;

  const E1Button({
    super.key,
    required this.backColor,
    required this.text,
    required this.textColor,
    this.onPressed,
    this.shadowColor,
    this.size = 16.0, // Default font size
    this.elevation = 10.0, // Default elevation
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30),
          ),
        ),
        backgroundColor: backColor,
        shadowColor: shadowColor,
        elevation: elevation,
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(right: 5),
        child: Text(
          text,
          style: TextStyle(
            color: onPressed == null? Colors.grey : textColor,
            fontSize: size,
          ),
        ),
      ),
    );
  }
}
