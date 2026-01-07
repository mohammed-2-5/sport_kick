import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/business_hours/domain/repositories/business_hours_repository.dart';
import 'package:spo_kick/features/business_hours/domain/usecases/is_field_currently_open_usecase.dart';

class MockBusinessHoursRepository extends Mock
    implements BusinessHoursRepository {}

void main() {
  late IsFieldCurrentlyOpenUseCase useCase;
  late MockBusinessHoursRepository mockRepository;

  setUp(() {
    mockRepository = MockBusinessHoursRepository();
    useCase = IsFieldCurrentlyOpenUseCase(mockRepository);
  });

  group('IsFieldCurrentlyOpenUseCase', () {
    const tFieldId = 'field-123';

    group('successful check', () {
      test('should return true when field is currently open', () async {
        // Arrange
        when(
          () => mockRepository.isFieldCurrentlyOpen(any()),
        ).thenAnswer((_) async => const Right(true));

        // Act
        final result = await useCase(tFieldId);

        // Assert
        expect(result, equals(const Right(true)));
        verify(() => mockRepository.isFieldCurrentlyOpen(tFieldId)).called(1);
      });

      test('should return false when field is currently closed', () async {
        // Arrange
        when(
          () => mockRepository.isFieldCurrentlyOpen(any()),
        ).thenAnswer((_) async => const Right(false));

        // Act
        final result = await useCase(tFieldId);

        // Assert
        expect(result, equals(const Right(false)));
      });

      test('should call repository exactly once', () async {
        // Arrange
        when(
          () => mockRepository.isFieldCurrentlyOpen(any()),
        ).thenAnswer((_) async => const Right(true));

        // Act
        await useCase(tFieldId);

        // Assert
        verify(() => mockRepository.isFieldCurrentlyOpen(tFieldId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should handle multiple field checks', () async {
        final fieldIds = ['field-1', 'field-2', 'field-3'];

        for (final fieldId in fieldIds) {
          // Arrange
          when(
            () => mockRepository.isFieldCurrentlyOpen(any()),
          ).thenAnswer((_) async => const Right(true));

          // Act
          final result = await useCase(fieldId);

          // Assert
          expect(result.isRight(), true);
        }
      });
    });

    group('validation failures', () {
      test('should return ValidationFailure when field ID is empty', () async {
        // Act
        final result = await useCase('');

        // Assert
        expect(
          result,
          equals(const Left(ValidationFailure('Field ID cannot be empty'))),
        );
        verifyNever(() => mockRepository.isFieldCurrentlyOpen(any()));
      });
    });

    group('repository failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to check if field is open');
        when(
          () => mockRepository.isFieldCurrentlyOpen(any()),
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
          () => mockRepository.isFieldCurrentlyOpen(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase('non-existent-field');

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return NetworkFailure on network error', () async {
        // Arrange
        const tFailure = NetworkFailure('No internet connection');
        when(
          () => mockRepository.isFieldCurrentlyOpen(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tFieldId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test(
        'should return ValidationFailure when no business hours set',
        () async {
          // Arrange
          const tFailure = ValidationFailure(
            'No business hours configured for this field',
          );
          when(
            () => mockRepository.isFieldCurrentlyOpen(any()),
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
