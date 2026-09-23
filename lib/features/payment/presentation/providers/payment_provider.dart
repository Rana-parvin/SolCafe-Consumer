import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solcafe/features/payment/data/datasources/payment_remote_datasource.dart';
import 'package:solcafe/features/payment/data/repositories/payment_repository_impl.dart';
import 'package:solcafe/features/payment/domain/entities/payment_entity.dart';
import 'package:solcafe/features/payment/domain/repositories/payment_repository.dart';
import 'package:solcafe/features/payment/domain/usecases/process_payment_usecase.dart';

final paymentRemoteDataSourceProvider = Provider<PaymentRemoteDataSource>((ref) {
  return PaymentRemoteDataSourceImpl();
});

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  final dataSource = ref.watch(paymentRemoteDataSourceProvider);
  return PaymentRepositoryImpl(dataSource);
});

final processPaymentUseCaseProvider = Provider<ProcessPaymentUseCase>((ref) {
  final repository = ref.watch(paymentRepositoryProvider);
  return ProcessPaymentUseCase(repository);
});

final userPaymentHistoryStreamProvider = StreamProvider.family<List<PaymentEntity>, String>((ref, userId) {
  final repository = ref.watch(paymentRepositoryProvider);
  return repository.getPaymentHistory(userId);
});
