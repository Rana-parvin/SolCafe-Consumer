import 'package:flutter/material.dart';

class Dope3 extends StatefulWidget {
  const Dope3({super.key});

  @override
  State<Dope3> createState() => _Dope3State();
}

class _Dope3State extends State<Dope3> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //bg image
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background image.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),

        //content
       
            Padding(
              padding: const EdgeInsets.all(60.0),
              child: Column(mainAxisAlignment: MainAxisAlignment.start,
                         children: [
               //title
               Padding(
                 padding: const EdgeInsets.only(top: 15,bottom: 0,left: 5),
                 child: Text("Designed For You",style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(255, 241, 172, 140),fontSize: 30),),
               ),
               Padding(
                 padding: const EdgeInsets.only(right: 10,left: 10),
                 child: Divider(thickness: 1.3,color: const Color.fromARGB(255, 231, 204, 204),),
               ),
               //subtitle
               Padding(
                 padding: const EdgeInsets.only(top: 3,right: 10,left: 13),
                 child: Text(
                   "Your Preferences,Your Style.Let's Make It Yours",
                   style: TextStyle(color: const Color.fromARGB(255, 70, 40, 26),fontSize: 18),
                 ),
               ),
                         ],
                       ),
            ),]);
      
    
  }
}