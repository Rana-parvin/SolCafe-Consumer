import 'package:flutter/material.dart';

class OnboardingSlide1 extends StatelessWidget {
  const OnboardingSlide1({super.key});

  @override
  Widget build(BuildContext context) {
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
        const Padding(
          padding: EdgeInsets.all(60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15, bottom: 0, left: 5),
                child: Text(
                  "Wake Up With The Perfect Brew",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 122, 97, 86),
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
                  "Explore Rich Flavors And Hand-crafted Coffee Made Just For You",
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 166, 125),
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
typedef Dope1 = OnboardingSlide1;
