import 'package:solcafe/features/payment/domain/entities/payment_entity.dart';
import 'package:solcafe/features/payment/domain/repositories/payment_repository.dart';

class ProcessPaymentUseCase {
  final PaymentRepository repository;

  ProcessPaymentUseCase(this.repository);

  Future<void> call(PaymentEntity payment) {
    return repository.recordPayment(payment);
  }
}
