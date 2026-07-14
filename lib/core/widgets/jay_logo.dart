import 'package:flutter/material.dart';

class JayLogo extends StatelessWidget {
  final double? width;
  final double? height;
  final bool showShadow;

  const JayLogo({
    super.key,
    this.width,
    this.height,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/jay_logo.png',
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }
}
