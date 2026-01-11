import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/bookings/domain/entities/payment_status.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/owner/domain/entities/owner_revenue_entity.dart';
import 'package:spo_kick/features/owner/domain/usecases/get_owner_bookings_usecase.dart';
import 'package:spo_kick/features/owner/domain/usecases/get_owner_fields_usecase.dart';
import 'package:spo_kick/features/owner/domain/usecases/get_owner_revenue_usecase.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_profile/owner_profile_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_profile/owner_profile_state.dart';

// Mock Classes
class MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}

class MockGetOwnerFieldsUseCase extends Mock implements GetOwnerFieldsUseCase {}

class MockGetOwnerBookingsUseCase extends Mock
    implements GetOwnerBookingsUseCase {}

class MockGetOwnerRevenueUseCase extends Mock
    implements GetOwnerRevenueUseCase {}

void main() {
  late OwnerProfileCubit cubit;
  late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;
  late MockGetOwnerFieldsUseCase mockGetOwnerFieldsUseCase;
  late MockGetOwnerBookingsUseCase mockGetOwnerBookingsUseCase;
  late MockGetOwnerRevenueUseCase mockGetOwnerRevenueUseCase;

  // Test data
  final now = DateTime.now();
  const tOwnerId = 'owner-123';
  late UserEntity tUser;
  late List<FieldEntity> tFields;
  late List<BookingEntity> tBookings;
  late OwnerRevenueEntity tRevenue;

  setUp(() {
    mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();
    mockGetOwnerFieldsUseCase = MockGetOwnerFieldsUseCase();
    mockGetOwnerBookingsUseCase = MockGetOwnerBookingsUseCase();
    mockGetOwnerRevenueUseCase = MockGetOwnerRevenueUseCase();

    tUser = UserEntity(
      id: tOwnerId,
      email: 'owner@test.com',
      fullName: 'Test Owner',
      role: 'admin',
      createdAt: now,
      updatedAt: now,
    );

    tFields = [
      FieldEntity(
        id: 'field-1',
        name: 'Al-Ahly Stadium',
        sportCategoryId: 'sport-1',
        ownerId: tOwnerId,
        city: 'Cairo',
        address: '123 Stadium Street',
        pricePerHour: 200.0,
        currency: 'EGP',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      FieldEntity(
        id: 'field-2',
        name: 'Zamalek Field',
        sportCategoryId: 'sport-1',
        ownerId: tOwnerId,
        city: 'Cairo',
        address: '456 Field Road',
        pricePerHour: 300.0,
        currency: 'EGP',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
    ];

    tBookings = [
      BookingEntity(
        id: 'booking-1',
        userId: 'user-1',
        fieldId: 'field-1',
        date: now.add(const Duration(days: 1)),
        startTime: '14:00',
        endTime: '16:00',
        status: BookingStatus.confirmed,
        totalPrice: 400.0,
        currency: 'EGP',
        createdAt: now,
        paymentStatus: PaymentStatus.verified,
      ),
      BookingEntity(
        id: 'booking-2',
        userId: 'user-2',
        fieldId: 'field-1',
        date: now.add(const Duration(days: 2)),
        startTime: '10:00',
        endTime: '12:00',
        status: BookingStatus.pending,
        totalPrice: 400.0,
        currency: 'EGP',
        createdAt: now,
        paymentStatus: PaymentStatus.pending,
      ),
    ];

    tRevenue = const OwnerRevenueEntity(
      totalRevenue: 15000.0,
      monthlyRevenue: 3000.0,
      totalBookings: 50,
      monthlyBookings: 10,
      pendingBookings: 3,
      revenueByField: {'field-1': 10000.0, 'field-2': 5000.0},
    );

    cubit = OwnerProfileCubit(
      getCurrentUserUseCase: mockGetCurrentUserUseCase,
      getOwnerFieldsUseCase: mockGetOwnerFieldsUseCase,
      getOwnerBookingsUseCase: mockGetOwnerBookingsUseCase,
      getOwnerRevenueUseCase: mockGetOwnerRevenueUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('OwnerProfileCubit -', () {
    test('initial state should be OwnerProfileInitial', () {
      expect(cubit.state, equals(const OwnerProfileInitial()));
    });

    group('loadProfile -', () {
      blocTest<OwnerProfileCubit, OwnerProfileState>(
        'should emit [Loading, Loaded] when all data loads successfully',
        build: () {
          when(
            () => mockGetCurrentUserUseCase(),
          ).thenAnswer((_) async => Right(tUser));
          when(
            () => mockGetOwnerFieldsUseCase(ownerId: tOwnerId),
          ).thenAnswer((_) async => Right(tFields));
          when(
            () => mockGetOwnerBookingsUseCase(
              ownerId: tOwnerId,
              status: any(named: 'status'),
            ),
          ).thenAnswer((_) async => Right(tBookings));
          when(
            () => mockGetOwnerRevenueUseCase(ownerId: tOwnerId),
          ).thenAnswer((_) async => Right(tRevenue));
          return cubit;
        },
        act: (cubit) => cubit.loadProfile(),
        expect: () => [
          const OwnerProfileLoading(),
          const OwnerProfileLoaded(
            fieldsCount: 2,
            bookingsCount: 2,
            revenue: OwnerRevenueEntity(
              totalRevenue: 15000.0,
              monthlyRevenue: 3000.0,
              totalBookings: 50,
              monthlyBookings: 10,
              pendingBookings: 3,
              revenueByField: {'field-1': 10000.0, 'field-2': 5000.0},
            ),
          ),
        ],
      );

      blocTest<OwnerProfileCubit, OwnerProfileState>(
        'should emit [Loading, Error] when user is not authenticated',
        build: () {
          when(
            () => mockGetCurrentUserUseCase(),
          ).thenAnswer((_) async => const Right(null));
          return cubit;
        },
        act: (cubit) => cubit.loadProfile(),
        expect: () => [
          const OwnerProfileLoading(),
          const OwnerProfileError('User not authenticated'),
        ],
      );

      blocTest<OwnerProfileCubit, OwnerProfileState>(
        'should emit [Loading, Error] when getCurrentUser fails',
        build: () {
          when(
            () => mockGetCurrentUserUseCase(),
          ).thenAnswer((_) async => const Left(AuthFailure('Auth error')));
          return cubit;
        },
        act: (cubit) => cubit.loadProfile(),
        expect: () => [
          const OwnerProfileLoading(),
          const OwnerProfileError('User not authenticated'),
        ],
      );

      blocTest<OwnerProfileCubit, OwnerProfileState>(
        'should emit [Loading, Error] when fields loading fails',
        build: () {
          when(
            () => mockGetCurrentUserUseCase(),
          ).thenAnswer((_) async => Right(tUser));
          when(() => mockGetOwnerFieldsUseCase(ownerId: tOwnerId)).thenAnswer(
            (_) async => const Left(ServerFailure('Failed to load fields')),
          );
          when(
            () => mockGetOwnerBookingsUseCase(
              ownerId: tOwnerId,
              status: any(named: 'status'),
            ),
          ).thenAnswer((_) async => Right(tBookings));
          when(
            () => mockGetOwnerRevenueUseCase(ownerId: tOwnerId),
          ).thenAnswer((_) async => Right(tRevenue));
          return cubit;
        },
        act: (cubit) => cubit.loadProfile(),
        expect: () => [
          const OwnerProfileLoading(),
          const OwnerProfileError('Failed to load profile data'),
        ],
      );

      blocTest<OwnerProfileCubit, OwnerProfileState>(
        'should emit [Loading, Error] when bookings loading fails',
        build: () {
          when(
            () => mockGetCurrentUserUseCase(),
          ).thenAnswer((_) async => Right(tUser));
          when(
            () => mockGetOwnerFieldsUseCase(ownerId: tOwnerId),
          ).thenAnswer((_) async => Right(tFields));
          when(
            () => mockGetOwnerBookingsUseCase(
              ownerId: tOwnerId,
              status: any(named: 'status'),
            ),
          ).thenAnswer(
            (_) async => const Left(ServerFailure('Failed to load bookings')),
          );
          when(
            () => mockGetOwnerRevenueUseCase(ownerId: tOwnerId),
          ).thenAnswer((_) async => Right(tRevenue));
          return cubit;
        },
        act: (cubit) => cubit.loadProfile(),
        expect: () => [
          const OwnerProfileLoading(),
          const OwnerProfileError('Failed to load profile data'),
        ],
      );

      blocTest<OwnerProfileCubit, OwnerProfileState>(
        'should still load when revenue fails (optional data)',
        build: () {
          when(
            () => mockGetCurrentUserUseCase(),
          ).thenAnswer((_) async => Right(tUser));
          when(
            () => mockGetOwnerFieldsUseCase(ownerId: tOwnerId),
          ).thenAnswer((_) async => Right(tFields));
          when(
            () => mockGetOwnerBookingsUseCase(
              ownerId: tOwnerId,
              status: any(named: 'status'),
            ),
          ).thenAnswer((_) async => Right(tBookings));
          when(() => mockGetOwnerRevenueUseCase(ownerId: tOwnerId)).thenAnswer(
            (_) async => const Left(ServerFailure('Revenue not available')),
          );
          return cubit;
        },
        act: (cubit) => cubit.loadProfile(),
        expect: () => [
          const OwnerProfileLoading(),
          const OwnerProfileLoaded(
            fieldsCount: 2,
            bookingsCount: 2,
            revenue: null,
          ),
        ],
      );
    });

    group('refresh -', () {
      blocTest<OwnerProfileCubit, OwnerProfileState>(
        'should call loadProfile when not in Loaded state',
        build: () {
          when(
            () => mockGetCurrentUserUseCase(),
          ).thenAnswer((_) async => Right(tUser));
          when(
            () => mockGetOwnerFieldsUseCase(ownerId: tOwnerId),
          ).thenAnswer((_) async => Right(tFields));
          when(
            () => mockGetOwnerBookingsUseCase(
              ownerId: tOwnerId,
              status: any(named: 'status'),
            ),
          ).thenAnswer((_) async => Right(tBookings));
          when(
            () => mockGetOwnerRevenueUseCase(ownerId: tOwnerId),
          ).thenAnswer((_) async => Right(tRevenue));
          return cubit;
        },
        act: (cubit) => cubit.refresh(),
        expect: () => [const OwnerProfileLoading(), isA<OwnerProfileLoaded>()],
      );

      blocTest<OwnerProfileCubit, OwnerProfileState>(
        'should set isRefreshing and then reload when in Loaded state',
        build: () {
          when(
            () => mockGetCurrentUserUseCase(),
          ).thenAnswer((_) async => Right(tUser));
          when(
            () => mockGetOwnerFieldsUseCase(ownerId: tOwnerId),
          ).thenAnswer((_) async => Right(tFields));
          when(
            () => mockGetOwnerBookingsUseCase(
              ownerId: tOwnerId,
              status: any(named: 'status'),
            ),
          ).thenAnswer((_) async => Right(tBookings));
          when(
            () => mockGetOwnerRevenueUseCase(ownerId: tOwnerId),
          ).thenAnswer((_) async => Right(tRevenue));
          return cubit;
        },
        seed: () => const OwnerProfileLoaded(
          fieldsCount: 1,
          bookingsCount: 1,
          revenue: null,
        ),
        act: (cubit) => cubit.refresh(),
        expect: () => [
          const OwnerProfileLoaded(
            fieldsCount: 1,
            bookingsCount: 1,
            revenue: null,
            isRefreshing: true,
          ),
          isA<OwnerProfileLoaded>()
              .having((s) => s.fieldsCount, 'fieldsCount', equals(2))
              .having((s) => s.isRefreshing, 'isRefreshing', isFalse),
        ],
      );

      blocTest<OwnerProfileCubit, OwnerProfileState>(
        'should emit Error when user becomes unauthenticated during refresh',
        build: () {
          when(
            () => mockGetCurrentUserUseCase(),
          ).thenAnswer((_) async => const Right(null));
          return cubit;
        },
        seed: () => const OwnerProfileLoaded(
          fieldsCount: 1,
          bookingsCount: 1,
          revenue: null,
        ),
        act: (cubit) => cubit.refresh(),
        expect: () => [
          const OwnerProfileLoaded(
            fieldsCount: 1,
            bookingsCount: 1,
            revenue: null,
            isRefreshing: true,
          ),
          const OwnerProfileError('User not authenticated'),
        ],
      );
    });
  });

  group('OwnerProfileState -', () {
    group('OwnerProfileInitial -', () {
      test('props should be empty', () {
        const state = OwnerProfileInitial();
        expect(state.props, isEmpty);
      });
    });

    group('OwnerProfileLoading -', () {
      test('props should be empty', () {
        const state = OwnerProfileLoading();
        expect(state.props, isEmpty);
      });
    });

    group('OwnerProfileLoaded -', () {
      test('props should include all fields', () {
        final state1 = OwnerProfileLoaded(
          fieldsCount: 2,
          bookingsCount: 5,
          revenue: tRevenue,
          isRefreshing: false,
        );
        final state2 = OwnerProfileLoaded(
          fieldsCount: 2,
          bookingsCount: 5,
          revenue: tRevenue,
          isRefreshing: false,
        );
        const state3 = OwnerProfileLoaded(
          fieldsCount: 3,
          bookingsCount: 5,
          revenue: null,
          isRefreshing: false,
        );

        expect(state1, equals(state2));
        expect(state1, isNot(equals(state3)));
      });

      test('copyWith should update isRefreshing', () {
        const original = OwnerProfileLoaded(
          fieldsCount: 2,
          bookingsCount: 5,
          revenue: null,
          isRefreshing: false,
        );
        final updated = original.copyWith(isRefreshing: true);

        expect(updated.isRefreshing, isTrue);
        expect(updated.fieldsCount, equals(2));
      });

      test('copyWith should update fieldsCount', () {
        const original = OwnerProfileLoaded(
          fieldsCount: 2,
          bookingsCount: 5,
          revenue: null,
        );
        final updated = original.copyWith(fieldsCount: 10);

        expect(updated.fieldsCount, equals(10));
        expect(updated.bookingsCount, equals(5));
      });
    });

    group('OwnerProfileError -', () {
      test('props should include message', () {
        const error1 = OwnerProfileError('Error 1');
        const error2 = OwnerProfileError('Error 1');
        const error3 = OwnerProfileError('Error 2');

        expect(error1, equals(error2));
        expect(error1, isNot(equals(error3)));
      });
    });
  });

  group('OwnerRevenueEntity -', () {
    test('averageRevenuePerBooking calculates correctly', () {
      expect(tRevenue.averageRevenuePerBooking, equals(300.0)); // 15000/50
    });

    test('averageRevenuePerBooking returns 0 when no bookings', () {
      const zeroRevenue = OwnerRevenueEntity(
        totalRevenue: 0,
        monthlyRevenue: 0,
        totalBookings: 0,
        monthlyBookings: 0,
        pendingBookings: 0,
        revenueByField: {},
      );
      expect(zeroRevenue.averageRevenuePerBooking, equals(0));
    });

    test('revenueGrowthRate calculates correctly', () {
      expect(tRevenue.revenueGrowthRate, equals(20.0)); // (3000/15000)*100
    });

    test('revenueGrowthRate returns 0 when no total revenue', () {
      const zeroRevenue = OwnerRevenueEntity(
        totalRevenue: 0,
        monthlyRevenue: 0,
        totalBookings: 0,
        monthlyBookings: 0,
        pendingBookings: 0,
        revenueByField: {},
      );
      expect(zeroRevenue.revenueGrowthRate, equals(0));
    });

    test('equality works correctly', () {
      const revenue1 = OwnerRevenueEntity(
        totalRevenue: 1000,
        monthlyRevenue: 100,
        totalBookings: 10,
        monthlyBookings: 2,
        pendingBookings: 1,
        revenueByField: {'field-1': 1000.0},
      );
      const revenue2 = OwnerRevenueEntity(
        totalRevenue: 1000,
        monthlyRevenue: 100,
        totalBookings: 10,
        monthlyBookings: 2,
        pendingBookings: 1,
        revenueByField: {'field-1': 1000.0},
      );
      const revenue3 = OwnerRevenueEntity(
        totalRevenue: 2000,
        monthlyRevenue: 200,
        totalBookings: 20,
        monthlyBookings: 4,
        pendingBookings: 2,
        revenueByField: {'field-1': 2000.0},
      );

      expect(revenue1, equals(revenue2));
      expect(revenue1, isNot(equals(revenue3)));
    });
  });
}
