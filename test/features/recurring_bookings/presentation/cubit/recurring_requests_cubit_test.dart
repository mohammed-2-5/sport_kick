import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/recurring_bookings/domain/entities/recurring_booking_entity.dart';
import 'package:spo_kick/features/recurring_bookings/domain/usecases/approve_recurring_booking_usecase.dart';
import 'package:spo_kick/features/recurring_bookings/domain/usecases/get_active_recurring_bookings_for_owner_usecase.dart';
import 'package:spo_kick/features/recurring_bookings/domain/usecases/get_pending_recurring_requests_usecase.dart';
import 'package:spo_kick/features/recurring_bookings/domain/usecases/reject_recurring_booking_usecase.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/cubit/recurring_requests_cubit.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/cubit/recurring_requests_state.dart';

// Mock Classes
class MockGetPendingRecurringRequestsUseCase extends Mock
    implements GetPendingRecurringRequestsUseCase {}

class MockGetActiveRecurringBookingsForOwnerUseCase extends Mock
    implements GetActiveRecurringBookingsForOwnerUseCase {}

class MockApproveRecurringBookingUseCase extends Mock
    implements ApproveRecurringBookingUseCase {}

class MockRejectRecurringBookingUseCase extends Mock
    implements RejectRecurringBookingUseCase {}

