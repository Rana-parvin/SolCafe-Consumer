import 'package:solcafe/features/menu/data/datasources/menu_remote_datasource.dart';
import 'package:solcafe/features/menu/domain/entities/menu_item_entity.dart';
import 'package:solcafe/features/menu/domain/repositories/menu_repository.dart';

class MenuRepositoryImpl implements MenuRepository {
  final MenuRemoteDataSource remoteDataSource;

  MenuRepositoryImpl(this.remoteDataSource);

  @override
  Stream<List<MenuItemEntity>> getMenuItems({String? category}) {
    return remoteDataSource.getMenuItems(category: category);
  }

  @override
  Future<List<MenuItemEntity>> searchMenuItems(String query) {
    return remoteDataSource.searchMenuItems(query);
  }
}
