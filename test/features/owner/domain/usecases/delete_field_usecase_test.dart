import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/owner/domain/repositories/owner_repository.dart';
import 'package:spo_kick/features/owner/domain/usecases/delete_field_usecase.dart';

class MockOwnerRepository extends Mock implements OwnerRepository {}

void main() {
  late DeleteFieldUseCase useCase;
  late MockOwnerRepository mockRepository;

  setUp(() {
    mockRepository = MockOwnerRepository();
    useCase = DeleteFieldUseCase(mockRepository);
  });

  group('DeleteFieldUseCase', () {
    const tFieldId = 'field-123';

    group('successful deletion', () {
      test('should return Right(void) when deletion succeeds', () async {
        // Arrange
        when(
          () => mockRepository.deleteField(any()),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(tFieldId);

        // Assert
        expect(result.isRight(), true);
        verify(() => mockRepository.deleteField(tFieldId)).called(1);
      });

      test('should call repository exactly once', () async {
        // Arrange
        when(
          () => mockRepository.deleteField(any()),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await useCase(tFieldId);

        // Assert
        verify(() => mockRepository.deleteField(tFieldId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should handle UUID format field IDs', () async {
        // Arrange
        const uuidFieldId = '550e8400-e29b-41d4-a716-446655440000';
        when(
          () => mockRepository.deleteField(any()),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(uuidFieldId);

        // Assert
        expect(result.isRight(), true);
        verify(() => mockRepository.deleteField(uuidFieldId)).called(1);
      });
    });

    group('failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to delete field');
        when(
          () => mockRepository.deleteField(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tFieldId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ValidationFailure when field not found', () async {
        // Arrange
        const tFailure = ValidationFailure('Field not found');
        when(
          () => mockRepository.deleteField(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase('non-existent-field');

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return AuthFailure when not authorized', () async {
        // Arrange
        const tFailure = AuthFailure('Not authorized to delete this field');
        when(
          () => mockRepository.deleteField(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tFieldId);

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
            () => mockRepository.deleteField(any()),
          ).thenAnswer((_) async => const Left(tFailure));

          // Act
          final result = await useCase(tFieldId);

          // Assert
          expect(result, equals(const Left(tFailure)));
        },
      );
    });
  });
}
