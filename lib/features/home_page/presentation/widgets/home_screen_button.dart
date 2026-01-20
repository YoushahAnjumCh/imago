import 'package:flutter/material.dart';

class HomeScreenButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final Widget? child;
  final String text;
  const HomeScreenButton(
      {super.key,
      required this.onPressed,
      this.child,
      required this.backgroundColor,
      required this.foregroundColor,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        elevation: 10,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: onPressed,
      child: child ?? Text(text),
    );
  }
}
