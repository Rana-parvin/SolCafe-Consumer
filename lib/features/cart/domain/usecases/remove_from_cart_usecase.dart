import 'package:solcafe/features/cart/domain/repositories/cart_repository.dart';

class RemoveFromCartUseCase {
  final CartRepository repository;

  RemoveFromCartUseCase(this.repository);

  Future<void> call(String cartItemId) {
    return repository.removeFromCart(cartItemId);
  }
}
