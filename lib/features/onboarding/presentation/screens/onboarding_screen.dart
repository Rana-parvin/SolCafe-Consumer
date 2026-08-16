import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:solcafe/features/auth/presentation/screens/login_screen.dart';
import 'package:solcafe/features/onboarding/presentation/widgets/onboarding_slide_1.dart';
import 'package:solcafe/features/onboarding/presentation/widgets/onboarding_slide_2.dart';
import 'package:solcafe/features/onboarding/presentation/widgets/onboarding_slide_3.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController();
  bool onlastpage = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              onPageChanged: (index) {
                setState(() {
                  onlastpage = (index == 2);
                });
              },
              controller: controller,
              children: const [
                OnboardingSlide1(),
                OnboardingSlide2(),
                OnboardingSlide3(),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 30, left: 30, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          controller.previousPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                          );
                        },
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                      SmoothPageIndicator(
                        controller: controller,
                        count: 3,
                        effect: const WormEffect(
                          dotColor: Color.fromARGB(255, 224, 219, 217),
                          activeDotColor: Color.fromARGB(255, 67, 19, 1),
                        ),
                      ),
                      onlastpage
                          ? Padding(
                              padding: const EdgeInsets.only(left: 50),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                                  );
                                },
                                child: const Text(
                                  "Get Started",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 106, 2, 2),
                                  ),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                controller.nextPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeIn,
                                );
                              },
                              child: const Text(
                                "Next",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 106, 2, 2),
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Backward compatibility alias
typedef Dopemain = OnboardingScreen;
