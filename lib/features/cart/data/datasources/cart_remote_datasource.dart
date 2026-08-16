import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solcafe/features/cart/data/models/cart_item_model.dart';

abstract class CartRemoteDataSource {
  Stream<List<CartItemModel>> getCartItems(String userId);
  Future<void> addToCart(CartItemModel item);
  Future<void> updateQuantity(String cartItemId, int quantity);
  Future<void> removeFromCart(String cartItemId);
  Future<void> clearCart(String userId);
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<CartItemModel>> getCartItems(String userId) {
    // Query supports both String userId and DocumentReference userId for backward compatibility
    final userRef = _firestore.collection('users').doc(userId);

    return _firestore
        .collection('cart items')
        .where(Filter.or(
          Filter('userId', isEqualTo: userId),
          Filter('userId', isEqualTo: userRef),
        ))
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CartItemModel.fromFirestore(doc))
            .toList());
  }

  @override
  Future<void> addToCart(CartItemModel item) async {
    await _firestore.collection('cart items').add(item.toMap());
  }

  @override
  Future<void> updateQuantity(String cartItemId, int quantity) async {
    await _firestore
        .collection('cart items')
        .doc(cartItemId)
        .update({'quantity': quantity});
  }

  @override
  Future<void> removeFromCart(String cartItemId) async {
    await _firestore.collection('cart items').doc(cartItemId).delete();
  }

  @override
  Future<void> clearCart(String userId) async {
    final snapshot = await _firestore
        .collection('cart items')
        .where('userId', isEqualTo: userId)
        .get();

    final batch = _firestore.batch();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
