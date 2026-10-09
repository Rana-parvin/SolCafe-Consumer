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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Image.asset(
      "assets/images/cup icon.png",
      height: size,
      width: size,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Container(
        width: size,
        height: size,
        padding: EdgeInsets.all(size * 0.12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF32231A) : const Color(0xFFFFF7ED),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.coffee_rounded,
          size: size * 0.7,
          color: const Color(0xFFE5B25D),
        ),
      ),
    );
  }
}
