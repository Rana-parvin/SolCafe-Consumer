import 'package:flutter_test/flutter_test.dart';
import 'package:solcafe/features/order/data/models/order_model.dart';
import 'package:solcafe/features/order/domain/entities/order_entity.dart';

void main() {
  final tOrderDate = DateTime(2026, 8, 16, 12, 0, 0);
  final tOrder = OrderModel(
    id: 'ord_123',
    userId: 'usr_1',
    itemId: 'itm_1',
    itemName: 'Latte',
    image: 'assets/images/latte.jpg',
    size: 'L',
    quantity: 2,
    totalPrice: 380.0,
    status: 'pending',
    paymentMethod: 'Cash on delivery',
    orderDate: tOrderDate,
  );

  group('OrderModel & OrderEntity Tests', () {
    test('should be a subclass of OrderEntity', () {
      expect(tOrder, isA<OrderEntity>());
    });

    test('toOrderMap should return correct payload map', () {
      final map = tOrder.toOrderMap();
      expect(map['userid'], equals('usr_1'));
      expect(map['item id'], equals('itm_1'));
      expect(map['total price'], equals('380.00'));
      expect(map['status'], equals('pending'));
    });

    test('toOrderedItemMap should include orderId and payment method', () {
      final map = tOrder.toOrderedItemMap('ord_123');
      expect(map['order id'], equals('ord_123'));
      expect(map['itemname'], equals('Latte'));
      expect(map['payment method'], equals('Cash on delivery'));
      expect(map['quantity'], equals(2));
    });
  });
}
