import 'package:solcafe/features/cart/data/datasources/cart_remote_datasource.dart';
import 'package:solcafe/features/cart/data/models/cart_item_model.dart';
import 'package:solcafe/features/cart/domain/entities/cart_item_entity.dart';
import 'package:solcafe/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl(this.remoteDataSource);

  @override
  Stream<List<CartItemEntity>> getCartItems(String userId) {
    return remoteDataSource.getCartItems(userId);
  }

  @override
  Future<void> addToCart(CartItemEntity item) {
    final model = CartItemModel(
      id: item.id,
      userId: item.userId,
      itemId: item.itemId,
      name: item.name,
      price: item.price,
      image: item.image,
      quantity: item.quantity,
      size: item.size,
    );
    return remoteDataSource.addToCart(model);
  }

  @override
  Future<void> updateQuantity(String cartItemId, int quantity) {
    return remoteDataSource.updateQuantity(cartItemId, quantity);
  }

  @override
  Future<void> removeFromCart(String cartItemId) {
    return remoteDataSource.removeFromCart(cartItemId);
  }

  @override
  Future<void> clearCart(String userId) {
    return remoteDataSource.clearCart(userId);
  }
}
