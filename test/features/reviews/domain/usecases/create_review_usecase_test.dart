import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/reviews/domain/entities/review_entity.dart';
import 'package:spo_kick/features/reviews/domain/repositories/review_repository.dart';
import 'package:spo_kick/features/reviews/domain/usecases/create_review_usecase.dart';

class MockReviewRepository extends Mock implements ReviewRepository {}

void main() {
  late CreateReviewUseCase useCase;
  late MockReviewRepository mockRepository;

  setUp(() {
    mockRepository = MockReviewRepository();
    useCase = CreateReviewUseCase(mockRepository);
  });

  group('CreateReviewUseCase', () {
    final tNow = DateTime(2026, 1, 7);
    final tReview = ReviewEntity(
      id: 'review-123',
      fieldId: 'field-123',
      userId: 'user-123',
      bookingId: 'booking-123',
      rating: 5,
      comment: 'Great field!',
      userName: 'John Doe',
      createdAt: tNow,
      updatedAt: tNow,
    );

    group('successful creation', () {
      test('should return review when creation succeeds', () async {
        // Arrange
        const params = CreateReviewParams(
          fieldId: 'field-123',
          userId: 'user-123',
          bookingId: 'booking-123',
          rating: 5,
          comment: 'Great field!',
        );

        when(
          () => mockRepository.createReview(
            fieldId: any(named: 'fieldId'),
            userId: any(named: 'userId'),
            bookingId: any(named: 'bookingId'),
            rating: any(named: 'rating'),
            comment: any(named: 'comment'),
          ),
        ).thenAnswer((_) async => Right(tReview));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result, equals(Right(tReview)));
      });

      test('should create review without comment', () async {
        // Arrange
        const params = CreateReviewParams(
          fieldId: 'field-123',
          userId: 'user-123',
          rating: 4,
        );

        when(
          () => mockRepository.createReview(
            fieldId: any(named: 'fieldId'),
            userId: any(named: 'userId'),
            bookingId: any(named: 'bookingId'),
            rating: any(named: 'rating'),
            comment: any(named: 'comment'),
          ),
        ).thenAnswer((_) async => Right(tReview));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
      });

      test('should create review with minimum rating', () async {
        // Arrange
        const params = CreateReviewParams(
          fieldId: 'field-123',
          userId: 'user-123',
          rating: 1,
        );

        when(
          () => mockRepository.createReview(
            fieldId: any(named: 'fieldId'),
            userId: any(named: 'userId'),
            bookingId: any(named: 'bookingId'),
            rating: any(named: 'rating'),
            comment: any(named: 'comment'),
          ),
        ).thenAnswer((_) async => Right(tReview));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
      });

      test('should create review with maximum rating', () async {
        // Arrange
        const params = CreateReviewParams(
          fieldId: 'field-123',
          userId: 'user-123',
          rating: 5,
        );

        when(
          () => mockRepository.createReview(
            fieldId: any(named: 'fieldId'),
            userId: any(named: 'userId'),
            bookingId: any(named: 'bookingId'),
            rating: any(named: 'rating'),
            comment: any(named: 'comment'),
          ),
        ).thenAnswer((_) async => Right(tReview));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
      });
    });

    group('validation failures', () {
      test('should return ValidationFailure for rating below 1', () async {
        // Arrange
        const params = CreateReviewParams(
          fieldId: 'field-123',
          userId: 'user-123',
          rating: 0,
        );

        // Act
        final result = await useCase(params);

        // Assert
        expect(
          result,
          equals(
            const Left(ValidationFailure('Rating must be between 1 and 5')),
          ),
        );
        verifyNever(
          () => mockRepository.createReview(
            fieldId: any(named: 'fieldId'),
            userId: any(named: 'userId'),
            bookingId: any(named: 'bookingId'),
            rating: any(named: 'rating'),
            comment: any(named: 'comment'),
          ),
        );
      });

      test('should return ValidationFailure for rating above 5', () async {
        // Arrange
        const params = CreateReviewParams(
          fieldId: 'field-123',
          userId: 'user-123',
          rating: 6,
        );

        // Act
        final result = await useCase(params);

        // Assert
        expect(
          result,
          equals(
            const Left(ValidationFailure('Rating must be between 1 and 5')),
          ),
        );
      });

      test(
        'should return ValidationFailure for comment exceeding 1000 chars',
        () async {
          // Arrange
          final longComment = 'a' * 1001;
          final params = CreateReviewParams(
            fieldId: 'field-123',
            userId: 'user-123',
            rating: 5,
            comment: longComment,
          );

          // Act
          final result = await useCase(params);

          // Assert
          expect(
            result,
            equals(
              const Left(
                ValidationFailure('Comment must not exceed 1000 characters'),
              ),
            ),
          );
        },
      );
    });

    group('repository failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const params = CreateReviewParams(
          fieldId: 'field-123',
          userId: 'user-123',
          rating: 5,
        );
        const tFailure = ServerFailure('Failed to create review');

        when(
          () => mockRepository.createReview(
            fieldId: any(named: 'fieldId'),
            userId: any(named: 'userId'),
            bookingId: any(named: 'bookingId'),
            rating: any(named: 'rating'),
            comment: any(named: 'comment'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test(
        'should return ValidationFailure when user already reviewed',
        () async {
          // Arrange
          const params = CreateReviewParams(
            fieldId: 'field-123',
            userId: 'user-123',
            rating: 5,
          );
          const tFailure = ValidationFailure(
            'User has already reviewed this field',
          );

          when(
            () => mockRepository.createReview(
              fieldId: any(named: 'fieldId'),
              userId: any(named: 'userId'),
              bookingId: any(named: 'bookingId'),
              rating: any(named: 'rating'),
              comment: any(named: 'comment'),
            ),
          ).thenAnswer((_) async => const Left(tFailure));

          // Act
          final result = await useCase(params);

          // Assert
          expect(result, equals(const Left(tFailure)));
        },
      );
    });
  });
}
