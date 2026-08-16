import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solcafe/features/menu/data/datasources/menu_remote_datasource.dart';
import 'package:solcafe/features/menu/data/repositories/menu_repository_impl.dart';
import 'package:solcafe/features/menu/domain/entities/menu_item_entity.dart';
import 'package:solcafe/features/menu/domain/repositories/menu_repository.dart';
import 'package:solcafe/features/menu/domain/usecases/get_menu_items_usecase.dart';
import 'package:solcafe/features/menu/domain/usecases/search_menu_items_usecase.dart';

final menuRemoteDataSourceProvider = Provider<MenuRemoteDataSource>((ref) {
  return MenuRemoteDataSourceImpl();
});

final menuRepositoryProvider = Provider<MenuRepository>((ref) {
  final dataSource = ref.watch(menuRemoteDataSourceProvider);
  return MenuRepositoryImpl(dataSource);
});

final getMenuItemsUseCaseProvider = Provider<GetMenuItemsUseCase>((ref) {
  final repository = ref.watch(menuRepositoryProvider);
  return GetMenuItemsUseCase(repository);
});

final searchMenuItemsUseCaseProvider = Provider<SearchMenuItemsUseCase>((ref) {
  final repository = ref.watch(menuRepositoryProvider);
  return SearchMenuItemsUseCase(repository);
});

final menuItemsStreamProvider = StreamProvider.family<List<MenuItemEntity>, String?>((ref, category) {
  final useCase = ref.watch(getMenuItemsUseCaseProvider);
  return useCase(category: category);
});
