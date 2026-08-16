import 'package:solcafe/features/cart/domain/repositories/cart_repository.dart';

class UpdateCartQuantityUseCase {
  final CartRepository repository;

  UpdateCartQuantityUseCase(this.repository);

  Future<void> call(String cartItemId, int quantity) {
    if (quantity <= 0) {
      return repository.removeFromCart(cartItemId);
    }
    return repository.updateQuantity(cartItemId, quantity);
  }
}
