import 'package:solcafe/features/payment/data/datasources/payment_remote_datasource.dart';
import 'package:solcafe/features/payment/data/models/payment_model.dart';
import 'package:solcafe/features/payment/domain/entities/payment_entity.dart';
import 'package:solcafe/features/payment/domain/repositories/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> recordPayment(PaymentEntity payment) {
    final model = PaymentModel(
      id: payment.id,
      orderId: payment.orderId,
      userId: payment.userId,
      itemId: payment.itemId,
      paymentMethod: payment.paymentMethod,
      amount: payment.amount,
      status: payment.status,
      timestamp: payment.timestamp,
    );
    return remoteDataSource.recordPayment(model);
  }

  @override
  Stream<List<PaymentEntity>> getPaymentHistory(String userId) {
    return remoteDataSource.getPaymentHistory(userId);
  }
}
