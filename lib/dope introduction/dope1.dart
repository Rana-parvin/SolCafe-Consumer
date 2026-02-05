import 'package:flutter/material.dart';

class Dope1 extends StatefulWidget {
  const Dope1({super.key});

  @override
  State<Dope1> createState() => _Dope1State();
}

class _Dope1State extends State<Dope1> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children:[
         //bg image
        Container(height: double.infinity,width: double.infinity,
          
           decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/black coffee bg.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),

         Padding(
           padding: const EdgeInsets.all(60.0),
           child: Column(mainAxisAlignment: MainAxisAlignment.start,
             children: [
               //title
               Padding(
                 padding: const EdgeInsets.only(top: 15,bottom: 0,left: 5),
                 child: Text("Wake Up With The Perfect Brew",style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(255, 122, 97, 86),fontSize: 30),),
               ),
               Padding(
                 padding: const EdgeInsets.only(right: 10,left: 10),
                 child: Divider(thickness: 1.3,color: const Color.fromARGB(255, 231, 204, 204),),
               ),
               //subtitle
               Padding(
                 padding: const EdgeInsets.only(top: 3,right: 10,left: 13),
                 child: Text(
                   "Explore Rich Flavors And Hand-crafted Coffee Made Just For You",
                   style: TextStyle(color: const Color.fromARGB(255, 255, 166, 125),fontSize: 18),
                 ),
               ),
             ],
           ),
         ),
      ]);
    
  }
}
