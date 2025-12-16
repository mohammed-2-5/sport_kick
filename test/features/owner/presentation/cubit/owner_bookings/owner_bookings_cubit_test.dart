import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/bookings/domain/repositories/booking_repository.dart';
import 'package:spo_kick/features/bookings/domain/usecases/get_owner_bookings_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/update_booking_status_usecase.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_bookings/owner_bookings_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_bookings/owner_bookings_state.dart';

// Mock Use Cases
class MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}

class MockGetOwnerBookingsUseCase extends Mock
    implements GetOwnerBookingsUseCase {}

class MockUpdateBookingStatusUseCase extends Mock
    implements UpdateBookingStatusUseCase {}

class MockBookingRepository extends Mock implements BookingRepository {}

void main() {
  late OwnerBookingsCubit cubit;
  late MockGetCurrentUserUseCase mockGetCurrentUser;
  late MockGetOwnerBookingsUseCase mockGetBookings;
  late MockUpdateBookingStatusUseCase mockUpdateStatus;
  late MockBookingRepository mockBookingRepository;

  // Test data
  final testUser = UserEntity(
    id: 'owner-1',
    email: 'owner@test.com',
    fullName: 'Test Owner',
    role: 'admin',
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  final pendingBooking = BookingEntity(
    id: 'booking-1',
    userId: 'user-1',
    fieldId: 'field-1',
    date: DateTime.now(),
    startTime: '10:00',
    endTime: '11:00',
    totalPrice: 100,
    currency: 'EGP',
    status: BookingStatus.pending,
    userName: 'John Doe',
    fieldName: 'Field A',
    createdAt: DateTime.now(),
  );

  final confirmedBooking = BookingEntity(
    id: 'booking-2',
    userId: 'user-2',
    fieldId: 'field-1',
    date: DateTime.now(),
    startTime: '11:00',
    endTime: '12:00',
    totalPrice: 100,
    currency: 'EGP',
    status: BookingStatus.confirmed,
    userName: 'Jane Smith',
    fieldName: 'Field B',
    createdAt: DateTime.now(),
  );

  final allBookings = [pendingBooking, confirmedBooking];

  setUp(() {
    mockGetCurrentUser = MockGetCurrentUserUseCase();
    mockGetBookings = MockGetOwnerBookingsUseCase();
    mockUpdateStatus = MockUpdateBookingStatusUseCase();
    mockBookingRepository = MockBookingRepository();

    cubit = OwnerBookingsCubit(
      getCurrentUserUseCase: mockGetCurrentUser,
      getOwnerBookingsUseCase: mockGetBookings,
      updateBookingStatusUseCase: mockUpdateStatus,
      bookingRepository: mockBookingRepository,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('OwnerBookingsCubit', () {
    test('initial state is OwnerBookingsLoading', () {
      expect(cubit.state, const OwnerBookingsLoading());
    });

    test('getStats returns zeros when not loaded', () {
      final stats = cubit.getStats();
      expect(stats['total'], 0);
      expect(stats['pending'], 0);
    });
  });

  group('loadBookings', () {
    blocTest<OwnerBookingsCubit, OwnerBookingsState>(
      'emits [Loading, Loaded] when bookings load successfully',
      build: () {
        when(
          () => mockGetCurrentUser(),
        ).thenAnswer((_) async => Right(testUser));
        when(
          () => mockGetBookings(),
        ).thenAnswer((_) async => Right(allBookings));
        return cubit;
      },
      act: (cubit) => cubit.loadBookings(),
      expect: () => [
        const OwnerBookingsLoading(),
        isA<OwnerBookingsLoaded>().having(
          (s) => s.allBookings.length,
          'bookings count',
          2,
        ),
      ],
    );

    blocTest<OwnerBookingsCubit, OwnerBookingsState>(
      'emits [Loading, Error] when user not found',
      build: () {
        when(
          () => mockGetCurrentUser(),
        ).thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.loadBookings(),
      expect: () => [
        const OwnerBookingsLoading(),
        const OwnerBookingsError('Unable to load owner data'),
      ],
    );

    blocTest<OwnerBookingsCubit, OwnerBookingsState>(
      'emits [Loading, Error] when bookings load fails',
      build: () {
        when(
          () => mockGetCurrentUser(),
        ).thenAnswer((_) async => Right(testUser));
        when(
          () => mockGetBookings(),
        ).thenAnswer((_) async => const Left(ServerFailure('Network error')));
        return cubit;
      },
      act: (cubit) => cubit.loadBookings(),
      expect: () => [
        const OwnerBookingsLoading(),
        const OwnerBookingsError('Network error'),
      ],
    );
  });

  group('changeTab', () {
    final loadedState = OwnerBookingsLoaded(allBookings: allBookings);

    blocTest<OwnerBookingsCubit, OwnerBookingsState>(
      'tab 0 shows all bookings (no filter)',
      build: () => cubit,
      seed: () => loadedState,
      act: (cubit) => cubit.changeTab(0),
      expect: () => [
        isA<OwnerBookingsLoaded>()
            .having((s) => s.selectedTabIndex, 'tab', 0)
            .having((s) => s.selectedFilter, 'filter', isNull),
      ],
    );

    blocTest<OwnerBookingsCubit, OwnerBookingsState>(
      'tab 1 filters by pending',
      build: () => cubit,
      seed: () => loadedState,
      act: (cubit) => cubit.changeTab(1),
      expect: () => [
        isA<OwnerBookingsLoaded>()
            .having((s) => s.selectedTabIndex, 'tab', 1)
            .having((s) => s.selectedFilter, 'filter', BookingStatus.pending),
      ],
    );

    blocTest<OwnerBookingsCubit, OwnerBookingsState>(
      'tab 2 filters by confirmed',
      build: () => cubit,
      seed: () => loadedState,
      act: (cubit) => cubit.changeTab(2),
      expect: () => [
        isA<OwnerBookingsLoaded>().having(
          (s) => s.selectedFilter,
          'filter',
          BookingStatus.confirmed,
        ),
      ],
    );
  });

  group('search', () {
    final loadedState = OwnerBookingsLoaded(allBookings: allBookings);

    blocTest<OwnerBookingsCubit, OwnerBookingsState>(
      'updates search query',
      build: () => cubit,
      seed: () => loadedState,
      act: (cubit) => cubit.search('john'),
      expect: () => [
        isA<OwnerBookingsLoaded>().having(
          (s) => s.searchQuery,
          'searchQuery',
          'john',
        ),
      ],
    );

    blocTest<OwnerBookingsCubit, OwnerBookingsState>(
      'clearSearch clears query',
      build: () => cubit,
      seed: () => loadedState.copyWith(searchQuery: 'john'),
      act: (cubit) => cubit.clearSearch(),
      expect: () => [
        isA<OwnerBookingsLoaded>().having(
          (s) => s.searchQuery,
          'searchQuery',
          '',
        ),
      ],
    );
  });

  group('approveBooking', () {
    blocTest<OwnerBookingsCubit, OwnerBookingsState>(
      'emits error on failure',
      build: () {
        when(
          () => mockUpdateStatus(
            bookingId: any(named: 'bookingId'),
            status: any(named: 'status'),
          ),
        ).thenAnswer((_) async => const Left(ServerFailure('Update failed')));
        return cubit;
      },
      act: (cubit) => cubit.approveBooking('booking-1'),
      expect: () => [const OwnerBookingsError('Update failed')],
    );
  });

  group('rejectBooking', () {
    blocTest<OwnerBookingsCubit, OwnerBookingsState>(
      'emits error on failure',
      build: () {
        when(
          () => mockUpdateStatus(
            bookingId: any(named: 'bookingId'),
            status: any(named: 'status'),
          ),
        ).thenAnswer((_) async => const Left(ServerFailure('Reject failed')));
        return cubit;
      },
      act: (cubit) => cubit.rejectBooking('booking-1'),
      expect: () => [const OwnerBookingsError('Reject failed')],
    );
  });

  group('OwnerBookingsLoaded', () {
    test('filteredBookings returns all when no filter', () {
      final state = OwnerBookingsLoaded(allBookings: allBookings);
      expect(state.filteredBookings.length, 2);
    });

    test('filteredBookings filters by status', () {
      final state = OwnerBookingsLoaded(
        allBookings: allBookings,
        selectedFilter: BookingStatus.pending,
      );
      expect(state.filteredBookings.length, 1);
      expect(state.filteredBookings.first.status, BookingStatus.pending);
    });

    test('filteredBookings filters by search query', () {
      final state = OwnerBookingsLoaded(
        allBookings: allBookings,
        searchQuery: 'john',
      );
      expect(state.filteredBookings.length, 1);
      expect(state.filteredBookings.first.userName, 'John Doe');
    });

    test('getCountByStatus returns correct count', () {
      final state = OwnerBookingsLoaded(allBookings: allBookings);
      expect(state.getCountByStatus(BookingStatus.pending), 1);
      expect(state.getCountByStatus(BookingStatus.confirmed), 1);
      expect(state.getCountByStatus(null), 2);
    });
  });

  group('getStats', () {
    test('returns correct stats when loaded', () async {
      when(() => mockGetCurrentUser()).thenAnswer((_) async => Right(testUser));
      when(() => mockGetBookings()).thenAnswer((_) async => Right(allBookings));

      await cubit.loadBookings();
      final stats = cubit.getStats();

      expect(stats['total'], 2);
      expect(stats['pending'], 1);
      expect(stats['confirmed'], 1);
    });
  });
}
