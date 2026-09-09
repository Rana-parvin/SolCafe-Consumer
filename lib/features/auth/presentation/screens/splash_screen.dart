import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:solcafe/core/theme/solcafe_colors.dart';
import 'package:solcafe/features/auth/presentation/screens/auth_wrapper.dart';

class UserSplash extends StatefulWidget {
  const UserSplash({super.key});

  @override
  State<UserSplash> createState() => _UserSplashState();
}

class _UserSplashState extends State<UserSplash>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    _timer = Timer(const Duration(milliseconds: 2500), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 800),
            pageBuilder: (_, __, ___) => const AuthWrapper(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.solcafeColors;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colors.surfaceSecondary,
              colors.surfacePrimary,
              colors.cardBackground,
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: fadeAnimation,
              child: Column(
                children: [
                  Lottie.asset("assets/anims/Coffee love.json", height: 200),
                  const SizedBox(height: 15),
                ],
              ),
            ),
            SlideTransition(
              position: slideAnimation,
              child: FadeTransition(
                opacity: fadeAnimation,
                child: Text(
                  "SolCafe",
                  style: TextStyle(
                    fontSize: 28,
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 4,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            FadeTransition(
              opacity: fadeAnimation,
              child: Text(
                "☕ Brewed with Love",
                style: TextStyle(
                  fontSize: 16,
                  letterSpacing: 2,
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
