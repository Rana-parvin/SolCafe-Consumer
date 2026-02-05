import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void>UPIpayment({required String itemId,
  required String size,
  required int quantity,
  required String totalPrice,
  required String image,
  required String itemname})async{

     try {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    final firestore = FirebaseFirestore.instance;

    // Create order document
    DocumentReference orderRef =
        firestore.collection("making_orders").doc();

    await orderRef.set({
      "userid": uid,   
      "item id":itemId,  
      "size":size,    
      "total price": totalPrice,   
      "status": "pending",   
      "date": DateTime.now(),  
    });

    await firestore.collection("ordered items").doc().set({
      "order id": orderRef.id,  
      "item id": itemId,  
      "size": size,  
      "quantity": quantity,  
      "totalprice": totalPrice, 
      "ordered date": DateTime.now(),
      "userid": uid, 
      "itemname":itemname,
      "image":image ,
      "payment method":"UPI payment"
         
    });

    await firestore.collection("payments").doc().set({
      "order id": orderRef.id,  
      "item id": itemId,  
      "size": size,  
      "quantity": quantity,  
      "total amount": totalPrice, 
      "ordered date": DateTime.now(),
      "userid": uid,  
         
    });

    print("Order created successfully!");
  } catch (e) {
    print("Error creating order: $e");
  }
}