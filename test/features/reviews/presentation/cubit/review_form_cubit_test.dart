import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/reviews/domain/entities/review_entity.dart';
import 'package:spo_kick/features/reviews/domain/usecases/create_review_usecase.dart';
import 'package:spo_kick/features/reviews/domain/usecases/update_review_usecase.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/review_form_cubit.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/review_form_state.dart';

class MockCreateReviewUseCase extends Mock implements CreateReviewUseCase {}

class MockUpdateReviewUseCase extends Mock implements UpdateReviewUseCase {}

void main() {
  late ReviewFormCubit cubit;
  late MockCreateReviewUseCase mockCreateReviewUseCase;
  late MockUpdateReviewUseCase mockUpdateReviewUseCase;

  setUpAll(() {
    registerFallbackValue(
      const CreateReviewParams(fieldId: '', userId: '', rating: 0),
    );
    registerFallbackValue(const UpdateReviewParams(reviewId: ''));
  });

  setUp(() {
    mockCreateReviewUseCase = MockCreateReviewUseCase();
    mockUpdateReviewUseCase = MockUpdateReviewUseCase();
    cubit = ReviewFormCubit(
      createReviewUseCase: mockCreateReviewUseCase,
      updateReviewUseCase: mockUpdateReviewUseCase,
      fieldId: 'field-1',
      userId: 'user-1',
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('ReviewFormCubit -', () {
    test('initial state should be ReviewFormInitial', () {
      expect(cubit.state, isA<ReviewFormInitial>());
      expect(cubit.rating, equals(0));
      expect(cubit.comment, equals(''));
      expect(cubit.isEditing, isFalse);
    });

    test('should initialize with existing values when editing', () {
      final editCubit = ReviewFormCubit(
        createReviewUseCase: mockCreateReviewUseCase,
        updateReviewUseCase: mockUpdateReviewUseCase,
        fieldId: 'field-1',
        reviewId: 'review-1',
        initialRating: 4,
        initialComment: 'Great field!',
      );

      expect(editCubit.rating, equals(4));
      expect(editCubit.comment, equals('Great field!'));
      expect(editCubit.isEditing, isTrue);

      editCubit.close();
    });

    group('updateRating -', () {
      test('should update rating and emit valid state', () {
        cubit.updateRating(5);

        expect(cubit.rating, equals(5));
        expect(cubit.state, isA<ReviewFormValid>());
      });

      test('should emit initial state when rating is 0', () {
        cubit.updateRating(0);

        expect(cubit.state, isA<ReviewFormInitial>());
      });
    });

    group('updateComment -', () {
      test('should update comment', () {
        cubit.updateComment('Nice field!');

        expect(cubit.comment, equals('Nice field!'));
      });
    });

    group('submit -', () {
      test('should emit error when rating is 0', () async {
        await cubit.submit(
          errorRating: 'Select valid rating',
          errorLogin: 'User must be logged in',
        );

        expect(cubit.state, isA<ReviewFormError>());
        expect((cubit.state as ReviewFormError).message, contains('rating'));
      });

      test('should emit error when no userId for new review', () async {
        final noUserCubit = ReviewFormCubit(
          createReviewUseCase: mockCreateReviewUseCase,
          updateReviewUseCase: mockUpdateReviewUseCase,
          fieldId: 'field-1',
        );
        noUserCubit.updateRating(4);

        await noUserCubit.submit(
          errorRating: 'Select valid rating',
          errorLogin: 'User must be logged in',
        );

        expect(noUserCubit.state, isA<ReviewFormError>());
        expect(
          (noUserCubit.state as ReviewFormError).message,
          contains('logged in'),
        );

        noUserCubit.close();
      });

      test('should call createReview for new review', () async {
        final now = DateTime.now();
        final mockReview = ReviewEntity(
          id: 'review-1',
          fieldId: 'field-1',
          userId: 'user-1',
          rating: 5,
          comment: 'Great!',
          createdAt: now,
          updatedAt: now,
        );

        when(
          () => mockCreateReviewUseCase(any()),
        ).thenAnswer((_) async => Right(mockReview));

        cubit.updateRating(5);
        cubit.updateComment('Great!');
        await cubit.submit(
          errorRating: 'Select valid rating',
          errorLogin: 'User must be logged in',
        );

        verify(() => mockCreateReviewUseCase(any())).called(1);

        expect(cubit.state, isA<ReviewFormSuccess>());
        expect((cubit.state as ReviewFormSuccess).isEdit, isFalse);
      });

      test('should call updateReview when editing', () async {
        final now = DateTime.now();
        final mockReview = ReviewEntity(
          id: 'review-1',
          fieldId: 'field-1',
          userId: 'user-1',
          rating: 5,
          createdAt: now,
          updatedAt: now,
        );

        when(
          () => mockUpdateReviewUseCase(any()),
        ).thenAnswer((_) async => Right(mockReview));

        final editCubit = ReviewFormCubit(
          createReviewUseCase: mockCreateReviewUseCase,
          updateReviewUseCase: mockUpdateReviewUseCase,
          fieldId: 'field-1',
          reviewId: 'review-1',
          initialRating: 3,
        );

        editCubit.updateRating(5);
        await editCubit.submit(
          errorRating: 'Select valid rating',
          errorLogin: 'User must be logged in',
        );

        verify(() => mockUpdateReviewUseCase(any())).called(1);

        expect(editCubit.state, isA<ReviewFormSuccess>());
        expect((editCubit.state as ReviewFormSuccess).isEdit, isTrue);

        editCubit.close();
      });

      test('should emit error when createReview fails', () async {
        when(() => mockCreateReviewUseCase(any())).thenAnswer(
          (_) async => const Left(ServerFailure('Failed to create review')),
        );

        cubit.updateRating(5);
        cubit.updateComment('Great!');
        await cubit.submit(
          errorRating: 'Select valid rating',
          errorLogin: 'User must be logged in',
        );

        expect(cubit.state, isA<ReviewFormError>());
        expect(
          (cubit.state as ReviewFormError).message,
          contains('Failed to create review'),
        );
      });

      test('should emit error when updateReview fails', () async {
        when(() => mockUpdateReviewUseCase(any())).thenAnswer(
          (_) async => const Left(ServerFailure('Failed to update review')),
        );

        final editCubit = ReviewFormCubit(
          createReviewUseCase: mockCreateReviewUseCase,
          updateReviewUseCase: mockUpdateReviewUseCase,
          fieldId: 'field-1',
          reviewId: 'review-1',
          initialRating: 3,
        );

        editCubit.updateRating(5);
        await editCubit.submit(
          errorRating: 'Select valid rating',
          errorLogin: 'User must be logged in',
        );

        expect(editCubit.state, isA<ReviewFormError>());
        expect(
          (editCubit.state as ReviewFormError).message,
          contains('Failed to update review'),
        );

        editCubit.close();
      });
    });
  });
}
