import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/reviews/domain/entities/review_entity.dart';
import 'package:spo_kick/features/reviews/domain/usecases/can_user_review_field_usecase.dart';
import 'package:spo_kick/features/reviews/domain/usecases/create_review_usecase.dart';
import 'package:spo_kick/features/reviews/domain/usecases/delete_review_usecase.dart';
import 'package:spo_kick/features/reviews/domain/usecases/get_field_reviews_usecase.dart';
import 'package:spo_kick/features/reviews/domain/usecases/update_review_usecase.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/reviews_cubit.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/reviews_state.dart';

// Mock Use Cases
class MockCreateReviewUseCase extends Mock implements CreateReviewUseCase {}

class MockGetFieldReviewsUseCase extends Mock
    implements GetFieldReviewsUseCase {}

class MockUpdateReviewUseCase extends Mock implements UpdateReviewUseCase {}

class MockDeleteReviewUseCase extends Mock implements DeleteReviewUseCase {}

class MockCanUserReviewFieldUseCase extends Mock
    implements CanUserReviewFieldUseCase {}

// Register fallback values
class FakeCreateReviewParams extends Fake implements CreateReviewParams {}

class FakeGetFieldReviewsParams extends Fake implements GetFieldReviewsParams {}

class FakeUpdateReviewParams extends Fake implements UpdateReviewParams {}

class FakeCanUserReviewFieldParams extends Fake
    implements CanUserReviewFieldParams {}

