import 'package:solcafe/features/menu/domain/entities/menu_item_entity.dart';
import 'package:solcafe/features/menu/domain/repositories/menu_repository.dart';

class SearchMenuItemsUseCase {
  final MenuRepository repository;

  SearchMenuItemsUseCase(this.repository);

  Future<List<MenuItemEntity>> call(String query) {
    return repository.searchMenuItems(query);
  }
}
