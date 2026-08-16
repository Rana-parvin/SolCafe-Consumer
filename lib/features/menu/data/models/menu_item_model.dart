import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solcafe/features/menu/domain/entities/menu_item_entity.dart';

class MenuItemModel extends MenuItemEntity {
  const MenuItemModel({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.image,
    required super.category,
    super.sizes,
  });

  factory MenuItemModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return MenuItemModel(
      id: doc.id,
      title: data['title'] ?? data['name'] ?? '',
      description: data['description'] ?? data['details'] ?? '',
      price: data['price']?.toString() ?? '0',
      image: data['image'] ?? data['imagePath'] ?? 'assets/images/coffee.jpg',
      category: data['category'] ?? '',
      sizes: data['sizes'] != null
          ? List<String>.from(data['sizes'])
          : const ['S', 'M', 'L'],
    );
  }

  factory MenuItemModel.fromMap(Map<String, dynamic> data, {String id = ''}) {
    return MenuItemModel(
      id: id.isNotEmpty ? id : (data['id'] ?? ''),
      title: data['title'] ?? data['name'] ?? '',
      description: data['description'] ?? data['details'] ?? '',
      price: data['price']?.toString() ?? '0',
      image: data['image'] ?? data['imagePath'] ?? 'assets/images/coffee.jpg',
      category: data['category'] ?? '',
      sizes: data['sizes'] != null
          ? List<String>.from(data['sizes'])
          : const ['S', 'M', 'L'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'image': image,
      'category': category,
      'sizes': sizes,
    };
  }
}
