import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solcafe/core/network/firestore_client.dart';
import 'package:solcafe/core/network/network_info.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final firestoreClientProvider = Provider<FirestoreClient>((ref) {
  return FirestoreClient(firestore: ref.watch(firebaseFirestoreProvider));
});

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl();
});
