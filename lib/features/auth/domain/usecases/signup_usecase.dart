import 'package:solcafe/features/auth/domain/entities/user_entity.dart';
import 'package:solcafe/features/auth/domain/repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  Future<UserEntity> call(String name, String email, String phone, String password) {
    return repository.signup(name, email, phone, password);
  }
}
