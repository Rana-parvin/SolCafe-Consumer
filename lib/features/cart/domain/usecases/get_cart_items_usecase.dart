import 'package:solcafe/features/cart/domain/entities/cart_item_entity.dart';
import 'package:solcafe/features/cart/domain/repositories/cart_repository.dart';

class GetCartItemsUseCase {
  final CartRepository repository;

  GetCartItemsUseCase(this.repository);

  Stream<List<CartItemEntity>> call(String userId) {
    return repository.getCartItems(userId);
  }
}
