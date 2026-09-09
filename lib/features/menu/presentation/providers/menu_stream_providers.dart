import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solcafe/features/menu/domain/entities/menu_item_entity.dart';
import 'package:solcafe/features/menu/presentation/providers/menu_provider.dart';

final coffeeItemsProvider = StreamProvider.autoDispose<List<MenuItemEntity>>((ref) {
  return ref.watch(getMenuItemsUseCaseProvider).call(category: 'coffee');
});

final cakeItemsProvider = StreamProvider.autoDispose<List<MenuItemEntity>>((ref) {
  return ref.watch(getMenuItemsUseCaseProvider).call(category: 'cake');
});

final otherItemsProvider = StreamProvider.autoDispose<List<MenuItemEntity>>((ref) {
  return ref.watch(getMenuItemsUseCaseProvider).call(category: 'other items');
});

// ignore: non_constant_identifier_names
final OtheritemsProvider = otherItemsProvider;

final noncoffeeProvider = StreamProvider.autoDispose<List<MenuItemEntity>>((ref) {
  return ref.watch(getMenuItemsUseCaseProvider).call(category: 'non coffee');
});

final pastryItemsProvider = StreamProvider.autoDispose<List<MenuItemEntity>>((ref) {
  return ref.watch(getMenuItemsUseCaseProvider).call(category: 'pastry');
});

// ignore: non_constant_identifier_names
final PastryitemsProvider = pastryItemsProvider;

final allItemsProvider = StreamProvider.autoDispose<List<MenuItemEntity>>((ref) {
  return ref.watch(getMenuItemsUseCaseProvider).call();
});
