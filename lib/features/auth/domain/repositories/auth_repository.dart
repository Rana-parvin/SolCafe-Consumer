import 'package:solcafe/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> get authStateChanges;
  UserEntity? get currentUser;
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> signup(String name, String email, String phone, String password);
  Future<void> logout();
  Future<void> updateProfile({required String name, required String phone, required String email});
}
