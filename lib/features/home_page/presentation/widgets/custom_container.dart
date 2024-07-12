import 'package:flutter/widgets.dart';

class CustomContainer extends StatelessWidget {
  final double width;
  final double height;
  final BoxDecoration? decoration;
  final Widget? child;
  const CustomContainer(
      {super.key,
      required this.width,
      required this.height,
      this.decoration,
      this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: decoration,
      child: child,
    );
  }
}
