import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/bookings/domain/entities/payment_status.dart';
import 'package:spo_kick/features/owner/domain/usecases/approve_booking_usecase.dart';
import 'package:spo_kick/features/owner/domain/usecases/get_owner_bookings_usecase.dart';
import 'package:spo_kick/features/owner/domain/usecases/reject_booking_usecase.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_bookings/owner_bookings_approval_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_bookings/owner_bookings_approval_state.dart';

// Mock Classes
class MockGetOwnerBookingsUseCase extends Mock
    implements GetOwnerBookingsUseCase {}

class MockApproveBookingUseCase extends Mock implements ApproveBookingUseCase {}

class MockRejectBookingUseCase extends Mock implements RejectBookingUseCase {}

void main() {
  late OwnerBookingsApprovalCubit cubit;
  late MockGetOwnerBookingsUseCase mockGetBookingsUseCase;
  late MockApproveBookingUseCase mockApproveUseCase;
  late MockRejectBookingUseCase mockRejectUseCase;

  // Test data
  final now = DateTime.now();
  const tOwnerId = 'owner-123';
  const tBookingId = 'booking-456';
  late List<BookingEntity> tBookings;

  setUp(() {
    mockGetBookingsUseCase = MockGetOwnerBookingsUseCase();
    mockApproveUseCase = MockApproveBookingUseCase();
    mockRejectUseCase = MockRejectBookingUseCase();

    tBookings = [
      BookingEntity(
        id: 'booking-1',
        userId: 'user-1',
        fieldId: 'field-1',
        date: now.add(const Duration(days: 1)),
        startTime: '14:00',
        endTime: '16:00',
        status: BookingStatus.pending,
        totalPrice: 300.0,
        currency: 'EGP',
        fieldName: 'Al-Ahly Stadium',
        userName: 'Ahmed Ali',
        createdAt: now,
        paymentStatus: PaymentStatus.pending,
      ),
      BookingEntity(
        id: 'booking-2',
        userId: 'user-2',
        fieldId: 'field-1',
        date: now.add(const Duration(days: 2)),
        startTime: '10:00',
        endTime: '12:00',
        status: BookingStatus.pending,
        totalPrice: 300.0,
        currency: 'EGP',
        fieldName: 'Al-Ahly Stadium',
        userName: 'Mohamed Hassan',
        createdAt: now,
        paymentStatus: PaymentStatus.uploaded,
      ),
      BookingEntity(
        id: 'booking-3',
        userId: 'user-3',
        fieldId: 'field-2',
        date: now.add(const Duration(days: 3)),
        startTime: '18:00',
        endTime: '20:00',
        status: BookingStatus.confirmed,
        totalPrice: 400.0,
        currency: 'EGP',
        fieldName: 'Zamalek Stadium',
        userName: 'Mahmoud Salem',
        createdAt: now,
        paymentStatus: PaymentStatus.verified,
      ),
    ];

    cubit = OwnerBookingsApprovalCubit(
      getOwnerBookingsUseCase: mockGetBookingsUseCase,
      approveBookingUseCase: mockApproveUseCase,
      rejectBookingUseCase: mockRejectUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('OwnerBookingsApprovalCubit -', () {
    test('initial state should be OwnerBookingsApprovalInitial', () {
      expect(cubit.state, equals(const OwnerBookingsApprovalInitial()));
    });

    group('loadOwnerBookings -', () {
      blocTest<OwnerBookingsApprovalCubit, OwnerBookingsApprovalState>(
        'should emit [Loading, Loaded] when successful',
        build: () {
          when(
            () => mockGetBookingsUseCase(ownerId: tOwnerId, status: null),
          ).thenAnswer((_) async => Right(tBookings));
          return cubit;
        },
        act: (cubit) => cubit.loadOwnerBookings(ownerId: tOwnerId),
        expect: () => [
          const OwnerBookingsApprovalLoading(message: 'Loading bookings...'),
          OwnerBookingsLoaded(tBookings),
        ],
        verify: (_) {
          verify(
            () => mockGetBookingsUseCase(ownerId: tOwnerId, status: null),
          ).called(1);
        },
      );

      blocTest<OwnerBookingsApprovalCubit, OwnerBookingsApprovalState>(
        'should emit [Loading, Loaded] with status filter',
        build: () {
          when(
            () => mockGetBookingsUseCase(ownerId: tOwnerId, status: 'pending'),
          ).thenAnswer((_) async => Right([tBookings.first]));
          return cubit;
        },
        act: (cubit) =>
            cubit.loadOwnerBookings(ownerId: tOwnerId, status: 'pending'),
        expect: () => [
          const OwnerBookingsApprovalLoading(message: 'Loading bookings...'),
          OwnerBookingsLoaded([tBookings.first]),
        ],
      );

      blocTest<OwnerBookingsApprovalCubit, OwnerBookingsApprovalState>(
        'should emit [Loading, Loaded] with empty list',
        build: () {
          when(
            () => mockGetBookingsUseCase(ownerId: tOwnerId, status: null),
          ).thenAnswer((_) async => const Right([]));
          return cubit;
        },
        act: (cubit) => cubit.loadOwnerBookings(ownerId: tOwnerId),
        expect: () => [
          const OwnerBookingsApprovalLoading(message: 'Loading bookings...'),
          const OwnerBookingsLoaded([]),
        ],
      );

      blocTest<OwnerBookingsApprovalCubit, OwnerBookingsApprovalState>(
        'should emit [Loading, Error] when failure occurs',
        build: () {
          when(
            () => mockGetBookingsUseCase(ownerId: tOwnerId, status: null),
          ).thenAnswer(
            (_) async => const Left(ServerFailure('Failed to load bookings')),
          );
          return cubit;
        },
        act: (cubit) => cubit.loadOwnerBookings(ownerId: tOwnerId),
        expect: () => [
          const OwnerBookingsApprovalLoading(message: 'Loading bookings...'),
          const OwnerBookingsApprovalError('Failed to load bookings'),
        ],
      );

      blocTest<OwnerBookingsApprovalCubit, OwnerBookingsApprovalState>(
        'should emit Error on network failure',
        build: () {
          when(
            () => mockGetBookingsUseCase(ownerId: tOwnerId, status: null),
          ).thenAnswer(
            (_) async => const Left(NetworkFailure('No internet connection')),
          );
          return cubit;
        },
        act: (cubit) => cubit.loadOwnerBookings(ownerId: tOwnerId),
        expect: () => [
          const OwnerBookingsApprovalLoading(message: 'Loading bookings...'),
          const OwnerBookingsApprovalError('No internet connection'),
        ],
      );
    });

    group('approveBooking -', () {
      blocTest<OwnerBookingsApprovalCubit, OwnerBookingsApprovalState>(
        'should emit [Loading, Approved] when successful',
        build: () {
          when(
            () => mockApproveUseCase(bookingId: tBookingId),
          ).thenAnswer((_) async => const Right(null));
          return cubit;
        },
        act: (cubit) => cubit.approveBooking(tBookingId),
        expect: () => [
          const OwnerBookingsApprovalLoading(message: 'Approving booking...'),
          const BookingApproved(tBookingId),
        ],
        verify: (_) {
          verify(() => mockApproveUseCase(bookingId: tBookingId)).called(1);
        },
      );

      blocTest<OwnerBookingsApprovalCubit, OwnerBookingsApprovalState>(
        'should emit [Loading, Error] when approval fails',
        build: () {
          when(() => mockApproveUseCase(bookingId: tBookingId)).thenAnswer(
            (_) async => const Left(ServerFailure('Booking already processed')),
          );
          return cubit;
        },
        act: (cubit) => cubit.approveBooking(tBookingId),
        expect: () => [
          const OwnerBookingsApprovalLoading(message: 'Approving booking...'),
          const OwnerBookingsApprovalError('Booking already processed'),
        ],
      );

      blocTest<OwnerBookingsApprovalCubit, OwnerBookingsApprovalState>(
        'should emit Error on authorization failure',
        build: () {
          when(() => mockApproveUseCase(bookingId: tBookingId)).thenAnswer(
            (_) async => const Left(
              AuthFailure('You are not authorized to approve this booking'),
            ),
          );
          return cubit;
        },
        act: (cubit) => cubit.approveBooking(tBookingId),
        expect: () => [
          const OwnerBookingsApprovalLoading(message: 'Approving booking...'),
          const OwnerBookingsApprovalError(
            'You are not authorized to approve this booking',
          ),
        ],
      );
    });

    group('rejectBooking -', () {
      const tReason = 'Field is under maintenance';

      blocTest<OwnerBookingsApprovalCubit, OwnerBookingsApprovalState>(
        'should emit [Loading, Rejected] when successful',
        build: () {
          when(
            () => mockRejectUseCase(bookingId: tBookingId, reason: tReason),
          ).thenAnswer((_) async => const Right(null));
          return cubit;
        },
        act: (cubit) => cubit.rejectBooking(tBookingId, tReason),
        expect: () => [
          const OwnerBookingsApprovalLoading(message: 'Rejecting booking...'),
          const BookingRejected(tBookingId, tReason),
        ],
        verify: (_) {
          verify(
            () => mockRejectUseCase(bookingId: tBookingId, reason: tReason),
          ).called(1);
        },
      );

      blocTest<OwnerBookingsApprovalCubit, OwnerBookingsApprovalState>(
        'should emit [Loading, Error] when rejection fails',
        build: () {
          when(
            () => mockRejectUseCase(bookingId: tBookingId, reason: tReason),
          ).thenAnswer(
            (_) async => const Left(ServerFailure('Failed to reject booking')),
          );
          return cubit;
        },
        act: (cubit) => cubit.rejectBooking(tBookingId, tReason),
        expect: () => [
          const OwnerBookingsApprovalLoading(message: 'Rejecting booking...'),
          const OwnerBookingsApprovalError('Failed to reject booking'),
        ],
      );

      blocTest<OwnerBookingsApprovalCubit, OwnerBookingsApprovalState>(
        'should handle empty reason',
        build: () {
          when(
            () => mockRejectUseCase(bookingId: tBookingId, reason: ''),
          ).thenAnswer((_) async => const Right(null));
          return cubit;
        },
        act: (cubit) => cubit.rejectBooking(tBookingId, ''),
        expect: () => [
          const OwnerBookingsApprovalLoading(message: 'Rejecting booking...'),
          const BookingRejected(tBookingId, ''),
        ],
      );
    });

    group('reset -', () {
      blocTest<OwnerBookingsApprovalCubit, OwnerBookingsApprovalState>(
        'should emit Initial when resetting from Loaded',
        build: () => cubit,
        seed: () => OwnerBookingsLoaded(tBookings),
        act: (cubit) => cubit.reset(),
        expect: () => [const OwnerBookingsApprovalInitial()],
      );

      blocTest<OwnerBookingsApprovalCubit, OwnerBookingsApprovalState>(
        'should emit Initial when resetting from Error',
        build: () => cubit,
        seed: () => const OwnerBookingsApprovalError('Some error'),
        act: (cubit) => cubit.reset(),
        expect: () => [const OwnerBookingsApprovalInitial()],
      );

      blocTest<OwnerBookingsApprovalCubit, OwnerBookingsApprovalState>(
        'should emit Initial when resetting from Approved',
        build: () => cubit,
        seed: () => const BookingApproved('booking-1'),
        act: (cubit) => cubit.reset(),
        expect: () => [const OwnerBookingsApprovalInitial()],
      );
    });
  });

  group('OwnerBookingsApprovalState -', () {
    group('OwnerBookingsApprovalInitial -', () {
      test('props should be empty', () {
        const state = OwnerBookingsApprovalInitial();
        expect(state.props, isEmpty);
      });
    });

    group('OwnerBookingsApprovalLoading -', () {
      test('props should include message', () {
        const state1 = OwnerBookingsApprovalLoading(
          message: 'Loading bookings...',
        );
        const state2 = OwnerBookingsApprovalLoading(
          message: 'Loading bookings...',
        );
        const state3 = OwnerBookingsApprovalLoading(
          message: 'Different message',
        );

        expect(state1, equals(state2));
        expect(state1, isNot(equals(state3)));
      });

      test('default message is Loading...', () {
        const state = OwnerBookingsApprovalLoading();
        expect(state.message, equals('Loading...'));
      });
    });

    group('OwnerBookingsApprovalError -', () {
      test('props should include message', () {
        const error1 = OwnerBookingsApprovalError('Error 1');
        const error2 = OwnerBookingsApprovalError('Error 1');
        const error3 = OwnerBookingsApprovalError('Error 2');

        expect(error1, equals(error2));
        expect(error1, isNot(equals(error3)));
      });
    });

    group('OwnerBookingsLoaded -', () {
      test('props should include bookings', () {
        final state1 = OwnerBookingsLoaded(tBookings);
        final state2 = OwnerBookingsLoaded(tBookings);
        final state3 = OwnerBookingsLoaded([tBookings.first]);

        expect(state1, equals(state2));
        expect(state1, isNot(equals(state3)));
      });

      test('equality works with empty list', () {
        const state1 = OwnerBookingsLoaded([]);
        const state2 = OwnerBookingsLoaded([]);

        expect(state1, equals(state2));
      });
    });

    group('BookingApproved -', () {
      test('props should include bookingId', () {
        const state1 = BookingApproved('booking-1');
        const state2 = BookingApproved('booking-1');
        const state3 = BookingApproved('booking-2');

        expect(state1, equals(state2));
        expect(state1, isNot(equals(state3)));
      });
    });

    group('BookingRejected -', () {
      test('props should include bookingId and reason', () {
        const state1 = BookingRejected('booking-1', 'Reason A');
        const state2 = BookingRejected('booking-1', 'Reason A');
        const state3 = BookingRejected('booking-1', 'Reason B');
        const state4 = BookingRejected('booking-2', 'Reason A');

        expect(state1, equals(state2));
        expect(state1, isNot(equals(state3)));
        expect(state1, isNot(equals(state4)));
      });
    });
  });
}
