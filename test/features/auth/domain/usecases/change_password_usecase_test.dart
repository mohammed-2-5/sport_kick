import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/auth/domain/usecases/change_password_usecase.dart';

import '../../../../helpers/mock_dependencies.dart';

void main() {
  late ChangePasswordUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = ChangePasswordUseCase(mockRepository);
  });

  group('ChangePasswordUseCase', () {
    const tCurrentPassword = 'OldPass123!';
    const tNewPassword = 'NewPass456!';
    const tParams = ChangePasswordParams(
      currentPassword: tCurrentPassword,
      newPassword: tNewPassword,
    );

    group('successful password change', () {
      test(
        'should call repository with correct parameters when passwords are valid',
        () async {
          // Arrange
          when(
            () => mockRepository.changePassword(
              currentPassword: any(named: 'currentPassword'),
              newPassword: any(named: 'newPassword'),
            ),
          ).thenAnswer((_) async => const Right(null));

          // Act
          final result = await useCase(tParams);

          // Assert
          expect(result.isRight(), true);
          verify(
            () => mockRepository.changePassword(
              currentPassword: tCurrentPassword,
              newPassword: tNewPassword,
            ),
          ).called(1);
        },
      );

      test('should return Right(void) when password change succeeds', () async {
        // Arrange
        when(
          () => mockRepository.changePassword(
            currentPassword: any(named: 'currentPassword'),
            newPassword: any(named: 'newPassword'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result.isRight(), true);
      });

      test(
        'should succeed with strong password containing special characters',
        () async {
          // Arrange
          const strongPassword = 'StrongP@ssw0rd!2024#';
          const params = ChangePasswordParams(
            currentPassword: tCurrentPassword,
            newPassword: strongPassword,
          );

          when(
            () => mockRepository.changePassword(
              currentPassword: any(named: 'currentPassword'),
              newPassword: any(named: 'newPassword'),
            ),
          ).thenAnswer((_) async => const Right(null));

          // Act
          final result = await useCase(params);

          // Assert
          expect(result.isRight(), true);
        },
      );

      test('should succeed with password containing numbers', () async {
        // Arrange
        const numericPassword = 'Password123456789';
        const params = ChangePasswordParams(
          currentPassword: tCurrentPassword,
          newPassword: numericPassword,
        );

        when(
          () => mockRepository.changePassword(
            currentPassword: any(named: 'currentPassword'),
            newPassword: any(named: 'newPassword'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
      });

      test('should succeed with very long password', () async {
        // Arrange
        final longPassword = 'P@ssw0rd' * 10; // 80 characters
        final params = ChangePasswordParams(
          currentPassword: tCurrentPassword,
          newPassword: longPassword,
        );

        when(
          () => mockRepository.changePassword(
            currentPassword: any(named: 'currentPassword'),
            newPassword: any(named: 'newPassword'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
      });
    });

    group('repository failures', () {
      test('should return ServerFailure when repository call fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to change password');
        when(
          () => mockRepository.changePassword(
            currentPassword: any(named: 'currentPassword'),
            newPassword: any(named: 'newPassword'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return NetworkFailure when network error occurs', () async {
        // Arrange
        const tFailure = NetworkFailure('No internet connection');
        when(
          () => mockRepository.changePassword(
            currentPassword: any(named: 'currentPassword'),
            newPassword: any(named: 'newPassword'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test(
        'should return AuthFailure when current password is incorrect',
        () async {
          // Arrange
          const tFailure = AuthFailure('Current password is incorrect');
          when(
            () => mockRepository.changePassword(
              currentPassword: any(named: 'currentPassword'),
              newPassword: any(named: 'newPassword'),
            ),
          ).thenAnswer((_) async => const Left(tFailure));

          // Act
          final result = await useCase(tParams);

          // Assert
          expect(result, equals(const Left(tFailure)));
        },
      );

      test(
        'should return ValidationFailure when new password is weak',
        () async {
          // Arrange
          const tFailure = ValidationFailure('Password is too weak');
          when(
            () => mockRepository.changePassword(
              currentPassword: any(named: 'currentPassword'),
              newPassword: any(named: 'newPassword'),
            ),
          ).thenAnswer((_) async => const Left(tFailure));

          // Act
          final result = await useCase(tParams);

          // Assert
          expect(result, equals(const Left(tFailure)));
        },
      );

      test(
        'should return AuthFailure when user is not authenticated',
        () async {
          // Arrange
          const tFailure = AuthFailure('User not authenticated');
          when(
            () => mockRepository.changePassword(
              currentPassword: any(named: 'currentPassword'),
              newPassword: any(named: 'newPassword'),
            ),
          ).thenAnswer((_) async => const Left(tFailure));

          // Act
          final result = await useCase(tParams);

          // Assert
          expect(result, equals(const Left(tFailure)));
        },
      );

      test('should return ServerFailure when session has expired', () async {
        // Arrange
        const tFailure = ServerFailure('Session expired');
        when(
          () => mockRepository.changePassword(
            currentPassword: any(named: 'currentPassword'),
            newPassword: any(named: 'newPassword'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test(
        'should return ValidationFailure when new password is same as current',
        () async {
          // Arrange
          const tFailure = ValidationFailure(
            'New password must be different from current',
          );
          when(
            () => mockRepository.changePassword(
              currentPassword: any(named: 'currentPassword'),
              newPassword: any(named: 'newPassword'),
            ),
          ).thenAnswer((_) async => const Left(tFailure));

          // Act
          final result = await useCase(tParams);

          // Assert
          expect(result, equals(const Left(tFailure)));
        },
      );
    });

    group('edge cases', () {
      test('should call repository only once', () async {
        // Arrange
        when(
          () => mockRepository.changePassword(
            currentPassword: any(named: 'currentPassword'),
            newPassword: any(named: 'newPassword'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await useCase(tParams);

        // Assert
        verify(
          () => mockRepository.changePassword(
            currentPassword: tCurrentPassword,
            newPassword: tNewPassword,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should handle password with leading and trailing spaces', () async {
        // Arrange
        const params = ChangePasswordParams(
          currentPassword: '  OldPass123!  ',
          newPassword: '  NewPass456!  ',
        );

        when(
          () => mockRepository.changePassword(
            currentPassword: any(named: 'currentPassword'),
            newPassword: any(named: 'newPassword'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.changePassword(
            currentPassword: '  OldPass123!  ',
            newPassword: '  NewPass456!  ',
          ),
        ).called(1);
      });

      test(
        'should handle password with only spaces between characters',
        () async {
          // Arrange
          const params = ChangePasswordParams(
            currentPassword: tCurrentPassword,
            newPassword: 'New Pass 456!',
          );

          when(
            () => mockRepository.changePassword(
              currentPassword: any(named: 'currentPassword'),
              newPassword: any(named: 'newPassword'),
            ),
          ).thenAnswer((_) async => const Right(null));

          // Act
          final result = await useCase(params);

          // Assert
          expect(result.isRight(), true);
        },
      );

      test('should handle password with unicode characters', () async {
        // Arrange
        const params = ChangePasswordParams(
          currentPassword: tCurrentPassword,
          newPassword: 'P@ssw0rd_مرحبا_你好',
        );

        when(
          () => mockRepository.changePassword(
            currentPassword: any(named: 'currentPassword'),
            newPassword: any(named: 'newPassword'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle password with emojis', () async {
        // Arrange
        const params = ChangePasswordParams(
          currentPassword: tCurrentPassword,
          newPassword: 'P@ssw0rd😀🔒',
        );

        when(
          () => mockRepository.changePassword(
            currentPassword: any(named: 'currentPassword'),
            newPassword: any(named: 'newPassword'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle minimum length password', () async {
        // Arrange
        const params = ChangePasswordParams(
          currentPassword: tCurrentPassword,
          newPassword: 'Pass1!',
        );

        when(
          () => mockRepository.changePassword(
            currentPassword: any(named: 'currentPassword'),
            newPassword: any(named: 'newPassword'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
      });
    });

    group('ChangePasswordParams', () {
      test('should have correct props for equality comparison', () {
        // Arrange
        const params1 = ChangePasswordParams(
          currentPassword: 'password1',
          newPassword: 'password2',
        );
        const params2 = ChangePasswordParams(
          currentPassword: 'password1',
          newPassword: 'password2',
        );
        const params3 = ChangePasswordParams(
          currentPassword: 'password1',
          newPassword: 'password3',
        );

        // Assert
        expect(params1, equals(params2));
        expect(params1, isNot(equals(params3)));
      });

      test('should include all fields in props', () {
        // Arrange
        const params = ChangePasswordParams(
          currentPassword: 'current',
          newPassword: 'new',
        );

        // Assert
        expect(params.props, ['current', 'new']);
      });
    });
  });
}
