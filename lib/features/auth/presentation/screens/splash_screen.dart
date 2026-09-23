import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:solcafe/core/presentation/widgets/responsive_layout.dart';
import 'package:solcafe/core/theme/solcafe_colors.dart';
import 'package:solcafe/features/auth/presentation/screens/auth_wrapper.dart';

class UserSplash extends StatefulWidget {
  const UserSplash({super.key});

  @override
  State<UserSplash> createState() => _UserSplashState();
}

class _UserSplashState extends State<UserSplash>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _lottieController;
  late final Animation<double> fadeAnimation;
  late final Animation<Offset> slideAnimation;
  
  bool _hasNavigated = false;
  Timer? _fallbackTimer;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeIn),
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOut),
    );

    _entranceController.forward();

    _lottieController = AnimationController(vsync: this);
    _lottieController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateToNext();
      }
    });

    // Sensible fallback timer to prevent splash from waiting indefinitely (10s max)
    _fallbackTimer = Timer(const Duration(seconds: 10), () {
      if (mounted && !_hasNavigated) {
        _navigateToNext();
      }
    });
  }

  void _navigateToNext() {
    if (!mounted || _hasNavigated) return;
    _hasNavigated = true;
    _fallbackTimer?.cancel();

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (_, __, ___) => const AuthWrapper(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _fallbackTimer?.cancel();
    _entranceController.dispose();
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.solcafeColors;
    final splashBgColor = colors.surfacePrimary;
    final isLandscape = SolCafeBreakpoints.isLandscape(context);
    final animHeight = isLandscape ? 150.0 : 250.0;

    return Scaffold(
      backgroundColor: splashBgColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: splashBgColor,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FadeTransition(
                    opacity: fadeAnimation,
                    child: SizedBox(
                      height: animHeight,
                      width: animHeight,
                      child: Lottie.asset(
                        'assets/anims/Coffee love.json',
                        controller: _lottieController,
                        onLoaded: (composition) {
                          _lottieController.duration = composition.duration;
                          if (!_lottieController.isAnimating &&
                              !_lottieController.isCompleted &&
                              !_hasNavigated) {
                            _lottieController.forward();
                          }
                        },
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
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
          ),
        ),
      ),
    );
  }
}


