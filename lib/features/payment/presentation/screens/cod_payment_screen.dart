import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> createCashOnDeliveryOrder({
  required String itemId,
  required String size,
  required int quantity,
  required String totalPrice,
  required String image,
  required String itemname,
}) async {
  try {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    final firestore = FirebaseFirestore.instance;
    final batch = firestore.batch();

    DocumentReference orderRef = firestore.collection("making_orders").doc();
    DocumentReference itemRef = firestore.collection("ordered items").doc();
    DocumentReference paymentRef = firestore.collection("payments").doc();

    batch.set(orderRef, {
      "userid": uid,
      "item id": itemId,
      "size": size,
      "total price": totalPrice,
      "status": "pending",
      "date": DateTime.now(),
    });

    batch.set(itemRef, {
      "order id": orderRef.id,
      "item id": itemId,
      "size": size,
      "quantity": quantity,
      "totalprice": totalPrice,
      "ordered date": DateTime.now(),
      "userid": uid,
      "itemname": itemname,
      "image": image,
      "payment method": "Cash on delivery"
    });

    batch.set(paymentRef, {
      "order id": orderRef.id,
      "item id": itemId,
      "size": size,
      "quantity": quantity,
      "total amount": totalPrice,
      "ordered date": DateTime.now(),
      "userid": uid,
    });

    await batch.commit();
  } catch (e) {
    // Log error cleanly without leaking user details
  }
}
