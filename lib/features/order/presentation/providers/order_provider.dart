import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solcafe/features/order/data/datasources/order_remote_datasource.dart';
import 'package:solcafe/features/order/data/repositories/order_repository_impl.dart';
import 'package:solcafe/features/order/domain/entities/order_entity.dart';
import 'package:solcafe/features/order/domain/repositories/order_repository.dart';
import 'package:solcafe/features/order/domain/usecases/get_order_history_usecase.dart';
import 'package:solcafe/features/order/domain/usecases/place_order_usecase.dart';

final orderRemoteDataSourceProvider = Provider<OrderRemoteDataSource>((ref) {
  return OrderRemoteDataSourceImpl();
});

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final dataSource = ref.watch(orderRemoteDataSourceProvider);
  return OrderRepositoryImpl(dataSource);
});

final placeOrderUseCaseProvider = Provider<PlaceOrderUseCase>((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return PlaceOrderUseCase(repository);
});

final getOrderHistoryUseCaseProvider = Provider<GetOrderHistoryUseCase>((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return GetOrderHistoryUseCase(repository);
});

final userOrderHistoryStreamProvider = StreamProvider.family<List<OrderEntity>, String>((ref, userId) {
  final useCase = ref.watch(getOrderHistoryUseCaseProvider);
  return useCase(userId);
});

/// Standardized payment & order placement state notifier using AsyncValue.
/// Ensures loading state, error presentation, lifecycle safety, and duplicate submission prevention.
class OrderPaymentNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() {
    return const AsyncData(null);
  }

  Future<String?> placeOrder(OrderEntity order) async {
    if (state.isLoading) return null;

    state = const AsyncLoading();
    try {
      final placeOrderUseCase = ref.read(placeOrderUseCaseProvider);
      final orderId = await placeOrderUseCase(order);
      state = const AsyncData(null);
      return orderId;
    } catch (e, st) {
      state = AsyncError(e, st);
      return null;
    }
  }
}

final orderPaymentNotifierProvider =
    NotifierProvider<OrderPaymentNotifier, AsyncValue<void>>(OrderPaymentNotifier.new);
