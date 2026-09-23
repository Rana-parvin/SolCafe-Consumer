import 'package:solcafe/features/menu/domain/entities/menu_item_entity.dart';

abstract class MenuRepository {
  Stream<List<MenuItemEntity>> getMenuItems({String? category});
  Future<List<MenuItemEntity>> searchMenuItems(String query);
}
