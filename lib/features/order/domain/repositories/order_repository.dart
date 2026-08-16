import 'package:solcafe/features/order/domain/entities/order_entity.dart';

abstract class OrderRepository {
  Future<void> placeOrder(OrderEntity order);
  Stream<List<OrderEntity>> getOrderHistory(String userId);
}
