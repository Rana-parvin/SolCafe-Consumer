import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solcafe/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:solcafe/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:solcafe/features/auth/domain/entities/user_entity.dart';
import 'package:solcafe/features/auth/domain/repositories/auth_repository.dart';
import 'package:solcafe/features/auth/domain/usecases/login_usecase.dart';
import 'package:solcafe/features/auth/domain/usecases/signup_usecase.dart';
import 'package:solcafe/features/auth/domain/usecases/logout_usecase.dart';
import 'package:solcafe/features/auth/domain/usecases/update_profile_usecase.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource);
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
});

final signupUseCaseProvider = Provider<SignupUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignupUseCase(repository);
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LogoutUseCase(repository);
});

final updateProfileUseCaseProvider = Provider<UpdateProfileUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return UpdateProfileUseCase(repository);
});

final authStateChangesProvider = StreamProvider<UserEntity?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges;
});

final currentUserProvider = Provider<UserEntity?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.currentUser;
});
