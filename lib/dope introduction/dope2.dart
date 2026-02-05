import 'package:flutter/material.dart';

class Dope2 extends StatefulWidget {
  const Dope2({super.key});

  @override
  State<Dope2> createState() => _Dope2State();
}

class _Dope2State extends State<Dope2> {
  @override
  Widget build(BuildContext context) {
    return   Stack(
      children: [
        //bg image
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/coffee bg1.jpg"),
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
                 child: Text("Everything Instantly",style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(255, 247, 189, 164),fontSize: 30),),
               ),
               Padding(
                 padding: const EdgeInsets.only(right: 10,left: 10),
                 child: Divider(thickness: 1.3,color: const Color.fromARGB(255, 231, 204, 204),),
               ),
               //subtitle
               Padding(
                 padding: const EdgeInsets.only(top: 3,right: 10,left: 13),
                 child: Text(
                 "Fast,Secure And Always In Sync-From Your Phone To The Cloud",
                   style: TextStyle(color: const Color.fromARGB(255, 255, 166, 125),fontSize: 18),
                 ),
               ),
             ],
           ),
         ),]);
      
    
  }
}