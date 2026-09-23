import 'package:flutter/material.dart';

/// Reusable brand logo widget for Auth screens (Login & Sign Up)
class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isShortScreen = screenHeight < 500;
    final iconSize = isShortScreen ? 110.0 : 165.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          "assets/images/cup icon.png",
          height: iconSize,
          width: iconSize,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

/// Reusable brand logo widget for the Navigation Drawer
class DrawerLogo extends StatelessWidget {
  final double size;

  const DrawerLogo({
    super.key,
    this.size = 54.0,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/images/cup icon.png",
      height: size,
      width: size,
      fit: BoxFit.contain,
    );
  }
}
