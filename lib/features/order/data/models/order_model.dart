import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solcafe/features/order/domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.userId,
    required super.itemId,
    required super.itemName,
    required super.image,
    required super.size,
    required super.quantity,
    required super.totalPrice,
    required super.status,
    required super.paymentMethod,
    required super.orderDate,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return OrderModel(
      id: doc.id,
      userId: data['userid'] ?? data['userId'] ?? '',
      itemId: data['item id'] ?? data['itemId'] ?? '',
      itemName: data['itemname'] ?? data['name'] ?? 'Item',
      image: data['image'] ?? 'assets/images/coffee.jpg',
      size: data['size'] ?? 'M',
      quantity: data['quantity'] is int ? data['quantity'] as int : int.tryParse(data['quantity']?.toString() ?? '1') ?? 1,
      totalPrice: double.tryParse(data['totalprice']?.toString() ?? data['total price']?.toString() ?? '0') ?? 0.0,
      status: data['status'] ?? 'pending',
      paymentMethod: data['payment method'] ?? data['paymentMethod'] ?? 'Standard',
      orderDate: (data['ordered date'] as Timestamp?)?.toDate() ?? (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toOrderMap() {
    return {
      'userid': userId,
      'item id': itemId,
      'size': size,
      'total price': totalPrice.toStringAsFixed(2),
      'status': status,
      'date': Timestamp.fromDate(orderDate),
    };
  }

  Map<String, dynamic> toOrderedItemMap(String orderId) {
    return {
      'order id': orderId,
      'item id': itemId,
      'size': size,
      'quantity': quantity,
      'totalprice': totalPrice.toStringAsFixed(2),
      'ordered date': Timestamp.fromDate(orderDate),
      'userid': userId,
      'itemname': itemName,
      'image': image,
      'payment method': paymentMethod,
    };
  }

  Map<String, dynamic> toPaymentMap(String orderId) {
    return {
      'order id': orderId,
      'item id': itemId,
      'size': size,
      'quantity': quantity,
      'total amount': totalPrice.toStringAsFixed(2),
      'ordered date': Timestamp.fromDate(orderDate),
      'userid': userId,
    };
  }
}
