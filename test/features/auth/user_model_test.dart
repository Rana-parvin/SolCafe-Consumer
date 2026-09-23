import 'package:flutter_test/flutter_test.dart';
import 'package:solcafe/features/auth/data/models/user_model.dart';
import 'package:solcafe/features/auth/domain/entities/user_entity.dart';

void main() {
  const tUserModel = UserModel(
    uid: '123',
    displayName: 'Test User',
    email: 'test@example.com',
    phoneNumber: '1234567890',
  );

  group('UserModel & UserEntity Tests', () {
    test('should be a subclass of UserEntity', () {
      expect(tUserModel, isA<UserEntity>());
    });

    test('toJson should return correct map structure', () {
      final json = tUserModel.toJson();
      expect(json['uid'], equals('123'));
      expect(json['name'], equals('Test User'));
      expect(json['email'], equals('test@example.com'));
      expect(json['phone'], equals('1234567890'));
    });
  });
}
