import 'package:solcafe/features/auth/domain/repositories/auth_repository.dart';

class UpdateProfileUseCase {
  final AuthRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<void> call({required String name, required String phone, required String email}) {
    return repository.updateProfile(name: name, phone: phone, email: email);
  }
}
