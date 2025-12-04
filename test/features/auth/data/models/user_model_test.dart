import 'package:flutter_test/flutter_test.dart';
import 'package:spo_kick/features/auth/data/models/user_model.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';

void main() {
  final tUserModel = UserModel(
    id: 'user-1',
    email: 'test@example.com',
    fullName: 'Test User',
    role: 'admin',
    passwordChanged: true,
    createdAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
    updatedAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
  );

  test('should be a subclass of UserEntity', () async {
    expect(tUserModel, isA<UserEntity>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON is valid', () async {
      final Map<String, dynamic> jsonMap = {
        'id': 'user-1',
        'email': 'test@example.com',
        'full_name': 'Test User',
        'role': 'admin',
        'password_changed': true,
        'created_at': '2023-01-01T00:00:00.000Z',
        'updated_at': '2023-01-01T00:00:00.000Z',
      };

      final result = UserModel.fromJson(jsonMap);

      expect(result, tUserModel);
    });

    test('should default passwordChanged to false if missing', () async {
      final Map<String, dynamic> jsonMap = {
        'id': 'user-1',
        'email': 'test@example.com',
        'full_name': 'Test User',
        'role': 'admin',
        'created_at': '2023-01-01T00:00:00.000Z',
        'updated_at': '2023-01-01T00:00:00.000Z',
      };

      final result = UserModel.fromJson(jsonMap);

      expect(result.passwordChanged, false);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () async {
      final result = tUserModel.toJson();

      final expectedMap = {
        'id': 'user-1',
        'email': 'test@example.com',
        'full_name': 'Test User',
        'phone': null,
        'role': 'admin',
        'is_active': true,
        'avatar_url': null,
        'preferred_sports': [],
        'password_changed': true,
        'created_at': '2023-01-01T00:00:00.000Z',
        'updated_at': '2023-01-01T00:00:00.000Z',
      };

      expect(result, expectedMap);
    });
  });
}