void main() {
  late ReviewsCubit cubit;
  late MockCreateReviewUseCase mockCreate;
  late MockGetFieldReviewsUseCase mockGetReviews;
  late MockUpdateReviewUseCase mockUpdate;
  late MockDeleteReviewUseCase mockDelete;
  late MockCanUserReviewFieldUseCase mockCanReview;

  // Test data
  final testReview = ReviewEntity(
    id: 'review-1',
    fieldId: 'field-1',
    userId: 'user-1',
    rating: 5,
    comment: 'Great field!',
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  setUpAll(() {
    registerFallbackValue(FakeCreateReviewParams());
    registerFallbackValue(FakeGetFieldReviewsParams());
    registerFallbackValue(FakeUpdateReviewParams());
    registerFallbackValue(FakeCanUserReviewFieldParams());
  });

  setUp(() {
    mockCreate = MockCreateReviewUseCase();
    mockGetReviews = MockGetFieldReviewsUseCase();
    mockUpdate = MockUpdateReviewUseCase();
    mockDelete = MockDeleteReviewUseCase();
    mockCanReview = MockCanUserReviewFieldUseCase();

    cubit = ReviewsCubit(
      createReviewUseCase: mockCreate,
      getFieldReviewsUseCase: mockGetReviews,
      updateReviewUseCase: mockUpdate,
      deleteReviewUseCase: mockDelete,
      canUserReviewFieldUseCase: mockCanReview,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('ReviewsCubit', () {
    test('initial state is ReviewsInitial', () {
      expect(cubit.state, const ReviewsInitial());
    });
  });

  group('loadFieldReviews', () {
    blocTest<ReviewsCubit, ReviewsState>(
      'emits [Loading, Loaded] when successful',
      build: () {
        when(
          () => mockGetReviews(any()),
        ).thenAnswer((_) async => Right([testReview]));
        return cubit;
      },
      act: (cubit) => cubit.loadFieldReviews(fieldId: 'field-1'),
      expect: () => [
        const ReviewsLoading(),
        isA<ReviewsLoaded>()
            .having((s) => s.reviews.length, 'reviews', 1)
            .having((s) => s.reviews.first.rating, 'rating', 5),
      ],
    );

    blocTest<ReviewsCubit, ReviewsState>(
      'emits [Loading, Error] on failure',
      build: () {
        when(
          () => mockGetReviews(any()),
        ).thenAnswer((_) async => const Left(ServerFailure('Failed to load')));
        return cubit;
      },
      act: (cubit) => cubit.loadFieldReviews(fieldId: 'field-1'),
      expect: () => [
        const ReviewsLoading(),
        isA<ReviewsError>().having(
          (s) => s.message,
          'message',
          'Failed to load',
        ),
      ],
    );
  });

  group('createReview', () {
    blocTest<ReviewsCubit, ReviewsState>(
      'emits [Creating, Created] when successful',
      build: () {
        when(
          () => mockCreate(any()),
        ).thenAnswer((_) async => Right(testReview));
        return cubit;
      },
      act: (cubit) => cubit.createReview(
        fieldId: 'field-1',
        userId: 'user-1',
        rating: 5,
        comment: 'Great!',
      ),
      expect: () => [
        const ReviewCreating(),
        isA<ReviewCreated>().having((s) => s.review.id, 'reviewId', 'review-1'),
      ],
    );

    blocTest<ReviewsCubit, ReviewsState>(
      'emits [Creating, Error] when fails',
      build: () {
        when(
          () => mockCreate(any()),
        ).thenAnswer((_) async => const Left(ServerFailure('Create failed')));
        return cubit;
      },
      act: (cubit) =>
          cubit.createReview(fieldId: 'field-1', userId: 'user-1', rating: 4),
      expect: () => [
        const ReviewCreating(),
        isA<ReviewsError>().having(
          (s) => s.message,
          'message',
          'Create failed',
        ),
      ],
    );
  });

  group('updateReview', () {
    final updatedReview = ReviewEntity(
      id: 'review-1',
      fieldId: 'field-1',
      userId: 'user-1',
      rating: 4,
      comment: 'Updated comment',
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 2),
    );

    blocTest<ReviewsCubit, ReviewsState>(
      'emits [Updating, Updated] when successful',
      build: () {
        when(
          () => mockUpdate(any()),
        ).thenAnswer((_) async => Right(updatedReview));
        return cubit;
      },
      act: (cubit) => cubit.updateReview(
        reviewId: 'review-1',
        rating: 4,
        comment: 'Updated comment',
      ),
      expect: () => [
        const ReviewUpdating(),
        isA<ReviewUpdated>().having((s) => s.review.rating, 'rating', 4),
      ],
    );

    blocTest<ReviewsCubit, ReviewsState>(
      'emits [Updating, Error] when fails',
      build: () {
        when(
          () => mockUpdate(any()),
        ).thenAnswer((_) async => const Left(ServerFailure('Update failed')));
        return cubit;
      },
      act: (cubit) => cubit.updateReview(reviewId: 'review-1', rating: 3),
      expect: () => [
        const ReviewUpdating(),
        isA<ReviewsError>().having(
          (s) => s.message,
          'message',
          'Update failed',
        ),
      ],
    );
  });

  group('deleteReview', () {
    blocTest<ReviewsCubit, ReviewsState>(
      'emits [Deleting, Deleted] when successful',
      build: () {
        when(
          () => mockDelete(any()),
        ).thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.deleteReview('review-1'),
      expect: () => [const ReviewDeleting(), const ReviewDeleted()],
    );

    blocTest<ReviewsCubit, ReviewsState>(
      'emits [Deleting, Error] when fails',
      build: () {
        when(
          () => mockDelete(any()),
        ).thenAnswer((_) async => const Left(ServerFailure('Delete failed')));
        return cubit;
      },
      act: (cubit) => cubit.deleteReview('review-1'),
      expect: () => [
        const ReviewDeleting(),
        isA<ReviewsError>().having(
          (s) => s.message,
          'message',
          'Delete failed',
        ),
      ],
    );
  });

  group('checkReviewEligibility', () {
    blocTest<ReviewsCubit, ReviewsState>(
      'emits [Checking, Checked(true)] when eligible',
      build: () {
        when(
          () => mockCanReview(any()),
        ).thenAnswer((_) async => const Right(true));
        return cubit;
      },
      act: (cubit) => cubit.checkReviewEligibility(
        userId: 'user-1',
        fieldId: 'field-1',
        bookingId: 'booking-1',
      ),
      expect: () => [
        const ReviewEligibilityChecking(),
        isA<ReviewEligibilityChecked>().having(
          (s) => s.canReview,
          'canReview',
          true,
        ),
      ],
    );

    blocTest<ReviewsCubit, ReviewsState>(
      'emits [Checking, Checked(false)] when not eligible',
      build: () {
        when(
          () => mockCanReview(any()),
        ).thenAnswer((_) async => const Right(false));
        return cubit;
      },
      act: (cubit) => cubit.checkReviewEligibility(
        userId: 'user-1',
        fieldId: 'field-1',
        bookingId: 'booking-1',
      ),
      expect: () => [
        const ReviewEligibilityChecking(),
        isA<ReviewEligibilityChecked>().having(
          (s) => s.canReview,
          'canReview',
          false,
        ),
      ],
    );
  });

  group('reset', () {
    blocTest<ReviewsCubit, ReviewsState>(
      'resets to initial state',
      build: () => cubit,
      seed: () =>
          ReviewsLoaded(reviews: [testReview], hasMore: false, totalCount: 1),
      act: (cubit) => cubit.reset(),
      expect: () => [const ReviewsInitial()],
    );
  });
}
