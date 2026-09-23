import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:solcafe/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Stream<UserModel?> get authStateChanges;
  UserModel? get currentUser;
  Future<UserModel> login(String email, String password);
  Future<UserModel> signup(String name, String email, String phone, String password);
  Future<void> logout();
  Future<void> updateProfile({required String name, required String phone, required String email});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase.FirebaseAuth _firebaseAuth = firebase.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      try {
        final doc = await _firestore.collection('users').doc(firebaseUser.uid).get();
        return UserModel.fromFirebaseUser(firebaseUser, doc.data());
      } catch (_) {
        return UserModel.fromFirebaseUser(firebaseUser, null);
      }
    });
  }

  @override
  UserModel? get currentUser {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return UserModel.fromFirebaseUser(user, null);
  }

  @override
  Future<UserModel> login(String email, String password) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final firebaseUser = credential.user!;
    final doc = await _firestore.collection('users').doc(firebaseUser.uid).get();
    return UserModel.fromFirebaseUser(firebaseUser, doc.data());
  }

  @override
  Future<UserModel> signup(String name, String email, String phone, String password) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final firebaseUser = credential.user!;
    
    // Standardize Firestore writes under both 'name' and 'username' keys to resolve inconsistency
    await _firestore.collection('users').doc(firebaseUser.uid).set({
      'uid': firebaseUser.uid,
      'name': name,
      'username': name,
      'email': email,
      'phone': phone,
    });

    await firebaseUser.updateDisplayName(name);
    
    final doc = await _firestore.collection('users').doc(firebaseUser.uid).get();
    return UserModel.fromFirebaseUser(firebaseUser, doc.data());
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> updateProfile({required String name, required String phone, required String email}) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) throw Exception('No authenticated user found');

    // Update Auth displayName
    await user.updateDisplayName(name);

    // Standardize key names in Firestore
    await _firestore.collection('users').doc(user.uid).update({
      'name': name,
      'username': name,
      'phone': phone,
      'email': email,
    });
  }
}
