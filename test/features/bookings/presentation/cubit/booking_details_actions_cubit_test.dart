import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_details_actions_cubit.dart';

void main() {
  late BookingDetailsActionsCubit cubit;

  setUp(() {
    cubit = BookingDetailsActionsCubit();
  });

  tearDown(() {
    cubit.close();
  });

  group('BookingDetailsActionsCubit -', () {
    test('initial state should be BookingDetailsActionsInitial', () {
      expect(cubit.state, equals(const BookingDetailsActionsInitial()));
    });

    group('showCancelDialog -', () {
      blocTest<BookingDetailsActionsCubit, BookingDetailsActionsState>(
        'should emit CancelDialogOpen when called',
        build: () => cubit,
        act: (cubit) => cubit.showCancelDialog(),
        expect: () => [const BookingDetailsActionsCancelDialogOpen()],
      );
    });

    group('hideCancelDialog -', () {
      blocTest<BookingDetailsActionsCubit, BookingDetailsActionsState>(
        'should emit Initial when hiding dialog',
        build: () => cubit,
        seed: () => const BookingDetailsActionsCancelDialogOpen(),
        act: (cubit) => cubit.hideCancelDialog(),
        expect: () => [const BookingDetailsActionsInitial()],
      );
    });

    group('clearError -', () {
      blocTest<BookingDetailsActionsCubit, BookingDetailsActionsState>(
        'should emit Initial when clearing error',
        build: () => cubit,
        seed: () => const BookingDetailsActionsError('Some error'),
        act: (cubit) => cubit.clearError(),
        expect: () => [const BookingDetailsActionsInitial()],
      );

      blocTest<BookingDetailsActionsCubit, BookingDetailsActionsState>(
        'should emit Initial even from Loading state',
        build: () => cubit,
        seed: () => const BookingDetailsActionsLoading(),
        act: (cubit) => cubit.clearError(),
        expect: () => [const BookingDetailsActionsInitial()],
      );
    });

    group('dialog flow -', () {
      blocTest<BookingDetailsActionsCubit, BookingDetailsActionsState>(
        'should handle show then hide dialog flow',
        build: () => cubit,
        act: (cubit) {
          cubit.showCancelDialog();
          cubit.hideCancelDialog();
        },
        expect: () => [
          const BookingDetailsActionsCancelDialogOpen(),
          const BookingDetailsActionsInitial(),
        ],
      );

      blocTest<BookingDetailsActionsCubit, BookingDetailsActionsState>(
        'should allow showing dialog multiple times',
        build: () => cubit,
        act: (cubit) {
          cubit.showCancelDialog();
          cubit.hideCancelDialog();
          cubit.showCancelDialog();
        },
        expect: () => [
          const BookingDetailsActionsCancelDialogOpen(),
          const BookingDetailsActionsInitial(),
          const BookingDetailsActionsCancelDialogOpen(),
        ],
      );
    });
  });

  group('BookingDetailsActionsState -', () {
    group('BookingDetailsActionsInitial -', () {
      test('props should be empty', () {
        const state = BookingDetailsActionsInitial();
        expect(state.props, isEmpty);
      });

      test('equality works correctly', () {
        const state1 = BookingDetailsActionsInitial();
        const state2 = BookingDetailsActionsInitial();
        expect(state1, equals(state2));
      });
    });

    group('BookingDetailsActionsLoading -', () {
      test('props should be empty', () {
        const state = BookingDetailsActionsLoading();
        expect(state.props, isEmpty);
      });
    });

    group('BookingDetailsActionsCancelDialogOpen -', () {
      test('props should be empty', () {
        const state = BookingDetailsActionsCancelDialogOpen();
        expect(state.props, isEmpty);
      });

      test('equality works correctly', () {
        const state1 = BookingDetailsActionsCancelDialogOpen();
        const state2 = BookingDetailsActionsCancelDialogOpen();
        expect(state1, equals(state2));
      });
    });

    group('BookingDetailsActionsError -', () {
      test('props should include message', () {
        const error1 = BookingDetailsActionsError('Error 1');
        const error2 = BookingDetailsActionsError('Error 1');
        const error3 = BookingDetailsActionsError('Error 2');

        expect(error1, equals(error2));
        expect(error1, isNot(equals(error3)));
      });

      test('should store error message', () {
        const error = BookingDetailsActionsError('Test error message');
        expect(error.message, equals('Test error message'));
      });
    });
  });
}
