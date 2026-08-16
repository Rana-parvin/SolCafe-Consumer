import 'package:flutter_test/flutter_test.dart';
import 'package:solcafe/features/cart/data/models/cart_item_model.dart';
import 'package:solcafe/features/cart/domain/entities/cart_item_entity.dart';

void main() {
  const tCartItem = CartItemModel(
    id: 'cart_1',
    userId: 'user_123',
    itemId: 'item_456',
    name: 'Cappuccino',
    price: 220.0,
    image: 'assets/images/cappuccino.jpg',
    quantity: 2,
    size: 'M',
  );

  group('CartItemModel & CartItemEntity Tests', () {
    test('should be a subclass of CartItemEntity', () {
      expect(tCartItem, isA<CartItemEntity>());
    });

    test('totalPrice should calculate price * quantity accurately', () {
      expect(tCartItem.totalPrice, equals(440.0));
    });

    test('toMap should return map with correct string userId and itemId', () {
      final map = tCartItem.toMap();
      expect(map['userId'], equals('user_123'));
      expect(map['itemId'], equals('item_456'));
      expect(map['name'], equals('Cappuccino'));
      expect(map['price'], equals(220.0));
      expect(map['quantity'], equals(2));
      expect(map['size'], equals('M'));
    });
  });
}
