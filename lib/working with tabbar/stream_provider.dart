import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



final coffeeItemsProvider = StreamProvider.autoDispose<QuerySnapshot>((ref) {
  return FirebaseFirestore.instance
      .collection('menu')
      .where('category', isEqualTo: 'coffee')
      .snapshots();
});

final cakeItemsProvider = StreamProvider.autoDispose<QuerySnapshot>((ref) {
  return FirebaseFirestore.instance
      .collection('menu')
      .where('category', isEqualTo: 'cake')
      .snapshots();
});

final OtheritemsProvider = StreamProvider.autoDispose<QuerySnapshot>((ref) {
  return FirebaseFirestore.instance
      .collection('menu')
      .where('category', isEqualTo: 'other items')
      .snapshots();
});

final noncoffeeProvider = StreamProvider.autoDispose<QuerySnapshot>((ref) {
  return FirebaseFirestore.instance
      .collection('menu')
      .where('category', isEqualTo: 'non coffee')
      .snapshots();
});

final PastryitemsProvider = StreamProvider.autoDispose<QuerySnapshot>((ref) {
  return FirebaseFirestore.instance
      .collection('menu')
      .where('category', isEqualTo: 'pastry')
      .snapshots();
});

final allItemsProvider = StreamProvider.autoDispose<QuerySnapshot>((ref) {
  return FirebaseFirestore.instance.collection('menu').snapshots();
});
