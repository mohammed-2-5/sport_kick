import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/auth/domain/usecases/login_usecase.dart';

import '../../../../helpers/mock_dependencies.dart';

void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository);
  });

  group('LoginUseCase', () {
    const tEmail = 'test@example.com';
    const tPassword = 'Password123!';
    const tParams = LoginParams(email: tEmail, password: tPassword);

    final tUserEntity = UserEntity(
      id: 'user-123',
      email: tEmail,
      fullName: 'Test User',
      phone: '+201234567890',
      role: 'user',
      isActive: true,
      passwordChanged: true,
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 15),
    );

    group('successful login', () {
      test(
        'should return UserEntity when login succeeds with valid credentials',
        () async {
          // Arrange
          when(
            () => mockRepository.login(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => Right(tUserEntity));

          // Act
          final result = await useCase(tParams);

          // Assert
          expect(result.isRight(), true);
          result.fold(
            (_) => fail('Should return Right'),
            (user) => expect(user, equals(tUserEntity)),
          );
          verify(
            () => mockRepository.login(email: tEmail, password: tPassword),
          ).called(1);
        },
      );

      test('should return admin user when admin logs in', () async {
        // Arrange
        final adminUser = tUserEntity.copyWith(
          role: 'admin',
          fieldsCount: 5,
          totalRevenue: 10000.0,
        );
        when(
          () => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => Right(adminUser));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result.isRight(), true);
        result.fold((_) => fail('Should return Right'), (user) {
          expect(user, equals(adminUser));
          expect(user.role, 'admin');
          expect(user.isAdmin, true);
        });
      });

      test('should return super admin user when super admin logs in', () async {
        // Arrange
        final superAdminUser = tUserEntity.copyWith(role: 'super_admin');
        when(
          () => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => Right(superAdminUser));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result.isRight(), true);
        result.fold((_) => fail('Should return Right'), (user) {
          expect(user, equals(superAdminUser));
          expect(user.role, 'super_admin');
          expect(user.isSuperAdmin, true);
        });
      });

      test('should succeed with user who has not changed password', () async {
        // Arrange
        final newUser = tUserEntity.copyWith(passwordChanged: false);
        when(
          () => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => Right(newUser));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result.isRight(), true);
        result.fold((_) => fail('Should return Right'), (user) {
          expect(user.passwordChanged, false);
        });
      });

      test('should succeed with email in uppercase', () async {
        // Arrange
        const uppercaseParams = LoginParams(
          email: 'TEST@EXAMPLE.COM',
          password: tPassword,
        );

        when(
          () => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => Right(tUserEntity));

        // Act
        final result = await useCase(uppercaseParams);

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.login(
            email: 'TEST@EXAMPLE.COM',
            password: tPassword,
          ),
        ).called(1);
      });

      test('should succeed with email containing plus sign', () async {
        // Arrange
        const emailWithPlus = 'test+alias@example.com';
        const params = LoginParams(email: emailWithPlus, password: tPassword);

        when(
          () => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => Right(tUserEntity));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
      });

      test('should succeed with email containing dots', () async {
        // Arrange
        const emailWithDots = 'test.user.name@example.com';
        const params = LoginParams(email: emailWithDots, password: tPassword);

        when(
          () => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => Right(tUserEntity));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
      });

      test(
        'should succeed with password containing special characters',
        () async {
          // Arrange
          const specialPassword = 'P@ssw0rd!#\$%^&*()';
          const params = LoginParams(email: tEmail, password: specialPassword);

          when(
            () => mockRepository.login(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => Right(tUserEntity));

          // Act
          final result = await useCase(params);

          // Assert
          expect(result.isRight(), true);
        },
      );
    });

    group('authentication failures', () {
      test('should return AuthFailure when credentials are invalid', () async {
        // Arrange
        const tFailure = AuthFailure('Invalid email or password');
        when(
          () => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return AuthFailure when email does not exist', () async {
        // Arrange
        const tFailure = AuthFailure('User not found');
        when(
          () => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return AuthFailure when password is incorrect', () async {
        // Arrange
        const tFailure = AuthFailure('Incorrect password');
        when(
          () => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return AuthFailure when account is inactive', () async {
        // Arrange
        const tFailure = AuthFailure('Account is inactive');
        when(
          () => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return AuthFailure when account is suspended', () async {
        // Arrange
        const tFailure = AuthFailure('Account suspended');
        when(
          () => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return AuthFailure when too many login attempts', () async {
        // Arrange
        const tFailure = AuthFailure(
          'Too many failed attempts. Try again later',
        );
        when(
          () => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });

    group('network and server failures', () {
      test('should return NetworkFailure when network error occurs', () async {
        // Arrange
        const tFailure = NetworkFailure('No internet connection');
        when(
          () => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ServerFailure when server error occurs', () async {
        // Arrange
        const tFailure = ServerFailure('Server error');
        when(
          () => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ServerFailure when server is down', () async {
        // Arrange
        const tFailure = ServerFailure('Service temporarily unavailable');
        when(
          () => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ServerFailure on timeout', () async {
        // Arrange
        const tFailure = ServerFailure('Request timeout');
        when(
          () => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });

    group('edge cases', () {
      test('should call repository only once', () async {
        // Arrange
        when(
          () => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => Right(tUserEntity));

        // Act
        await useCase(tParams);

        // Assert
        verify(
          () => mockRepository.login(email: tEmail, password: tPassword),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should handle email with leading and trailing spaces', () async {
        // Arrange
        const params = LoginParams(
          email: '  test@example.com  ',
          password: tPassword,
        );

        when(
          () => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => Right(tUserEntity));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.login(
            email: '  test@example.com  ',
            password: tPassword,
          ),
        ).called(1);
      });

      test('should handle password with spaces', () async {
        // Arrange
        const params = LoginParams(email: tEmail, password: 'Pass Word 123!');

        when(
          () => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => Right(tUserEntity));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle very long email', () async {
        // Arrange
        const longEmail =
            'very.long.email.address.for.testing.purposes@example.com';
        const params = LoginParams(email: longEmail, password: tPassword);

        when(
          () => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => Right(tUserEntity));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle very long password', () async {
        // Arrange
        final longPassword = 'P@ssw0rd' * 20; // 160 characters
        final params = LoginParams(email: tEmail, password: longPassword);

        when(
          () => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => Right(tUserEntity));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle email with subdomain', () async {
        // Arrange
        const params = LoginParams(
          email: 'test@mail.example.com',
          password: tPassword,
        );

        when(
          () => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => Right(tUserEntity));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle password with unicode characters', () async {
        // Arrange
        const params = LoginParams(
          email: tEmail,
          password: 'P@ssw0rd_مرحبا_你好',
        );

        when(
          () => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => Right(tUserEntity));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle empty preferred sports list', () async {
        // Arrange
        final userWithNoSports = tUserEntity.copyWith(preferredSports: []);
        when(
          () => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => Right(userWithNoSports));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should return Right'),
          (user) => expect(user.preferredSports, isEmpty),
        );
      });
    });

    group('LoginParams', () {
      test('should have correct props for equality comparison', () {
        // Arrange
        const params1 = LoginParams(
          email: 'test@example.com',
          password: 'password123',
        );
        const params2 = LoginParams(
          email: 'test@example.com',
          password: 'password123',
        );
        const params3 = LoginParams(
          email: 'different@example.com',
          password: 'password123',
        );

        // Assert
        expect(params1, equals(params2));
        expect(params1, isNot(equals(params3)));
      });

      test('should include all fields in props', () {
        // Arrange
        const params = LoginParams(
          email: 'test@example.com',
          password: 'password123',
        );

        // Assert
        expect(params.props, ['test@example.com', 'password123']);
      });

      test('should be different when password is different', () {
        // Arrange
        const params1 = LoginParams(
          email: 'test@example.com',
          password: 'password123',
        );
        const params2 = LoginParams(
          email: 'test@example.com',
          password: 'different-password',
        );

        // Assert
        expect(params1, isNot(equals(params2)));
      });
    });
  });
}
