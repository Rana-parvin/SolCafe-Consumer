import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solcafe/features/payment/domain/entities/payment_entity.dart';

class PaymentModel extends PaymentEntity {
  const PaymentModel({
    required super.id,
    required super.orderId,
    required super.userId,
    required super.itemId,
    required super.paymentMethod,
    required super.amount,
    required super.status,
    required super.timestamp,
  });

  factory PaymentModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return PaymentModel(
      id: doc.id,
      orderId: data['order id'] ?? data['orderId'] ?? '',
      userId: data['userid'] ?? data['userId'] ?? '',
      itemId: data['item id'] ?? data['itemId'] ?? '',
      paymentMethod: data['payment method'] ?? data['paymentMethod'] ?? 'Standard',
      amount: double.tryParse(data['total amount']?.toString() ?? data['amount']?.toString() ?? '0') ?? 0.0,
      status: data['status'] ?? 'completed',
      timestamp: (data['ordered date'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'order id': orderId,
      'userid': userId,
      'item id': itemId,
      'payment method': paymentMethod,
      'total amount': amount,
      'status': status,
      'ordered date': Timestamp.fromDate(timestamp),
    };
  }
}
