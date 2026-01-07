import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/auth/domain/usecases/register_usecase.dart';

import '../../../../helpers/mock_dependencies.dart';

void main() {
  late RegisterUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = RegisterUseCase(mockRepository);
  });

  group('RegisterUseCase', () {
    const tEmail = 'newuser@example.com';
    const tPassword = 'Password123!';
    const tFullName = 'New User';
    const tPhone = '+201234567890';
    const tParams = RegisterParams(
      email: tEmail,
      password: tPassword,
      fullName: tFullName,
      phone: tPhone,
    );

    final tUserEntity = UserEntity(
      id: 'user-123',
      email: tEmail,
      fullName: tFullName,
      phone: tPhone,
      role: 'user',
      isActive: true,
      passwordChanged: false,
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    );

    group('successful registration', () {
      test(
        'should return UserEntity when registration succeeds with all fields',
        () async {
          // Arrange
          when(
            () => mockRepository.register(
              email: any(named: 'email'),
              password: any(named: 'password'),
              fullName: any(named: 'fullName'),
              phone: any(named: 'phone'),
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
            () => mockRepository.register(
              email: tEmail,
              password: tPassword,
              fullName: tFullName,
              phone: tPhone,
            ),
          ).called(1);
        },
      );

      test('should succeed without phone number (optional field)', () async {
        // Arrange
        const paramsWithoutPhone = RegisterParams(
          email: tEmail,
          password: tPassword,
          fullName: tFullName,
        );

        when(
          () => mockRepository.register(
            email: any(named: 'email'),
            password: any(named: 'password'),
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
          ),
        ).thenAnswer((_) async => Right(tUserEntity));

        // Act
        final result = await useCase(paramsWithoutPhone);

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.register(
            email: tEmail,
            password: tPassword,
            fullName: tFullName,
            phone: null,
          ),
        ).called(1);
      });

      test('should create user with default role as user', () async {
        // Arrange
        when(
          () => mockRepository.register(
            email: any(named: 'email'),
            password: any(named: 'password'),
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
          ),
        ).thenAnswer((_) async => Right(tUserEntity));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result.isRight(), true);
        result.fold((_) => fail('Should return Right'), (user) {
          expect(user.role, 'user');
          expect(user.isSuperAdmin, false);
          expect(user.isAdmin, false);
        });
      });

      test('should create user with passwordChanged as false', () async {
        // Arrange
        when(
          () => mockRepository.register(
            email: any(named: 'email'),
            password: any(named: 'password'),
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
          ),
        ).thenAnswer((_) async => Right(tUserEntity));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should return Right'),
          (user) => expect(user.passwordChanged, false),
        );
      });

      test('should succeed with email in uppercase', () async {
        // Arrange
        const params = RegisterParams(
          email: 'NEWUSER@EXAMPLE.COM',
          password: tPassword,
          fullName: tFullName,
        );

        when(
          () => mockRepository.register(
            email: any(named: 'email'),
            password: any(named: 'password'),
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
          ),
        ).thenAnswer((_) async => Right(tUserEntity));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
      });

      test('should succeed with email containing plus sign', () async {
        // Arrange
        const params = RegisterParams(
          email: 'user+tag@example.com',
          password: tPassword,
          fullName: tFullName,
        );

        when(
          () => mockRepository.register(
            email: any(named: 'email'),
            password: any(named: 'password'),
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
          ),
        ).thenAnswer((_) async => Right(tUserEntity));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
      });

      test(
        'should succeed with full name containing special characters',
        () async {
          // Arrange
          const params = RegisterParams(
            email: tEmail,
            password: tPassword,
            fullName: "O'Brien-Smith Jr.",
          );

          when(
            () => mockRepository.register(
              email: any(named: 'email'),
              password: any(named: 'password'),
              fullName: any(named: 'fullName'),
              phone: any(named: 'phone'),
            ),
          ).thenAnswer((_) async => Right(tUserEntity));

          // Act
          final result = await useCase(params);

          // Assert
          expect(result.isRight(), true);
        },
      );

      test('should succeed with Arabic full name', () async {
        // Arrange
        const params = RegisterParams(
          email: tEmail,
          password: tPassword,
          fullName: 'محمد أحمد',
        );

        when(
          () => mockRepository.register(
            email: any(named: 'email'),
            password: any(named: 'password'),
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
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
          const params = RegisterParams(
            email: tEmail,
            password: 'P@ssw0rd!#\$%^&*()',
            fullName: tFullName,
          );

          when(
            () => mockRepository.register(
              email: any(named: 'email'),
              password: any(named: 'password'),
              fullName: any(named: 'fullName'),
              phone: any(named: 'phone'),
            ),
          ).thenAnswer((_) async => Right(tUserEntity));

          // Act
          final result = await useCase(params);

          // Assert
          expect(result.isRight(), true);
        },
      );

      test('should succeed with international phone number', () async {
        // Arrange
        const params = RegisterParams(
          email: tEmail,
          password: tPassword,
          fullName: tFullName,
          phone: '+44 20 7946 0958',
        );

        when(
          () => mockRepository.register(
            email: any(named: 'email'),
            password: any(named: 'password'),
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
          ),
        ).thenAnswer((_) async => Right(tUserEntity));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
      });
    });

    group('validation failures', () {
      test('should return ValidationFailure when email is invalid', () async {
        // Arrange
        const tFailure = ValidationFailure('Invalid email format');
        when(
          () => mockRepository.register(
            email: any(named: 'email'),
            password: any(named: 'password'),
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final params = RegisterParams(
          email: 'invalid-email',
          password: tPassword,
          fullName: tFullName,
        );
        final result = await useCase(params);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test(
        'should return ValidationFailure when password is too weak',
        () async {
          // Arrange
          const tFailure = ValidationFailure('Password is too weak');
          when(
            () => mockRepository.register(
              email: any(named: 'email'),
              password: any(named: 'password'),
              fullName: any(named: 'fullName'),
              phone: any(named: 'phone'),
            ),
          ).thenAnswer((_) async => const Left(tFailure));

          // Act
          final params = RegisterParams(
            email: tEmail,
            password: 'weak',
            fullName: tFullName,
          );
          final result = await useCase(params);

          // Assert
          expect(result, equals(const Left(tFailure)));
        },
      );

      test('should return ValidationFailure when full name is empty', () async {
        // Arrange
        const tFailure = ValidationFailure('Full name is required');
        when(
          () => mockRepository.register(
            email: any(named: 'email'),
            password: any(named: 'password'),
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final params = RegisterParams(
          email: tEmail,
          password: tPassword,
          fullName: '',
        );
        final result = await useCase(params);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test(
        'should return ValidationFailure when phone format is invalid',
        () async {
          // Arrange
          const tFailure = ValidationFailure('Invalid phone number format');
          when(
            () => mockRepository.register(
              email: any(named: 'email'),
              password: any(named: 'password'),
              fullName: any(named: 'fullName'),
              phone: any(named: 'phone'),
            ),
          ).thenAnswer((_) async => const Left(tFailure));

          // Act
          final params = RegisterParams(
            email: tEmail,
            password: tPassword,
            fullName: tFullName,
            phone: 'invalid-phone',
          );
          final result = await useCase(params);

          // Assert
          expect(result, equals(const Left(tFailure)));
        },
      );
    });

    group('authentication failures', () {
      test('should return AuthFailure when email already exists', () async {
        // Arrange
        const tFailure = AuthFailure('Email already registered');
        when(
          () => mockRepository.register(
            email: any(named: 'email'),
            password: any(named: 'password'),
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return AuthFailure when phone already exists', () async {
        // Arrange
        const tFailure = AuthFailure('Phone number already registered');
        when(
          () => mockRepository.register(
            email: any(named: 'email'),
            password: any(named: 'password'),
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return AuthFailure when registration is disabled', () async {
        // Arrange
        const tFailure = AuthFailure('Registration currently disabled');
        when(
          () => mockRepository.register(
            email: any(named: 'email'),
            password: any(named: 'password'),
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
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
          () => mockRepository.register(
            email: any(named: 'email'),
            password: any(named: 'password'),
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
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
          () => mockRepository.register(
            email: any(named: 'email'),
            password: any(named: 'password'),
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ServerFailure when database error occurs', () async {
        // Arrange
        const tFailure = ServerFailure('Database error');
        when(
          () => mockRepository.register(
            email: any(named: 'email'),
            password: any(named: 'password'),
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
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
          () => mockRepository.register(
            email: any(named: 'email'),
            password: any(named: 'password'),
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
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
          () => mockRepository.register(
            email: any(named: 'email'),
            password: any(named: 'password'),
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
          ),
        ).thenAnswer((_) async => Right(tUserEntity));

        // Act
        await useCase(tParams);

        // Assert
        verify(
          () => mockRepository.register(
            email: tEmail,
            password: tPassword,
            fullName: tFullName,
            phone: tPhone,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should handle email with leading and trailing spaces', () async {
        // Arrange
        const params = RegisterParams(
          email: '  newuser@example.com  ',
          password: tPassword,
          fullName: tFullName,
        );

        when(
          () => mockRepository.register(
            email: any(named: 'email'),
            password: any(named: 'password'),
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
          ),
        ).thenAnswer((_) async => Right(tUserEntity));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
      });

      test(
        'should handle full name with leading and trailing spaces',
        () async {
          // Arrange
          const params = RegisterParams(
            email: tEmail,
            password: tPassword,
            fullName: '  New User  ',
          );

          when(
            () => mockRepository.register(
              email: any(named: 'email'),
              password: any(named: 'password'),
              fullName: any(named: 'fullName'),
              phone: any(named: 'phone'),
            ),
          ).thenAnswer((_) async => Right(tUserEntity));

          // Act
          final result = await useCase(params);

          // Assert
          expect(result.isRight(), true);
        },
      );

      test('should handle very long full name', () async {
        // Arrange
        final longName = 'A' * 200;
        final params = RegisterParams(
          email: tEmail,
          password: tPassword,
          fullName: longName,
        );

        when(
          () => mockRepository.register(
            email: any(named: 'email'),
            password: any(named: 'password'),
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
          ),
        ).thenAnswer((_) async => Right(tUserEntity));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle very long email', () async {
        // Arrange
        const longEmail = 'very.long.email.address@example.com';
        const params = RegisterParams(
          email: longEmail,
          password: tPassword,
          fullName: tFullName,
        );

        when(
          () => mockRepository.register(
            email: any(named: 'email'),
            password: any(named: 'password'),
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
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
        final params = RegisterParams(
          email: tEmail,
          password: longPassword,
          fullName: tFullName,
        );

        when(
          () => mockRepository.register(
            email: any(named: 'email'),
            password: any(named: 'password'),
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
          ),
        ).thenAnswer((_) async => Right(tUserEntity));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
      });

      test(
        'should handle full name with multiple spaces between words',
        () async {
          // Arrange
          const params = RegisterParams(
            email: tEmail,
            password: tPassword,
            fullName: 'First    Middle    Last',
          );

          when(
            () => mockRepository.register(
              email: any(named: 'email'),
              password: any(named: 'password'),
              fullName: any(named: 'fullName'),
              phone: any(named: 'phone'),
            ),
          ).thenAnswer((_) async => Right(tUserEntity));

          // Act
          final result = await useCase(params);

          // Assert
          expect(result.isRight(), true);
        },
      );

      test('should handle phone with spaces and dashes', () async {
        // Arrange
        const params = RegisterParams(
          email: tEmail,
          password: tPassword,
          fullName: tFullName,
          phone: '+20 123 456-7890',
        );

        when(
          () => mockRepository.register(
            email: any(named: 'email'),
            password: any(named: 'password'),
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
          ),
        ).thenAnswer((_) async => Right(tUserEntity));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle email with subdomain', () async {
        // Arrange
        const params = RegisterParams(
          email: 'user@mail.example.com',
          password: tPassword,
          fullName: tFullName,
        );

        when(
          () => mockRepository.register(
            email: any(named: 'email'),
            password: any(named: 'password'),
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
          ),
        ).thenAnswer((_) async => Right(tUserEntity));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle password with unicode characters', () async {
        // Arrange
        const params = RegisterParams(
          email: tEmail,
          password: 'P@ssw0rd_مرحبا_你好',
          fullName: tFullName,
        );

        when(
          () => mockRepository.register(
            email: any(named: 'email'),
            password: any(named: 'password'),
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
          ),
        ).thenAnswer((_) async => Right(tUserEntity));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
      });
    });

    group('RegisterParams', () {
      test('should have correct props for equality comparison', () {
        // Arrange
        const params1 = RegisterParams(
          email: 'test@example.com',
          password: 'password123',
          fullName: 'Test User',
          phone: '+201234567890',
        );
        const params2 = RegisterParams(
          email: 'test@example.com',
          password: 'password123',
          fullName: 'Test User',
          phone: '+201234567890',
        );
        const params3 = RegisterParams(
          email: 'different@example.com',
          password: 'password123',
          fullName: 'Test User',
        );

        // Assert
        expect(params1, equals(params2));
        expect(params1, isNot(equals(params3)));
      });

      test('should include all fields in props', () {
        // Arrange
        const params = RegisterParams(
          email: 'test@example.com',
          password: 'password123',
          fullName: 'Test User',
          phone: '+201234567890',
        );

        // Assert
        expect(params.props, [
          'test@example.com',
          'password123',
          'Test User',
          '+201234567890',
        ]);
      });

      test('should handle null phone in props', () {
        // Arrange
        const params = RegisterParams(
          email: 'test@example.com',
          password: 'password123',
          fullName: 'Test User',
        );

        // Assert
        expect(params.props, [
          'test@example.com',
          'password123',
          'Test User',
          null,
        ]);
      });
    });
  });
}
