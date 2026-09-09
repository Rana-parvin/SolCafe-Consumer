import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingSlide3 extends StatelessWidget {
  const OnboardingSlide3({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background image.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
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
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Designed For You",
                  style: GoogleFonts.readexPro(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 32,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 3,
                  width: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5B25D),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Your preferences, your style. Let's make it yours.",
                  style: GoogleFonts.openSans(
                    color: const Color(0xFFF5E1C0),
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

typedef Dope3 = OnboardingSlide3;
