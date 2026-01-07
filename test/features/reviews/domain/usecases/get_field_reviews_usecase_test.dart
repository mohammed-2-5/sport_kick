import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/reviews/domain/entities/review_entity.dart';
import 'package:spo_kick/features/reviews/domain/repositories/review_repository.dart';
import 'package:spo_kick/features/reviews/domain/usecases/get_field_reviews_usecase.dart';

class MockReviewRepository extends Mock implements ReviewRepository {}

void main() {
  late GetFieldReviewsUseCase useCase;
  late MockReviewRepository mockRepository;

  setUp(() {
    mockRepository = MockReviewRepository();
    useCase = GetFieldReviewsUseCase(mockRepository);
  });

  group('GetFieldReviewsUseCase', () {
    final tNow = DateTime(2026, 1, 7);
    final tReviews = [
      ReviewEntity(
        id: 'review-1',
        fieldId: 'field-123',
        userId: 'user-1',
        rating: 5,
        comment: 'Excellent!',
        userName: 'John Doe',
        createdAt: tNow,
        updatedAt: tNow,
      ),
      ReviewEntity(
        id: 'review-2',
        fieldId: 'field-123',
        userId: 'user-2',
        rating: 4,
        comment: 'Good field',
        userName: 'Jane Smith',
        createdAt: tNow,
        updatedAt: tNow,
      ),
    ];

    group('successful retrieval', () {
      test('should return reviews when call succeeds', () async {
        // Arrange
        const params = GetFieldReviewsParams(fieldId: 'field-123');

        when(
          () => mockRepository.getFieldReviews(
            fieldId: any(named: 'fieldId'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          ),
        ).thenAnswer((_) async => Right(tReviews));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result, equals(Right(tReviews)));
      });

      test('should return empty list when no reviews exist', () async {
        // Arrange
        const params = GetFieldReviewsParams(fieldId: 'field-123');

        when(
          () => mockRepository.getFieldReviews(
            fieldId: any(named: 'fieldId'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          ),
        ).thenAnswer((_) async => const Right([]));

        // Act
        final result = await useCase(params);

        // Assert
        result.fold(
          (_) => fail('Should return Right'),
          (reviews) => expect(reviews, isEmpty),
        );
      });

      test('should use default pagination values', () async {
        // Arrange
        const params = GetFieldReviewsParams(fieldId: 'field-123');

        when(
          () => mockRepository.getFieldReviews(
            fieldId: any(named: 'fieldId'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          ),
        ).thenAnswer((_) async => Right(tReviews));

        // Act
        await useCase(params);

        // Assert
        verify(
          () => mockRepository.getFieldReviews(
            fieldId: 'field-123',
            limit: 20,
            offset: 0,
          ),
        ).called(1);
      });

      test('should support custom pagination', () async {
        // Arrange
        const params = GetFieldReviewsParams(
          fieldId: 'field-123',
          limit: 50,
          offset: 20,
        );

        when(
          () => mockRepository.getFieldReviews(
            fieldId: any(named: 'fieldId'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          ),
        ).thenAnswer((_) async => Right(tReviews));

        // Act
        await useCase(params);

        // Assert
        verify(
          () => mockRepository.getFieldReviews(
            fieldId: 'field-123',
            limit: 50,
            offset: 20,
          ),
        ).called(1);
      });
    });

    group('validation failures', () {
      test('should return ValidationFailure for limit below 1', () async {
        // Arrange
        const params = GetFieldReviewsParams(fieldId: 'field-123', limit: 0);

        // Act
        final result = await useCase(params);

        // Assert
        expect(
          result,
          equals(
            const Left(ValidationFailure('Limit must be between 1 and 100')),
          ),
        );
      });

      test('should return ValidationFailure for limit above 100', () async {
        // Arrange
        const params = GetFieldReviewsParams(fieldId: 'field-123', limit: 101);

        // Act
        final result = await useCase(params);

        // Assert
        expect(
          result,
          equals(
            const Left(ValidationFailure('Limit must be between 1 and 100')),
          ),
        );
      });

      test('should return ValidationFailure for negative offset', () async {
        // Arrange
        const params = GetFieldReviewsParams(fieldId: 'field-123', offset: -1);

        // Act
        final result = await useCase(params);

        // Assert
        expect(
          result,
          equals(const Left(ValidationFailure('Offset must be non-negative'))),
        );
      });
    });

    group('repository failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const params = GetFieldReviewsParams(fieldId: 'field-123');
        const tFailure = ServerFailure('Failed to fetch reviews');

        when(
          () => mockRepository.getFieldReviews(
            fieldId: any(named: 'fieldId'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return NetworkFailure on network error', () async {
        // Arrange
        const params = GetFieldReviewsParams(fieldId: 'field-123');
        const tFailure = NetworkFailure('No internet connection');

        when(
          () => mockRepository.getFieldReviews(
            fieldId: any(named: 'fieldId'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
