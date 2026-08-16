import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';

import 'package:solcafe/user%20authentication/auth%20wrapper.dart';

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

  @override
  void initState() {
    super.initState();

    // Animation controller
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

    // Navigate after delay
    Timer(const Duration(seconds: 7), () {
      Navigator.pushReplacement(
  context,
  PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 1250),
    pageBuilder: (_, __, ___) => const AuthWrapper(),
    transitionsBuilder: (_, animation, __, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  ),
);
 // change route
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
             Color.fromARGB(255, 47, 24, 16),
             Color.fromARGB(255, 153, 112, 97),
             Color.fromARGB(255, 183, 141, 126),
             Color.fromARGB(255, 181, 155, 147),
      
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
                  // Replace with your logo
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
                    fontSize: 25,
                    color: const Color.fromARGB(255, 24, 10, 10),
                    fontWeight: FontWeight.w800,
                    letterSpacing: 4,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
      
            FadeTransition(
              opacity: fadeAnimation,
              child: const Text(
                "☕ Brewed with Love ",
                style: TextStyle(fontSize: 16,letterSpacing: 2, color: Color.fromARGB(179, 44, 19, 19)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
