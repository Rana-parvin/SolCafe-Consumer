import 'package:solcafe/features/order/domain/entities/order_entity.dart';
import 'package:solcafe/features/order/domain/repositories/order_repository.dart';

class GetOrderHistoryUseCase {
  final OrderRepository repository;

  GetOrderHistoryUseCase(this.repository);

  Stream<List<OrderEntity>> call(String userId) {
    return repository.getOrderHistory(userId);
  }
}