void main() {
  late RecurringRequestsCubit cubit;
  late MockGetPendingRecurringRequestsUseCase mockGetPendingRequestsUseCase;
  late MockGetActiveRecurringBookingsForOwnerUseCase
  mockGetActiveBookingsUseCase;
  late MockApproveRecurringBookingUseCase mockApproveUseCase;
  late MockRejectRecurringBookingUseCase mockRejectUseCase;

  // Test data
  final now = DateTime.now();
  late List<RecurringBookingEntity> tPendingRequests;
  late List<RecurringBookingEntity> tActiveSubscriptions;

  setUpAll(() {
    registerFallbackValue(
      const ApproveRecurringBookingParams(recurringBookingId: 'fallback-id'),
    );
    registerFallbackValue(
      const RejectRecurringBookingParams(
        recurringBookingId: 'fallback-id',
        reason: 'fallback reason',
      ),
    );
  });

  setUp(() {
    mockGetPendingRequestsUseCase = MockGetPendingRecurringRequestsUseCase();
    mockGetActiveBookingsUseCase =
        MockGetActiveRecurringBookingsForOwnerUseCase();
    mockApproveUseCase = MockApproveRecurringBookingUseCase();
    mockRejectUseCase = MockRejectRecurringBookingUseCase();

    // Initialize test data
    tPendingRequests = [
      RecurringBookingEntity(
        id: 'pending-1',
        fieldId: 'field-1',
        fieldName: 'Stadium A',
        dayOfWeek: 1, // Sunday
        startTime: '14:00',
        endTime: '16:00',
        durationHours: 2,
        pricePerBooking: 300.0,
        status: RecurringBookingStatus.pendingApproval,
        createdAt: now,
        userId: 'user-1',
        userName: 'Ahmed Ali',
        userEmail: 'ahmed@test.com',
        userPhone: '01234567890',
      ),
      RecurringBookingEntity(
        id: 'pending-2',
        fieldId: 'field-2',
        fieldName: 'Stadium B',
        dayOfWeek: 3, // Tuesday
        startTime: '18:00',
        endTime: '20:00',
        durationHours: 2,
        pricePerBooking: 400.0,
        status: RecurringBookingStatus.pendingApproval,
        createdAt: now,
        userId: 'user-2',
        userName: 'Mohamed Hassan',
        userEmail: 'mohamed@test.com',
      ),
    ];

    tActiveSubscriptions = [
      RecurringBookingEntity(
        id: 'active-1',
        fieldId: 'field-1',
        fieldName: 'Stadium A',
        dayOfWeek: 5, // Thursday
        startTime: '10:00',
        endTime: '12:00',
        durationHours: 2,
        pricePerBooking: 300.0,
        status: RecurringBookingStatus.active,
        createdAt: now.subtract(const Duration(days: 30)),
        startedAt: now.subtract(const Duration(days: 28)),
        nextBookingDate: now.add(const Duration(days: 2)),
        nextBookingPaid: false,
        totalBookingsCount: 8,
        completedBookingsCount: 4,
        userId: 'user-3',
        userName: 'Khalid Omar',
      ),
    ];

    cubit = RecurringRequestsCubit(
      getPendingRequestsUseCase: mockGetPendingRequestsUseCase,
      getActiveBookingsUseCase: mockGetActiveBookingsUseCase,
      approveUseCase: mockApproveUseCase,
      rejectUseCase: mockRejectUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('RecurringRequestsCubit -', () {
    test('initial state should be RecurringRequestsInitial', () {
      expect(cubit.state, equals(const RecurringRequestsInitial()));
    });

    group('loadData -', () {
      blocTest<RecurringRequestsCubit, RecurringRequestsState>(
        'should emit [Loading, Loaded] when both requests succeed',
        build: () {
          when(
            () => mockGetPendingRequestsUseCase(),
          ).thenAnswer((_) async => Right(tPendingRequests));
          when(
            () => mockGetActiveBookingsUseCase(),
          ).thenAnswer((_) async => Right(tActiveSubscriptions));
          return cubit;
        },
        act: (cubit) => cubit.loadData(),
        expect: () => [
          const RecurringRequestsLoading(),
          RecurringRequestsLoaded(
            pendingRequests: tPendingRequests,
            activeSubscriptions: tActiveSubscriptions,
          ),
        ],
        verify: (_) {
          verify(() => mockGetPendingRequestsUseCase()).called(1);
          verify(() => mockGetActiveBookingsUseCase()).called(1);
        },
      );

      blocTest<RecurringRequestsCubit, RecurringRequestsState>(
        'should emit [Loading, Loaded with empty lists] when pending fails',
        build: () {
          when(() => mockGetPendingRequestsUseCase()).thenAnswer(
            (_) async => const Left(ServerFailure('Failed to load pending')),
          );
          when(
            () => mockGetActiveBookingsUseCase(),
          ).thenAnswer((_) async => Right(tActiveSubscriptions));
          return cubit;
        },
        act: (cubit) => cubit.loadData(),
        expect: () => [
          const RecurringRequestsLoading(),
          RecurringRequestsLoaded(
            pendingRequests: const [],
            activeSubscriptions: tActiveSubscriptions,
          ),
        ],
      );

      blocTest<RecurringRequestsCubit, RecurringRequestsState>(
        'should emit [Loading, Loaded with empty active] when active fails',
        build: () {
          when(
            () => mockGetPendingRequestsUseCase(),
          ).thenAnswer((_) async => Right(tPendingRequests));
          when(() => mockGetActiveBookingsUseCase()).thenAnswer(
            (_) async => const Left(ServerFailure('Failed to load active')),
          );
          return cubit;
        },
        act: (cubit) => cubit.loadData(),
        expect: () => [
          const RecurringRequestsLoading(),
          RecurringRequestsLoaded(
            pendingRequests: tPendingRequests,
            activeSubscriptions: const [],
          ),
        ],
      );

      blocTest<RecurringRequestsCubit, RecurringRequestsState>(
        'should emit [Loading, Loaded with empty lists] when both fail',
        build: () {
          when(() => mockGetPendingRequestsUseCase()).thenAnswer(
            (_) async => const Left(ServerFailure('Pending failed')),
          );
          when(
            () => mockGetActiveBookingsUseCase(),
          ).thenAnswer((_) async => const Left(ServerFailure('Active failed')));
          return cubit;
        },
        act: (cubit) => cubit.loadData(),
        expect: () => [
          const RecurringRequestsLoading(),
          const RecurringRequestsLoaded(
            pendingRequests: [],
            activeSubscriptions: [],
          ),
        ],
      );

      blocTest<RecurringRequestsCubit, RecurringRequestsState>(
        'should emit Error when exception is thrown',
        build: () {
          when(
            () => mockGetPendingRequestsUseCase(),
          ).thenThrow(Exception('Unexpected error'));
          when(
            () => mockGetActiveBookingsUseCase(),
          ).thenAnswer((_) async => Right(tActiveSubscriptions));
          return cubit;
        },
        act: (cubit) => cubit.loadData(),
        expect: () => [
          const RecurringRequestsLoading(),
          isA<RecurringRequestsError>().having(
            (e) => e.message,
            'message',
            contains('Unexpected'),
          ),
        ],
      );
    });

    group('approveRequest -', () {
      const tRequestId = 'pending-1';

      blocTest<RecurringRequestsCubit, RecurringRequestsState>(
        'should update processingRequestId and return true on success',
        build: () {
          when(
            () => mockApproveUseCase(any()),
          ).thenAnswer((_) async => const Right(true));
          when(
            () => mockGetPendingRequestsUseCase(),
          ).thenAnswer((_) async => const Right([]));
          when(
            () => mockGetActiveBookingsUseCase(),
          ).thenAnswer((_) async => Right(tActiveSubscriptions));
          return cubit;
        },
        seed: () => RecurringRequestsLoaded(
          pendingRequests: tPendingRequests,
          activeSubscriptions: tActiveSubscriptions,
        ),
        act: (cubit) async {
          final result = await cubit.approveRequest(tRequestId);
          expect(result, isTrue);
        },
        verify: (_) {
          verify(
            () => mockApproveUseCase(
              const ApproveRecurringBookingParams(
                recurringBookingId: tRequestId,
              ),
            ),
          ).called(1);
        },
      );

      blocTest<RecurringRequestsCubit, RecurringRequestsState>(
        'should return false and clear processing when approval fails',
        build: () {
          when(() => mockApproveUseCase(any())).thenAnswer(
            (_) async => const Left(ServerFailure('Approval failed')),
          );
          return cubit;
        },
        seed: () => RecurringRequestsLoaded(
          pendingRequests: tPendingRequests,
          activeSubscriptions: tActiveSubscriptions,
        ),
        act: (cubit) async {
          final result = await cubit.approveRequest(tRequestId);
          expect(result, isFalse);
        },
        expect: () => [
          RecurringRequestsLoaded(
            pendingRequests: tPendingRequests,
            activeSubscriptions: tActiveSubscriptions,
            processingRequestId: tRequestId,
          ),
          RecurringRequestsLoaded(
            pendingRequests: tPendingRequests,
            activeSubscriptions: tActiveSubscriptions,
          ),
        ],
      );

      test('should return false when state is not Loaded', () async {
        // Don't seed, keep initial state
        final result = await cubit.approveRequest(tRequestId);
        expect(result, isFalse);
        verifyNever(() => mockApproveUseCase(any()));
      });
    });

    group('rejectRequest -', () {
      const tRequestId = 'pending-1';
      const tReason = 'Time slot conflict with regular customer';

      blocTest<RecurringRequestsCubit, RecurringRequestsState>(
        'should update processingRequestId and return true on success',
        build: () {
          when(
            () => mockRejectUseCase(any()),
          ).thenAnswer((_) async => const Right(true));
          when(
            () => mockGetPendingRequestsUseCase(),
          ).thenAnswer((_) async => const Right([]));
          when(
            () => mockGetActiveBookingsUseCase(),
          ).thenAnswer((_) async => Right(tActiveSubscriptions));
          return cubit;
        },
        seed: () => RecurringRequestsLoaded(
          pendingRequests: tPendingRequests,
          activeSubscriptions: tActiveSubscriptions,
        ),
        act: (cubit) async {
          final result = await cubit.rejectRequest(tRequestId, tReason);
          expect(result, isTrue);
        },
        verify: (_) {
          verify(
            () => mockRejectUseCase(
              const RejectRecurringBookingParams(
                recurringBookingId: tRequestId,
                reason: tReason,
              ),
            ),
          ).called(1);
        },
      );

      blocTest<RecurringRequestsCubit, RecurringRequestsState>(
        'should return false and clear processing when rejection fails',
        build: () {
          when(() => mockRejectUseCase(any())).thenAnswer(
            (_) async => const Left(ServerFailure('Rejection failed')),
          );
          return cubit;
        },
        seed: () => RecurringRequestsLoaded(
          pendingRequests: tPendingRequests,
          activeSubscriptions: tActiveSubscriptions,
        ),
        act: (cubit) async {
          final result = await cubit.rejectRequest(tRequestId, tReason);
          expect(result, isFalse);
        },
        expect: () => [
          RecurringRequestsLoaded(
            pendingRequests: tPendingRequests,
            activeSubscriptions: tActiveSubscriptions,
            processingRequestId: tRequestId,
          ),
          RecurringRequestsLoaded(
            pendingRequests: tPendingRequests,
            activeSubscriptions: tActiveSubscriptions,
          ),
        ],
      );

      test('should return false when state is not Loaded', () async {
        final result = await cubit.rejectRequest(tRequestId, tReason);
        expect(result, isFalse);
        verifyNever(() => mockRejectUseCase(any()));
      });
    });

    group('refresh -', () {
      blocTest<RecurringRequestsCubit, RecurringRequestsState>(
        'should call loadData when refresh is called',
        build: () {
          when(
            () => mockGetPendingRequestsUseCase(),
          ).thenAnswer((_) async => Right(tPendingRequests));
          when(
            () => mockGetActiveBookingsUseCase(),
          ).thenAnswer((_) async => Right(tActiveSubscriptions));
          return cubit;
        },
        act: (cubit) => cubit.refresh(),
        expect: () => [
          const RecurringRequestsLoading(),
          RecurringRequestsLoaded(
            pendingRequests: tPendingRequests,
            activeSubscriptions: tActiveSubscriptions,
          ),
        ],
      );
    });
  });

  group('RecurringRequestsLoaded -', () {
    test('hasPendingRequests returns true when list is not empty', () {
      final state = RecurringRequestsLoaded(
        pendingRequests: tPendingRequests,
        activeSubscriptions: const [],
      );
      expect(state.hasPendingRequests, isTrue);
      expect(state.pendingCount, equals(2));
    });

    test('hasActiveSubscriptions returns true when list is not empty', () {
      final state = RecurringRequestsLoaded(
        pendingRequests: const [],
        activeSubscriptions: tActiveSubscriptions,
      );
      expect(state.hasActiveSubscriptions, isTrue);
      expect(state.activeCount, equals(1));
    });

    test('isProcessing returns true for matching request', () {
      final state = RecurringRequestsLoaded(
        pendingRequests: tPendingRequests,
        activeSubscriptions: tActiveSubscriptions,
        processingRequestId: 'pending-1',
      );
      expect(state.isProcessing('pending-1'), isTrue);
      expect(state.isProcessing('pending-2'), isFalse);
    });

    test('copyWith creates new instance with updated values', () {
      final original = RecurringRequestsLoaded(
        pendingRequests: tPendingRequests,
        activeSubscriptions: tActiveSubscriptions,
      );

      final withProcessing = original.copyWith(processingRequestId: 'test-id');
      expect(withProcessing.processingRequestId, equals('test-id'));
      expect(withProcessing.pendingRequests, equals(tPendingRequests));

      final cleared = withProcessing.copyWith(clearProcessing: true);
      expect(cleared.processingRequestId, isNull);
    });

    test('props returns correct list for equality', () {
      final state1 = RecurringRequestsLoaded(
        pendingRequests: tPendingRequests,
        activeSubscriptions: tActiveSubscriptions,
      );
      final state2 = RecurringRequestsLoaded(
        pendingRequests: tPendingRequests,
        activeSubscriptions: tActiveSubscriptions,
      );
      expect(state1, equals(state2));
    });
  });

  group('RecurringRequestsError -', () {
    test('props returns message', () {
      const error1 = RecurringRequestsError('Error 1');
      const error2 = RecurringRequestsError('Error 1');
      const error3 = RecurringRequestsError('Error 2');

      expect(error1, equals(error2));
      expect(error1, isNot(equals(error3)));
    });
  });
}
