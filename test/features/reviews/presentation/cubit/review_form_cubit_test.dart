import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/review_form_cubit.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/review_form_state.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/reviews_cubit.dart';

class MockReviewsCubit extends Mock implements ReviewsCubit {}

void main() {
  late ReviewFormCubit cubit;
  late MockReviewsCubit mockReviewsCubit;

  setUp(() {
    mockReviewsCubit = MockReviewsCubit();
    cubit = ReviewFormCubit(
      reviewsCubit: mockReviewsCubit,
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
        reviewsCubit: mockReviewsCubit,
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
          reviewsCubit: mockReviewsCubit,
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
        when(
          () => mockReviewsCubit.createReview(
            fieldId: any(named: 'fieldId'),
            userId: any(named: 'userId'),
            bookingId: any(named: 'bookingId'),
            rating: any(named: 'rating'),
            comment: any(named: 'comment'),
          ),
        ).thenAnswer((_) async {});

        cubit.updateRating(5);
        cubit.updateComment('Great!');
        await cubit.submit(
          errorRating: 'Select valid rating',
          errorLogin: 'User must be logged in',
        );

        verify(
          () => mockReviewsCubit.createReview(
            fieldId: 'field-1',
            userId: 'user-1',
            bookingId: null,
            rating: 5,
            comment: 'Great!',
          ),
        ).called(1);
      });

      test('should call updateReview when editing', () async {
        when(
          () => mockReviewsCubit.updateReview(
            reviewId: any(named: 'reviewId'),
            rating: any(named: 'rating'),
            comment: any(named: 'comment'),
          ),
        ).thenAnswer((_) async {});

        final editCubit = ReviewFormCubit(
          reviewsCubit: mockReviewsCubit,
          fieldId: 'field-1',
          reviewId: 'review-1',
          initialRating: 3,
        );

        editCubit.updateRating(5);
        await editCubit.submit(
          errorRating: 'Select valid rating',
          errorLogin: 'User must be logged in',
        );

        verify(
          () => mockReviewsCubit.updateReview(
            reviewId: 'review-1',
            rating: 5,
            comment: null,
          ),
        ).called(1);

        editCubit.close();
      });
    });
  });
}
