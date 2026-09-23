import 'package:flutter_test/flutter_test.dart';
import 'package:solcafe/features/payment/data/models/payment_model.dart';
import 'package:solcafe/features/payment/domain/entities/payment_entity.dart';

void main() {
  final tTimestamp = DateTime(2026, 8, 16, 12, 0, 0);
  final tPayment = PaymentModel(
    id: 'pay_123',
    orderId: 'ord_456',
    userId: 'usr_789',
    itemId: 'itm_000',
    paymentMethod: 'Credit Card',
    amount: 350.0,
    status: 'completed',
    timestamp: tTimestamp,
  );

  group('PaymentModel & PaymentEntity Tests', () {
    test('should be a subclass of PaymentEntity', () {
      expect(tPayment, isA<PaymentEntity>());
    });

    test('toMap should return correct map payload', () {
      final map = tPayment.toMap();
      expect(map['order id'], equals('ord_456'));
      expect(map['userid'], equals('usr_789'));
      expect(map['payment method'], equals('Credit Card'));
      expect(map['total amount'], equals(350.0));
      expect(map['status'], equals('completed'));
    });
  });
}
