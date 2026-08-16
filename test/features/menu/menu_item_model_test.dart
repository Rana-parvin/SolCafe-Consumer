import 'package:flutter_test/flutter_test.dart';
import 'package:solcafe/features/menu/data/models/menu_item_model.dart';
import 'package:solcafe/features/menu/domain/entities/menu_item_entity.dart';

void main() {
  const tMenuItem = MenuItemModel(
    id: 'item_1',
    title: 'Espresso',
    description: 'Rich dark espresso coffee',
    price: '150',
    image: 'assets/images/espresso.jpg',
    category: 'Coffee',
    sizes: ['S', 'M', 'L'],
  );

  group('MenuItemModel & MenuItemEntity Tests', () {
    test('should be a subclass of MenuItemEntity', () {
      expect(tMenuItem, isA<MenuItemEntity>());
    });

    test('fromMap should return valid MenuItemModel', () {
      final map = {
        'id': 'item_1',
        'title': 'Espresso',
        'description': 'Rich dark espresso coffee',
        'price': 150,
        'image': 'assets/images/espresso.jpg',
        'category': 'Coffee',
      };
      final result = MenuItemModel.fromMap(map);
      expect(result.title, equals('Espresso'));
      expect(result.price, equals('150'));
    });

    test('toMap should return correct map representation', () {
      final map = tMenuItem.toMap();
      expect(map['id'], equals('item_1'));
      expect(map['title'], equals('Espresso'));
      expect(map['price'], equals('150'));
    });
  });
}
