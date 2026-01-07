import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/business_hours/domain/repositories/business_hours_repository.dart';
import 'package:spo_kick/features/business_hours/domain/usecases/initialize_default_business_hours_usecase.dart';

class MockBusinessHoursRepository extends Mock
    implements BusinessHoursRepository {}

void main() {
  late InitializeDefaultBusinessHoursUseCase useCase;
  late MockBusinessHoursRepository mockRepository;

  setUp(() {
    mockRepository = MockBusinessHoursRepository();
    useCase = InitializeDefaultBusinessHoursUseCase(mockRepository);
  });

  group('InitializeDefaultBusinessHoursUseCase', () {
    const tFieldId = 'field-123';

    group('successful initialization', () {
      test('should return Right(void) when initialization succeeds', () async {
        // Arrange
        when(
          () => mockRepository.initializeDefaultBusinessHours(any()),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(tFieldId);

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.initializeDefaultBusinessHours(tFieldId),
        ).called(1);
      });

      test('should call repository exactly once', () async {
        // Arrange
        when(
          () => mockRepository.initializeDefaultBusinessHours(any()),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await useCase(tFieldId);

        // Assert
        verify(
          () => mockRepository.initializeDefaultBusinessHours(tFieldId),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should handle UUID format field IDs', () async {
        // Arrange
        const uuidFieldId = '550e8400-e29b-41d4-a716-446655440000';
        when(
          () => mockRepository.initializeDefaultBusinessHours(any()),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(uuidFieldId);

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.initializeDefaultBusinessHours(uuidFieldId),
        ).called(1);
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
        verifyNever(() => mockRepository.initializeDefaultBusinessHours(any()));
      });
    });

    group('repository failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to initialize business hours');
        when(
          () => mockRepository.initializeDefaultBusinessHours(any()),
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
          () => mockRepository.initializeDefaultBusinessHours(any()),
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
          () => mockRepository.initializeDefaultBusinessHours(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tFieldId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ServerFailure when hours already exist', () async {
        // Arrange
        const tFailure = ServerFailure(
          'Business hours already exist for this field',
        );
        when(
          () => mockRepository.initializeDefaultBusinessHours(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tFieldId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
