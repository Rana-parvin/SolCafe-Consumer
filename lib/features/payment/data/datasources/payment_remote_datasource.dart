import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solcafe/features/payment/data/models/payment_model.dart';

abstract class PaymentRemoteDataSource {
  Future<void> recordPayment(PaymentModel payment);
  Stream<List<PaymentModel>> getPaymentHistory(String userId);
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> recordPayment(PaymentModel payment) async {
    await _firestore.collection('payments').add(payment.toMap());
  }

  @override
  Stream<List<PaymentModel>> getPaymentHistory(String userId) {
    return _firestore
        .collection('payments')
        .where('userid', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => PaymentModel.fromFirestore(doc)).toList());
  }
}
