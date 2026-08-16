import 'package:solcafe/features/payment/domain/entities/payment_entity.dart';

abstract class PaymentRepository {
  Future<void> recordPayment(PaymentEntity payment);
  Stream<List<PaymentEntity>> getPaymentHistory(String userId);
}
