import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solcafe/core/presentation/widgets/responsive_layout.dart';

class OnboardingSlide1 extends StatelessWidget {
  const OnboardingSlide1({super.key});

  @override
  Widget build(BuildContext context) {
    final titleFontSize = SolCafeBreakpoints.getResponsiveValue<double>(
      context,
      small: 26,
      standard: 32,
      tablet: 40,
    );
    final bodyFontSize = SolCafeBreakpoints.getResponsiveValue<double>(
      context,
      small: 14,
      standard: 16,
      tablet: 18,
    );

    return Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/black coffee bg.jpg"),
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
          child: Align(
            alignment: Alignment.topLeft,
            child: SingleChildScrollView(
              child: ConstrainedCenterContainer(
                maxWidth: 600,
                padding: EdgeInsets.symmetric(
                  horizontal: SolCafeBreakpoints.isSmallPhone(context) ? 20.0 : 32.0,
                  vertical: SolCafeBreakpoints.isLandscape(context) ? 16.0 : 40.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Wake Up With The Perfect Brew",
                      style: GoogleFonts.readexPro(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: titleFontSize,
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
                      "Explore rich flavors and hand-crafted coffee made just for you.",
                      style: GoogleFonts.openSans(
                        color: const Color(0xFFF5E1C0),
                        fontSize: bodyFontSize,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

typedef Dope1 = OnboardingSlide1;
