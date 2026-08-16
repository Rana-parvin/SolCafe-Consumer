import 'package:solcafe/features/order/data/datasources/order_remote_datasource.dart';
import 'package:solcafe/features/order/data/models/order_model.dart';
import 'package:solcafe/features/order/domain/entities/order_entity.dart';
import 'package:solcafe/features/order/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> placeOrder(OrderEntity order) {
    final model = OrderModel(
      id: order.id,
      userId: order.userId,
      itemId: order.itemId,
      itemName: order.itemName,
      image: order.image,
      size: order.size,
      quantity: order.quantity,
      totalPrice: order.totalPrice,
      status: order.status,
      paymentMethod: order.paymentMethod,
      orderDate: order.orderDate,
    );
    return remoteDataSource.placeOrder(model);
  }

  @override
  Stream<List<OrderEntity>> getOrderHistory(String userId) {
    return remoteDataSource.getOrderHistory(userId);
  }
}
