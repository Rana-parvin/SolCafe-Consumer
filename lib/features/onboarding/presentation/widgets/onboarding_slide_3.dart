import 'package:flutter/material.dart';

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
        const Padding(
          padding: EdgeInsets.all(60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15, bottom: 0, left: 5),
                child: Text(
                  "Designed For You",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 241, 172, 140),
                    fontSize: 30,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 10, left: 10),
                child: Divider(
                  thickness: 1.3,
                  color: Color.fromARGB(255, 231, 204, 204),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 3, right: 10, left: 13),
                child: Text(
                  "Your Preferences,Your Style.Let's Make It Yours",
                  style: TextStyle(
                    color: Color.fromARGB(255, 70, 40, 26),
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Backward compatibility alias
typedef Dope3 = OnboardingSlide3;
