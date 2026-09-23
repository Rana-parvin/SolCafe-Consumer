import 'package:solcafe/features/order/domain/entities/order_entity.dart';
import 'package:solcafe/features/order/domain/repositories/order_repository.dart';

class PlaceOrderUseCase {
  final OrderRepository repository;

  PlaceOrderUseCase(this.repository);

  Future<void> call(OrderEntity order) {
    return repository.placeOrder(order);
  }
}
