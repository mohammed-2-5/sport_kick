import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/owner/domain/entities/owner_revenue_entity.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_state.dart';

import '../../../../helpers/mock_dependencies.dart';

void main() {
  late OwnerCubit cubit;
  late MockGetOwnerFieldsUseCase mockGetOwnerFieldsUseCase;
  late MockUpdateFieldUseCase mockUpdateFieldUseCase;
  late MockGetOwnerBookingsUseCase mockGetOwnerBookingsUseCase;
  late MockApproveBookingUseCase mockApproveBookingUseCase;
  late MockRejectBookingUseCase mockRejectBookingUseCase;
  late MockGetOwnerRevenueUseCase mockGetOwnerRevenueUseCase;
  late MockUpdateOwnerProfileUseCase mockUpdateOwnerProfileUseCase;
  late MockDeleteFieldUseCase mockDeleteFieldUseCase;

  // Test data
  late List<FieldEntity> tFields;
  late List<BookingEntity> tBookings;
  late OwnerRevenueEntity tRevenue;
  final now = DateTime.now();

  setUp(() {
    // Initialize mocks
    mockGetOwnerFieldsUseCase = MockGetOwnerFieldsUseCase();
    mockUpdateFieldUseCase = MockUpdateFieldUseCase();
    mockGetOwnerBookingsUseCase = MockGetOwnerBookingsUseCase();
    mockApproveBookingUseCase = MockApproveBookingUseCase();
    mockRejectBookingUseCase = MockRejectBookingUseCase();
    mockGetOwnerRevenueUseCase = MockGetOwnerRevenueUseCase();
    mockUpdateOwnerProfileUseCase = MockUpdateOwnerProfileUseCase();
    mockDeleteFieldUseCase = MockDeleteFieldUseCase();

    // Initialize test data
    tFields = [
      FieldEntity(
        id: 'field-1',
        name: 'Test Field',
        sportCategoryId: 'sport-1',
        ownerId: 'owner-1',
        city: 'Cairo',
        address: '123 Test St',
        pricePerHour: 150.0,
        currency: 'EGP',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
    ];

    tBookings = [
      BookingEntity(
        id: 'booking-1',
        fieldId: 'field-1',
        userId: 'user-1',
        date: now,
        startTime: '10:00',
        endTime: '11:00',
        totalPrice: 150.0,
        currency: 'EGP',
        status: BookingStatus.pending,
        createdAt: now,
      ),
    ];

    tRevenue = const OwnerRevenueEntity(
      totalRevenue: 5000.0,
      monthlyRevenue: 1200.0,
      totalBookings: 45,
      monthlyBookings: 10,
      pendingBookings: 5,
      revenueByField: {'field-1': 5000.0},
    );

    // Create cubit
    cubit = OwnerCubit(
      getOwnerFieldsUseCase: mockGetOwnerFieldsUseCase,
      updateFieldUseCase: mockUpdateFieldUseCase,
      getOwnerBookingsUseCase: mockGetOwnerBookingsUseCase,
      approveBookingUseCase: mockApproveBookingUseCase,
      rejectBookingUseCase: mockRejectBookingUseCase,
      getOwnerRevenueUseCase: mockGetOwnerRevenueUseCase,
      updateOwnerProfileUseCase: mockUpdateOwnerProfileUseCase,
      deleteFieldUseCase: mockDeleteFieldUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('OwnerCubit -', () {
    test('initial state should be OwnerInitial', () {
      expect(cubit.state, equals(const OwnerInitial()));
    });

    group('loadOwnerFields -', () {
      const tOwnerId = 'owner-1';

      blocTest<OwnerCubit, OwnerState>(
        'should emit [Loading, FieldsLoaded] when successful',
        build: () {
          when(
            () => mockGetOwnerFieldsUseCase(ownerId: tOwnerId),
          ).thenAnswer((_) async => Right(tFields));
          return cubit;
        },
        act: (cubit) => cubit.loadOwnerFields(tOwnerId),
        expect: () => [
          const OwnerLoading(message: 'Loading your fields...'),
          OwnerDataLoaded(fields: tFields),
        ],
        verify: (_) {
          verify(() => mockGetOwnerFieldsUseCase(ownerId: tOwnerId)).called(1);
        },
      );

      blocTest<OwnerCubit, OwnerState>(
        'should emit [Loading, Error] when failure occurs',
        build: () {
          when(
            () => mockGetOwnerFieldsUseCase(ownerId: tOwnerId),
          ).thenAnswer((_) async => const Left(ServerFailure('Server error')));
          return cubit;
        },
        act: (cubit) => cubit.loadOwnerFields(tOwnerId),
        expect: () => [
          const OwnerLoading(message: 'Loading your fields...'),
          const OwnerError('Server error'),
        ],
      );
    });

    group('updateField -', () {
      const tFieldId = 'field-1';
      final tUpdates = {'price_per_hour': 200.0};

      blocTest<OwnerCubit, OwnerState>(
        'should emit [Loading, ActionSuccess] when successful',
        build: () {
          when(
            () => mockUpdateFieldUseCase(fieldId: tFieldId, updates: tUpdates),
          ).thenAnswer((_) async => Right(tFields.first));
          return cubit;
        },
        act: (cubit) => cubit.updateField(tFieldId, tUpdates),
        expect: () => [
          const OwnerLoading(message: 'Updating field...'),
          const OwnerActionSuccess('Field updated successfully'),
        ],
        verify: (_) {
          verify(
            () => mockUpdateFieldUseCase(fieldId: tFieldId, updates: tUpdates),
          ).called(1);
        },
      );

      blocTest<OwnerCubit, OwnerState>(
        'should emit Error when validation fails',
        build: () {
          when(
            () => mockUpdateFieldUseCase(fieldId: tFieldId, updates: tUpdates),
          ).thenAnswer(
            (_) async => const Left(ValidationFailure('Invalid price')),
          );
          return cubit;
        },
        act: (cubit) => cubit.updateField(tFieldId, tUpdates),
        expect: () => [
          const OwnerLoading(message: 'Updating field...'),
          const OwnerError('Invalid price'),
        ],
      );
    });

    group('deleteField -', () {
      const tFieldId = 'field-1';

      blocTest<OwnerCubit, OwnerState>(
        'should emit [Loading, ActionSuccess] when successful',
        build: () {
          when(
            () => mockDeleteFieldUseCase(tFieldId),
          ).thenAnswer((_) async => const Right(null));
          return cubit;
        },
        act: (cubit) => cubit.deleteField(tFieldId),
        expect: () => [
          const OwnerLoading(message: 'Deleting field...'),
          const OwnerActionSuccess('Field deleted successfully'),
        ],
        verify: (_) {
          verify(() => mockDeleteFieldUseCase(tFieldId)).called(1);
        },
      );

      blocTest<OwnerCubit, OwnerState>(
        'should emit [Loading, Error] when failure occurs',
        build: () {
          when(
            () => mockDeleteFieldUseCase(tFieldId),
          ).thenAnswer((_) async => const Left(ServerFailure('Delete failed')));
          return cubit;
        },
        act: (cubit) => cubit.deleteField(tFieldId),
        expect: () => [
          const OwnerLoading(message: 'Deleting field...'),
          const OwnerError('Delete failed'),
        ],
      );
    });

    group('loadOwnerBookings -', () {
      const tOwnerId = 'owner-1';

      blocTest<OwnerCubit, OwnerState>(
        'should emit [Loading, BookingsLoaded] when successful',
        build: () {
          when(
            () => mockGetOwnerBookingsUseCase(ownerId: tOwnerId, status: null),
          ).thenAnswer((_) async => Right(tBookings));
          return cubit;
        },
        act: (cubit) => cubit.loadOwnerBookings(ownerId: tOwnerId),
        expect: () => [
          const OwnerLoading(message: 'Loading bookings...'),
          OwnerDataLoaded(bookings: tBookings),
        ],
      );

      blocTest<OwnerCubit, OwnerState>(
        'should pass status filter when provided',
        build: () {
          when(
            () => mockGetOwnerBookingsUseCase(
              ownerId: tOwnerId,
              status: 'pending',
            ),
          ).thenAnswer((_) async => Right(tBookings));
          return cubit;
        },
        act: (cubit) =>
            cubit.loadOwnerBookings(ownerId: tOwnerId, status: 'pending'),
        verify: (_) {
          verify(
            () => mockGetOwnerBookingsUseCase(
              ownerId: tOwnerId,
              status: 'pending',
            ),
          ).called(1);
        },
      );
    });

    group('approveBooking -', () {
      const tBookingId = 'booking-1';

      blocTest<OwnerCubit, OwnerState>(
        'should emit [Loading, ActionSuccess] when successful',
        build: () {
          when(
            () => mockApproveBookingUseCase(bookingId: tBookingId),
          ).thenAnswer((_) async => const Right(null));
          return cubit;
        },
        act: (cubit) => cubit.approveBooking(tBookingId),
        expect: () => [
          const OwnerLoading(message: 'Approving booking...'),
          const OwnerActionSuccess('Booking approved successfully'),
        ],
      );
    });

    group('rejectBooking -', () {
      const tBookingId = 'booking-1';
      const tReason = 'Double booking';

      blocTest<OwnerCubit, OwnerState>(
        'should emit [Loading, ActionSuccess] when successful',
        build: () {
          when(
            () => mockRejectBookingUseCase(
              bookingId: tBookingId,
              reason: tReason,
            ),
          ).thenAnswer((_) async => const Right(null));
          return cubit;
        },
        act: (cubit) => cubit.rejectBooking(tBookingId, tReason),
        expect: () => [
          const OwnerLoading(message: 'Rejecting booking...'),
          const OwnerActionSuccess('Booking rejected successfully'),
        ],
      );
    });

    group('loadOwnerRevenue -', () {
      const tOwnerId = 'owner-1';

      blocTest<OwnerCubit, OwnerState>(
        'should emit [Loading, RevenueLoaded] when successful',
        build: () {
          when(
            () => mockGetOwnerRevenueUseCase(ownerId: tOwnerId),
          ).thenAnswer((_) async => Right(tRevenue));
          return cubit;
        },
        act: (cubit) => cubit.loadOwnerRevenue(tOwnerId),
        expect: () => [
          const OwnerLoading(message: 'Loading revenue data...'),
          OwnerDataLoaded(revenue: tRevenue),
        ],
      );
    });

    group('updateProfile -', () {
      const tOwnerId = 'owner-1';
      const tFullName = 'Updated Name';

      blocTest<OwnerCubit, OwnerState>(
        'should emit [Loading, ActionSuccess] when successful',
        build: () {
          when(
            () => mockUpdateOwnerProfileUseCase(
              ownerId: tOwnerId,
              fullName: tFullName,
              phone: null,
            ),
          ).thenAnswer((_) async => const Right(null));
          return cubit;
        },
        act: (cubit) =>
            cubit.updateProfile(ownerId: tOwnerId, fullName: tFullName),
        expect: () => [
          const OwnerLoading(message: 'Updating profile...'),
          const OwnerActionSuccess('Profile updated successfully'),
        ],
      );
    });

    group('reset -', () {
      blocTest<OwnerCubit, OwnerState>(
        'should emit OwnerInitial',
        build: () => cubit,
        seed: () => const OwnerError('Some error'),
        act: (cubit) => cubit.reset(),
        expect: () => [const OwnerInitial()],
      );
    });
  });
}
