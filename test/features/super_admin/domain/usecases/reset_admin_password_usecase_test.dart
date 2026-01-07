import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/super_admin/domain/repositories/super_admin_repository.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/reset_admin_password_usecase.dart';

class MockSuperAdminRepository extends Mock implements SuperAdminRepository {}

void main() {
  late ResetAdminPasswordUseCase useCase;
  late MockSuperAdminRepository mockRepository;

  setUp(() {
    mockRepository = MockSuperAdminRepository();
    useCase = ResetAdminPasswordUseCase(mockRepository);
  });

  group('ResetAdminPasswordUseCase', () {
    const tAdminId = 'admin-123';
    const tNewPassword = 'newSecurePassword123!';

    group('successful reset', () {
      test('should return new password when reset succeeds', () async {
        // Arrange
        when(
          () =>
              mockRepository.resetAdminPassword(adminId: any(named: 'adminId')),
        ).thenAnswer((_) async => const Right(tNewPassword));

        // Act
        final result = await useCase(adminId: tAdminId);

        // Assert
        expect(result, equals(const Right(tNewPassword)));
        verify(
          () => mockRepository.resetAdminPassword(adminId: tAdminId),
        ).called(1);
      });

      test('should call repository exactly once', () async {
        // Arrange
        when(
          () =>
              mockRepository.resetAdminPassword(adminId: any(named: 'adminId')),
        ).thenAnswer((_) async => const Right(tNewPassword));

        // Act
        await useCase(adminId: tAdminId);

        // Assert
        verify(
          () => mockRepository.resetAdminPassword(adminId: tAdminId),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    });

    group('validation', () {
      test('should return ValidationFailure for empty adminId', () async {
        // Act
        final result = await useCase(adminId: '');

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<ValidationFailure>()),
          (_) => fail('Should return Left'),
        );
        verifyNever(
          () =>
              mockRepository.resetAdminPassword(adminId: any(named: 'adminId')),
        );
      });

      test('should return ValidationFailure for whitespace adminId', () async {
        // Act
        final result = await useCase(adminId: '   ');

        // Assert
        expect(result.isLeft(), true);
        verifyNever(
          () =>
              mockRepository.resetAdminPassword(adminId: any(named: 'adminId')),
        );
      });
    });

    group('failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to reset password');
        when(
          () =>
              mockRepository.resetAdminPassword(adminId: any(named: 'adminId')),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(adminId: tAdminId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ValidationFailure when admin not found', () async {
        // Arrange
        const tFailure = ValidationFailure('Admin not found');
        when(
          () =>
              mockRepository.resetAdminPassword(adminId: any(named: 'adminId')),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(adminId: 'invalid');

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return AuthFailure when not authorized', () async {
        // Arrange
        const tFailure = AuthFailure(
          'Only super admin can reset admin passwords',
        );
        when(
          () =>
              mockRepository.resetAdminPassword(adminId: any(named: 'adminId')),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(adminId: tAdminId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
