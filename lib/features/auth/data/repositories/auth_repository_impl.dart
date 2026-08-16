import 'package:solcafe/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:solcafe/features/auth/domain/entities/user_entity.dart';
import 'package:solcafe/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Stream<UserEntity?> get authStateChanges => remoteDataSource.authStateChanges;

  @override
  UserEntity? get currentUser => remoteDataSource.currentUser;

  @override
  Future<UserEntity> login(String email, String password) {
    return remoteDataSource.login(email, password);
  }

  @override
  Future<UserEntity> signup(String name, String email, String phone, String password) {
    return remoteDataSource.signup(name, email, phone, password);
  }

  @override
  Future<void> logout() {
    return remoteDataSource.logout();
  }

  @override
  Future<void> updateProfile({required String name, required String phone, required String email}) {
    return remoteDataSource.updateProfile(name: name, phone: phone, email: email);
  }
}
