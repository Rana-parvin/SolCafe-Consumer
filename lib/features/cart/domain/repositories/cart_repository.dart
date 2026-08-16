import 'package:solcafe/features/cart/domain/entities/cart_item_entity.dart';

abstract class CartRepository {
  Stream<List<CartItemEntity>> getCartItems(String userId);
  Future<void> addToCart(CartItemEntity item);
  Future<void> updateQuantity(String cartItemId, int quantity);
  Future<void> removeFromCart(String cartItemId);
  Future<void> clearCart(String userId);
}
