import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:solcafe/core/theme/solcafe_colors.dart';

/// Platform-specific authentication background layer.
/// - Web: Dedicated surface Primary background.
/// - Mobile (Android/iOS): Dope Intro background image with darkening overlay & backdrop blur.
class AuthBackground extends StatelessWidget {
  const AuthBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.solcafeColors;

    if (kIsWeb) {
      return Container(
        color: colors.surfacePrimary,
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Mobile Dope Intro background image
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background image.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // 2. Dope Intro gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.65),
                Colors.black.withValues(alpha: 0.2),
                Colors.black.withValues(alpha: 0.7),
              ],
            ),
          ),
        ),
        // 3. Darkening overlay for contrast
        Container(
          color: Colors.black.withValues(alpha: 0.35),
        ),
        // 4. Subtle backdrop blur for atmospheric depth
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(color: Colors.transparent),
        ),
      ],
    );
  }
}
