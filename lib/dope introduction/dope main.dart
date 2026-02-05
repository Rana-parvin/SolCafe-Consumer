import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:solcafe/user%20authentication/login.dart';
import 'package:solcafe/dope%20introduction/dope1.dart';
import 'package:solcafe/dope%20introduction/dope2.dart';
import 'package:solcafe/dope%20introduction/dope3.dart';

class Dopemain extends StatefulWidget {
  const Dopemain({super.key});

  @override
  State<Dopemain> createState() => _DopemainState();
}

class _DopemainState extends State<Dopemain> {
  PageController controller = PageController();

  //keep track of if on the last page
  bool onlastpage = false;
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
              children: [Dope1(), Dope2(), Dope3()],
            ),
        
                 ///indicator,next,done,skip
            Column(mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 30,left: 30,right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                             // for previous page
                      GestureDetector(
                              onTap: () {
                                controller.previousPage(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeIn,
                                );
                              },
                              child: Icon(Icons.arrow_back_ios,color: Colors.white,size: 25,),
                            ),
                                  //smooth page indicator
                      SmoothPageIndicator(controller: controller, count: 3,
                                effect: WormEffect(
                                  dotColor: const Color.fromARGB(255, 224, 219, 217),
                                  activeDotColor:const Color.fromARGB(255, 67, 19, 1),
                                ),
                      ),
                                 //next or done
                                 
                    onlastpage
                        ? Padding(
                          padding: const EdgeInsets.only(left: 50),
                          child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context)=>Login()),
                                );
                              },
                              child: Text("Get Started",style: TextStyle(
                                fontWeight: FontWeight.bold,fontSize: 20,
                                color:  const Color.fromARGB(255, 106, 2, 2)))
                            ),
                        )
                        : 
                  GestureDetector(
                              onTap: () {
                                controller.nextPage(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeIn,
                                );
                              },
                              child: Text("Next",style: TextStyle(color: const Color.fromARGB(255, 106, 2, 2),fontSize: 25,fontWeight: FontWeight.bold),),
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
