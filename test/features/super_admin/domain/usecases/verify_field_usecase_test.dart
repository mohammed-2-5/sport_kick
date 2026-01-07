import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/super_admin/domain/repositories/super_admin_repository.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/verify_field_usecase.dart';

class MockSuperAdminRepository extends Mock implements SuperAdminRepository {}

void main() {
  late VerifyFieldUseCase useCase;
  late MockSuperAdminRepository mockRepository;

  setUp(() {
    mockRepository = MockSuperAdminRepository();
    useCase = VerifyFieldUseCase(mockRepository);
  });

  group('VerifyFieldUseCase', () {
    const tFieldId = 'field-123';

    group('verify field', () {
      test('should return Right(void) when verification succeeds', () async {
        // Arrange
        when(
          () => mockRepository.verifyField(
            fieldId: any(named: 'fieldId'),
            isVerified: any(named: 'isVerified'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(fieldId: tFieldId, isVerified: true);

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.verifyField(fieldId: tFieldId, isVerified: true),
        ).called(1);
      });

      test('should verify field with isVerified true', () async {
        // Arrange
        when(
          () => mockRepository.verifyField(
            fieldId: any(named: 'fieldId'),
            isVerified: any(named: 'isVerified'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await useCase(fieldId: tFieldId, isVerified: true);

        // Assert
        verify(
          () => mockRepository.verifyField(fieldId: tFieldId, isVerified: true),
        ).called(1);
      });
    });

    group('unverify field', () {
      test('should return Right(void) when unverification succeeds', () async {
        // Arrange
        when(
          () => mockRepository.verifyField(
            fieldId: any(named: 'fieldId'),
            isVerified: any(named: 'isVerified'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(fieldId: tFieldId, isVerified: false);

        // Assert
        expect(result.isRight(), true);
        verify(
          () =>
              mockRepository.verifyField(fieldId: tFieldId, isVerified: false),
        ).called(1);
      });
    });

    group('failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to verify field');
        when(
          () => mockRepository.verifyField(
            fieldId: any(named: 'fieldId'),
            isVerified: any(named: 'isVerified'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(fieldId: tFieldId, isVerified: true);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ValidationFailure when field not found', () async {
        // Arrange
        const tFailure = ValidationFailure('Field not found');
        when(
          () => mockRepository.verifyField(
            fieldId: any(named: 'fieldId'),
            isVerified: any(named: 'isVerified'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(fieldId: 'invalid', isVerified: true);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return AuthFailure when not authorized', () async {
        // Arrange
        const tFailure = AuthFailure('Only super admin can verify fields');
        when(
          () => mockRepository.verifyField(
            fieldId: any(named: 'fieldId'),
            isVerified: any(named: 'isVerified'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(fieldId: tFieldId, isVerified: true);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });

    group('repository interaction', () {
      test('should call repository exactly once', () async {
        // Arrange
        when(
          () => mockRepository.verifyField(
            fieldId: any(named: 'fieldId'),
            isVerified: any(named: 'isVerified'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await useCase(fieldId: tFieldId, isVerified: true);

        // Assert
        verify(
          () => mockRepository.verifyField(fieldId: tFieldId, isVerified: true),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    });
  });
}
