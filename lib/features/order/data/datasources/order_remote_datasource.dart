import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solcafe/features/order/data/models/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<String> placeOrder(OrderModel order);
  Stream<List<OrderModel>> getOrderHistory(String userId);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<String> placeOrder(OrderModel order) async {
    final batch = _firestore.batch();

    final orderRef = _firestore.collection("making_orders").doc();
    final itemRef = _firestore.collection("ordered items").doc();
    final paymentRef = _firestore.collection("payments").doc();

    batch.set(orderRef, order.toOrderMap());
    batch.set(itemRef, order.toOrderedItemMap(orderRef.id));
    batch.set(paymentRef, order.toPaymentMap(orderRef.id));

    await batch.commit();
    return orderRef.id;
  }

  @override
  Stream<List<OrderModel>> getOrderHistory(String userId) {
    return _firestore
        .collection("ordered items")
        .where("userid", isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList());
  }
}
