import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solcafe/features/cart/data/datasources/cart_remote_datasource.dart';
import 'package:solcafe/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:solcafe/features/cart/domain/entities/cart_item_entity.dart';
import 'package:solcafe/features/cart/domain/repositories/cart_repository.dart';
import 'package:solcafe/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:solcafe/features/cart/domain/usecases/get_cart_items_usecase.dart';
import 'package:solcafe/features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'package:solcafe/features/cart/domain/usecases/update_cart_quantity_usecase.dart';

final cartRemoteDataSourceProvider = Provider<CartRemoteDataSource>((ref) {
  return CartRemoteDataSourceImpl();
});

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  final dataSource = ref.watch(cartRemoteDataSourceProvider);
  return CartRepositoryImpl(dataSource);
});

final getCartItemsUseCaseProvider = Provider<GetCartItemsUseCase>((ref) {
  final repository = ref.watch(cartRepositoryProvider);
  return GetCartItemsUseCase(repository);
});

final addToCartUseCaseProvider = Provider<AddToCartUseCase>((ref) {
  final repository = ref.watch(cartRepositoryProvider);
  return AddToCartUseCase(repository);
});

final updateCartQuantityUseCaseProvider = Provider<UpdateCartQuantityUseCase>((ref) {
  final repository = ref.watch(cartRepositoryProvider);
  return UpdateCartQuantityUseCase(repository);
});

final removeFromCartUseCaseProvider = Provider<RemoveFromCartUseCase>((ref) {
  final repository = ref.watch(cartRepositoryProvider);
  return RemoveFromCartUseCase(repository);
});

final userCartStreamProvider = StreamProvider.family<List<CartItemEntity>, String>((ref, userId) {
  final useCase = ref.watch(getCartItemsUseCaseProvider);
  return useCase(userId);
});
