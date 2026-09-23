import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solcafe/features/menu/data/models/menu_item_model.dart';

abstract class MenuRemoteDataSource {
  Stream<List<MenuItemModel>> getMenuItems({String? category});
  Future<List<MenuItemModel>> searchMenuItems(String query);
}

class MenuRemoteDataSourceImpl implements MenuRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<MenuItemModel>> getMenuItems({String? category}) {
    Query<Map<String, dynamic>> query = _firestore.collection('items');
    if (category != null && category.isNotEmpty) {
      query = query.where('category', isEqualTo: category);
    }
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => MenuItemModel.fromFirestore(doc)).toList();
    });
  }

  @override
  Future<List<MenuItemModel>> searchMenuItems(String queryText) async {
    final snapshot = await _firestore.collection('items').get();
    final lowercaseQuery = queryText.toLowerCase();

    return snapshot.docs
        .map((doc) => MenuItemModel.fromFirestore(doc))
        .where((item) =>
            item.title.toLowerCase().contains(lowercaseQuery) ||
            item.description.toLowerCase().contains(lowercaseQuery) ||
            item.category.toLowerCase().contains(lowercaseQuery))
        .toList();
  }
}
