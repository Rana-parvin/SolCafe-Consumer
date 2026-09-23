import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreClient {
  final FirebaseFirestore firestore;

  FirestoreClient({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> collection(String collectionPath) {
    return firestore.collection(collectionPath);
  }

  DocumentReference<Map<String, dynamic>> doc(String docPath) {
    return firestore.doc(docPath);
  }

  WriteBatch batch() {
    return firestore.batch();
  }
}
