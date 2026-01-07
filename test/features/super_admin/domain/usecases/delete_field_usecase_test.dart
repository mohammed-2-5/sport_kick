import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/super_admin/domain/repositories/super_admin_repository.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/delete_field_usecase.dart';

class MockSuperAdminRepository extends Mock implements SuperAdminRepository {}

void main() {
  late DeleteFieldUseCase useCase;
  late MockSuperAdminRepository mockRepository;

  setUp(() {
    mockRepository = MockSuperAdminRepository();
    useCase = DeleteFieldUseCase(mockRepository);
  });

  group('DeleteFieldUseCase', () {
    const tFieldId = 'field-123';

    group('soft delete', () {
      test('should return Right(void) when soft delete succeeds', () async {
        // Arrange
        when(
          () => mockRepository.deleteField(
            fieldId: any(named: 'fieldId'),
            hardDelete: any(named: 'hardDelete'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(
          fieldId: tFieldId,
          deleteType: DeleteType.soft,
        );

        // Assert
        expect(result.isRight(), true);
        verify(
          () =>
              mockRepository.deleteField(fieldId: tFieldId, hardDelete: false),
        ).called(1);
      });
    });

    group('hard delete', () {
      test('should return Right(void) when hard delete succeeds', () async {
        // Arrange
        when(
          () => mockRepository.deleteField(
            fieldId: any(named: 'fieldId'),
            hardDelete: any(named: 'hardDelete'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(
          fieldId: tFieldId,
          deleteType: DeleteType.hard,
        );

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.deleteField(fieldId: tFieldId, hardDelete: true),
        ).called(1);
      });
    });

    group('failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to delete field');
        when(
          () => mockRepository.deleteField(
            fieldId: any(named: 'fieldId'),
            hardDelete: any(named: 'hardDelete'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(
          fieldId: tFieldId,
          deleteType: DeleteType.soft,
        );

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ValidationFailure when field not found', () async {
        // Arrange
        const tFailure = ValidationFailure('Field not found');
        when(
          () => mockRepository.deleteField(
            fieldId: any(named: 'fieldId'),
            hardDelete: any(named: 'hardDelete'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(
          fieldId: 'invalid',
          deleteType: DeleteType.soft,
        );

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test(
        'should return ValidationFailure when field has pending bookings',
        () async {
          // Arrange
          const tFailure = ValidationFailure(
            'Cannot delete field with pending bookings',
          );
          when(
            () => mockRepository.deleteField(
              fieldId: any(named: 'fieldId'),
              hardDelete: any(named: 'hardDelete'),
            ),
          ).thenAnswer((_) async => const Left(tFailure));

          // Act
          final result = await useCase(
            fieldId: tFieldId,
            deleteType: DeleteType.hard,
          );

          // Assert
          expect(result, equals(const Left(tFailure)));
        },
      );

      test('should return AuthFailure when not authorized', () async {
        // Arrange
        const tFailure = AuthFailure('Only super admin can delete fields');
        when(
          () => mockRepository.deleteField(
            fieldId: any(named: 'fieldId'),
            hardDelete: any(named: 'hardDelete'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(
          fieldId: tFieldId,
          deleteType: DeleteType.soft,
        );

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
