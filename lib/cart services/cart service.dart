import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solcafe/models/cart%20item%20model.dart';

enum addtocartresult { addednew, updatedquantity }

class Cartservice {
  final cartref = FirebaseFirestore.instance.collection("cart items");
  Future<addtocartresult> addToCart(Cartitemmodel item) async {
    final cartRef = FirebaseFirestore.instance.collection('cart items');

    final query = await cartRef
        .where('userId', isEqualTo: item.userid)
        .where('itemId', isEqualTo: item.itemid)
        .where('size', isEqualTo: item.size)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      await query.docs.first.reference.update({
        'quantity': FieldValue.increment(item.quantity),
      });
      return addtocartresult.updatedquantity;
    } else {
      await cartRef.add(item.tojson());
      return addtocartresult.addednew;
    }
  }
}
