import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solcafe/features/cart/domain/entities/cart_item_entity.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.id,
    required super.userId,
    required super.itemId,
    required super.name,
    required super.price,
    required super.image,
    required super.quantity,
    required super.size,
  });

  factory CartItemModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    
    // Safely parse userId string from DocumentReference or String
    String rawUserId = '';
    if (data['userId'] is DocumentReference) {
      rawUserId = (data['userId'] as DocumentReference).id;
    } else {
      rawUserId = data['userId']?.toString() ?? '';
    }

    // Safely parse itemId string from DocumentReference or String
    String rawItemId = '';
    if (data['itemId'] is DocumentReference) {
      rawItemId = (data['itemId'] as DocumentReference).id;
    } else {
      rawItemId = data['itemId']?.toString() ?? '';
    }

    return CartItemModel(
      id: doc.id,
      userId: rawUserId,
      itemId: rawItemId,
      name: data['name'] ?? data['title'] ?? 'Item',
      price: double.tryParse(data['price']?.toString() ?? '0') ?? 0.0,
      image: data['image'] ?? 'assets/images/coffee.jpg',
      quantity: data['quantity'] is int ? data['quantity'] as int : int.tryParse(data['quantity']?.toString() ?? '1') ?? 1,
      size: data['size'] ?? 'M',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'itemId': itemId,
      'name': name,
      'price': price,
      'image': image,
      'quantity': quantity,
      'size': size,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
