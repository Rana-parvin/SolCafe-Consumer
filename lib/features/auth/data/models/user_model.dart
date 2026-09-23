import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:solcafe/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.email,
    required super.displayName,
    required super.phoneNumber,
  });

  factory UserModel.fromFirebaseUser(firebase.User user, Map<String, dynamic>? firestoreData) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? firestoreData?['email'] ?? '',
      displayName: user.displayName ?? firestoreData?['name'] ?? firestoreData?['username'] ?? '',
      phoneNumber: firestoreData?['phone'] ?? user.phoneNumber ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': displayName,
      'phone': phoneNumber,
    };
  }
}
