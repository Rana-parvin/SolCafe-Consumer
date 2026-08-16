import 'package:flutter_test/flutter_test.dart';
import 'package:solcafe/core/error/failures.dart';
import 'package:solcafe/core/constants/app_constants.dart';

void main() {
  group('Core Domain & Failure Tests', () {
    test('ServerFailure returns default message when none provided', () {
      const failure = ServerFailure();
      expect(failure.message, equals('A server error occurred.'));
    });

    test('AuthFailure returns custom message when provided', () {
      const failure = AuthFailure('Invalid credentials');
      expect(failure.message, equals('Invalid credentials'));
    });

    test('AppConstants holds correct app name', () {
      expect(AppConstants.appName, equals('SolCafe'));
    });
  });
}
