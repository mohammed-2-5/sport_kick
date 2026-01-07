import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/auth/domain/usecases/reset_password_usecase.dart';

import '../../../../helpers/mock_dependencies.dart';

void main() {
  late ResetPasswordUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = ResetPasswordUseCase(mockRepository);
  });

  group('ResetPasswordUseCase', () {
    const tEmail = 'user@example.com';

    group('successful password reset', () {
      test(
        'should return Right(void) when password reset email is sent successfully',
        () async {
          // Arrange
          when(
            () => mockRepository.resetPassword(email: any(named: 'email')),
          ).thenAnswer((_) async => const Right(null));

          // Act
          final result = await useCase(tEmail);

          // Assert
          expect(result.isRight(), true);
          verify(() => mockRepository.resetPassword(email: tEmail)).called(1);
        },
      );

      test('should call repository with correct email', () async {
        // Arrange
        when(
          () => mockRepository.resetPassword(email: any(named: 'email')),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await useCase(tEmail);

        // Assert
        verify(() => mockRepository.resetPassword(email: tEmail)).called(1);
      });

      test('should succeed with lowercase email', () async {
        // Arrange
        const lowercaseEmail = 'user@example.com';
        when(
          () => mockRepository.resetPassword(email: any(named: 'email')),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(lowercaseEmail);

        // Assert
        expect(result.isRight(), true);
      });

      test('should succeed with uppercase email', () async {
        // Arrange
        const uppercaseEmail = 'USER@EXAMPLE.COM';
        when(
          () => mockRepository.resetPassword(email: any(named: 'email')),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(uppercaseEmail);

        // Assert
        expect(result.isRight(), true);
      });

      test('should succeed with email containing plus sign', () async {
        // Arrange
        const emailWithPlus = 'user+tag@example.com';
        when(
          () => mockRepository.resetPassword(email: any(named: 'email')),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(emailWithPlus);

        // Assert
        expect(result.isRight(), true);
      });

      test('should succeed with email containing dots', () async {
        // Arrange
        const emailWithDots = 'user.name@example.com';
        when(
          () => mockRepository.resetPassword(email: any(named: 'email')),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(emailWithDots);

        // Assert
        expect(result.isRight(), true);
      });

      test('should succeed with email containing subdomain', () async {
        // Arrange
        const emailWithSubdomain = 'user@mail.example.com';
        when(
          () => mockRepository.resetPassword(email: any(named: 'email')),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(emailWithSubdomain);

        // Assert
        expect(result.isRight(), true);
      });

      test('should succeed with very long email', () async {
        // Arrange
        const longEmail = 'very.long.email.address.for.testing@example.com';
        when(
          () => mockRepository.resetPassword(email: any(named: 'email')),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(longEmail);

        // Assert
        expect(result.isRight(), true);
      });
    });

    group('validation failures', () {
      test(
        'should return ValidationFailure when email format is invalid',
        () async {
          // Arrange
          const tFailure = ValidationFailure('Invalid email format');
          when(
            () => mockRepository.resetPassword(email: any(named: 'email')),
          ).thenAnswer((_) async => const Left(tFailure));

          // Act
          final result = await useCase('invalid-email');

          // Assert
          expect(result, equals(const Left(tFailure)));
        },
      );

      test('should return ValidationFailure when email is empty', () async {
        // Arrange
        const tFailure = ValidationFailure('Email is required');
        when(
          () => mockRepository.resetPassword(email: any(named: 'email')),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase('');

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test(
        'should return ValidationFailure when email has no domain',
        () async {
          // Arrange
          const tFailure = ValidationFailure('Invalid email format');
          when(
            () => mockRepository.resetPassword(email: any(named: 'email')),
          ).thenAnswer((_) async => const Left(tFailure));

          // Act
          final result = await useCase('user@');

          // Assert
          expect(result, equals(const Left(tFailure)));
        },
      );

      test(
        'should return ValidationFailure when email has no @ symbol',
        () async {
          // Arrange
          const tFailure = ValidationFailure('Invalid email format');
          when(
            () => mockRepository.resetPassword(email: any(named: 'email')),
          ).thenAnswer((_) async => const Left(tFailure));

          // Act
          final result = await useCase('userexample.com');

          // Assert
          expect(result, equals(const Left(tFailure)));
        },
      );
    });

    group('authentication failures', () {
      test('should return AuthFailure when email does not exist', () async {
        // Arrange
        const tFailure = AuthFailure('Email not found');
        when(
          () => mockRepository.resetPassword(email: any(named: 'email')),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tEmail);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return AuthFailure when user account is inactive', () async {
        // Arrange
        const tFailure = AuthFailure('Account is inactive');
        when(
          () => mockRepository.resetPassword(email: any(named: 'email')),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tEmail);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test(
        'should return AuthFailure when user account is suspended',
        () async {
          // Arrange
          const tFailure = AuthFailure('Account is suspended');
          when(
            () => mockRepository.resetPassword(email: any(named: 'email')),
          ).thenAnswer((_) async => const Left(tFailure));

          // Act
          final result = await useCase(tEmail);

          // Assert
          expect(result, equals(const Left(tFailure)));
        },
      );

      test('should return AuthFailure when too many reset attempts', () async {
        // Arrange
        const tFailure = AuthFailure(
          'Too many reset attempts. Try again later',
        );
        when(
          () => mockRepository.resetPassword(email: any(named: 'email')),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tEmail);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });

    group('network and server failures', () {
      test('should return NetworkFailure when network error occurs', () async {
        // Arrange
        const tFailure = NetworkFailure('No internet connection');
        when(
          () => mockRepository.resetPassword(email: any(named: 'email')),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tEmail);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ServerFailure when server error occurs', () async {
        // Arrange
        const tFailure = ServerFailure('Server error');
        when(
          () => mockRepository.resetPassword(email: any(named: 'email')),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tEmail);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ServerFailure when email service fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to send reset email');
        when(
          () => mockRepository.resetPassword(email: any(named: 'email')),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tEmail);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test(
        'should return ServerFailure when email service is unavailable',
        () async {
          // Arrange
          const tFailure = ServerFailure('Email service unavailable');
          when(
            () => mockRepository.resetPassword(email: any(named: 'email')),
          ).thenAnswer((_) async => const Left(tFailure));

          // Act
          final result = await useCase(tEmail);

          // Assert
          expect(result, equals(const Left(tFailure)));
        },
      );

      test('should return ServerFailure on timeout', () async {
        // Arrange
        const tFailure = ServerFailure('Request timeout');
        when(
          () => mockRepository.resetPassword(email: any(named: 'email')),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tEmail);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });

    group('edge cases', () {
      test('should call repository only once', () async {
        // Arrange
        when(
          () => mockRepository.resetPassword(email: any(named: 'email')),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await useCase(tEmail);

        // Assert
        verify(() => mockRepository.resetPassword(email: tEmail)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should handle email with leading and trailing spaces', () async {
        // Arrange
        const emailWithSpaces = '  user@example.com  ';
        when(
          () => mockRepository.resetPassword(email: any(named: 'email')),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(emailWithSpaces);

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.resetPassword(email: emailWithSpaces),
        ).called(1);
      });

      test(
        'should handle multiple consecutive reset requests for same email',
        () async {
          // Arrange
          when(
            () => mockRepository.resetPassword(email: any(named: 'email')),
          ).thenAnswer((_) async => const Right(null));

          // Act
          final result1 = await useCase(tEmail);
          final result2 = await useCase(tEmail);
          final result3 = await useCase(tEmail);

          // Assert
          expect(result1.isRight(), true);
          expect(result2.isRight(), true);
          expect(result3.isRight(), true);
          verify(() => mockRepository.resetPassword(email: tEmail)).called(3);
        },
      );

      test(
        'should handle concurrent reset requests for different emails',
        () async {
          // Arrange
          when(
            () => mockRepository.resetPassword(email: any(named: 'email')),
          ).thenAnswer((_) async => const Right(null));

          // Act
          final results = await Future.wait([
            useCase('user1@example.com'),
            useCase('user2@example.com'),
            useCase('user3@example.com'),
          ]);

          // Assert
          for (final result in results) {
            expect(result.isRight(), true);
          }
        },
      );

      test('should handle email with numbers', () async {
        // Arrange
        const emailWithNumbers = 'user123@example.com';
        when(
          () => mockRepository.resetPassword(email: any(named: 'email')),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(emailWithNumbers);

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle email with hyphens', () async {
        // Arrange
        const emailWithHyphens = 'user-name@example.com';
        when(
          () => mockRepository.resetPassword(email: any(named: 'email')),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(emailWithHyphens);

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle email with underscores', () async {
        // Arrange
        const emailWithUnderscores = 'user_name@example.com';
        when(
          () => mockRepository.resetPassword(email: any(named: 'email')),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(emailWithUnderscores);

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle domain with country code TLD', () async {
        // Arrange
        const emailWithCountryTld = 'user@example.co.uk';
        when(
          () => mockRepository.resetPassword(email: any(named: 'email')),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(emailWithCountryTld);

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle domain with new TLD', () async {
        // Arrange
        const emailWithNewTld = 'user@example.tech';
        when(
          () => mockRepository.resetPassword(email: any(named: 'email')),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(emailWithNewTld);

        // Assert
        expect(result.isRight(), true);
      });

      test('should not throw exception on reset', () async {
        // Arrange
        when(
          () => mockRepository.resetPassword(email: any(named: 'email')),
        ).thenAnswer((_) async => const Right(null));

        // Act & Assert
        expect(() => useCase(tEmail), returnsNormally);
      });

      test('should complete reset in reasonable time', () async {
        // Arrange
        when(
          () => mockRepository.resetPassword(email: any(named: 'email')),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final stopwatch = Stopwatch()..start();
        await useCase(tEmail);
        stopwatch.stop();

        // Assert
        expect(stopwatch.elapsedMilliseconds, lessThan(5000));
      });

      test('should handle email for admin account', () async {
        // Arrange
        const adminEmail = 'admin@example.com';
        when(
          () => mockRepository.resetPassword(email: any(named: 'email')),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(adminEmail);

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle email for super admin account', () async {
        // Arrange
        const superAdminEmail = 'superadmin@example.com';
        when(
          () => mockRepository.resetPassword(email: any(named: 'email')),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(superAdminEmail);

        // Assert
        expect(result.isRight(), true);
      });
    });

    group('repository interaction', () {
      test(
        'should only interact with repository resetPassword method',
        () async {
          // Arrange
          when(
            () => mockRepository.resetPassword(email: any(named: 'email')),
          ).thenAnswer((_) async => const Right(null));

          // Act
          await useCase(tEmail);

          // Assert
          verify(() => mockRepository.resetPassword(email: tEmail)).called(1);
          verifyNoMoreInteractions(mockRepository);
        },
      );

      test('should propagate repository result unchanged', () async {
        // Arrange
        when(
          () => mockRepository.resetPassword(email: any(named: 'email')),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(tEmail);

        // Assert
        expect(result.isRight(), true);
      });

      test('should propagate repository failure unchanged', () async {
        // Arrange
        const tFailure = ServerFailure('Test failure');
        when(
          () => mockRepository.resetPassword(email: any(named: 'email')),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tEmail);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
