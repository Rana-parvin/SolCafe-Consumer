import 'package:solcafe/features/menu/domain/entities/menu_item_entity.dart';
import 'package:solcafe/features/menu/domain/repositories/menu_repository.dart';

class GetMenuItemsUseCase {
  final MenuRepository repository;

  GetMenuItemsUseCase(this.repository);

  Stream<List<MenuItemEntity>> call({String? category}) {
    return repository.getMenuItems(category: category);
  }
}
