import 'package:flutter/material.dart';

class OnboardingSlide2 extends StatelessWidget {
  const OnboardingSlide2({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/coffee bg1.jpg"),
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
                  "Everything Instantly",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 247, 189, 164),
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
                  "Fast,Secure And Always In Sync-From Your Phone To The Cloud",
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
typedef Dope2 = OnboardingSlide2;
