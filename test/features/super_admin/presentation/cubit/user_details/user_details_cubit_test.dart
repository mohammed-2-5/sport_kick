import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/activate_user_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/deactivate_user_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_all_bookings_usecase.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/user_details/user_details_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/user_details/user_details_state.dart';

// Mock Use Cases
class MockGetAllBookingsUseCase extends Mock implements GetAllBookingsUseCase {}

class MockActivateUserUseCase extends Mock implements ActivateUserUseCase {}

class MockDeactivateUserUseCase extends Mock implements DeactivateUserUseCase {}

void main() {
  late UserDetailsCubit cubit;
  late MockGetAllBookingsUseCase mockGetAllBookings;
  late MockActivateUserUseCase mockActivateUser;
  late MockDeactivateUserUseCase mockDeactivateUser;

  // Test data
  final now = DateTime.now();
  final testUser = UserEntity(
    id: 'user-1',
    email: 'user@test.com',
    fullName: 'Test User',
    role: 'user',
    isActive: true,
    createdAt: now.subtract(const Duration(days: 30)),
    updatedAt: now,
  );

  final inactiveUser = UserEntity(
    id: 'user-2',
    email: 'inactive@test.com',
    fullName: 'Inactive User',
    role: 'user',
    isActive: false,
    createdAt: now.subtract(const Duration(days: 60)),
    updatedAt: now,
  );

  final userBooking1 = BookingEntity(
    id: 'booking-1',
    userId: 'user-1',
    fieldId: 'field-1',
    date: now,
    startTime: '10:00',
    endTime: '11:00',
    totalPrice: 100,
    currency: 'EGP',
    status: BookingStatus.completed,
    userName: 'Test User',
    fieldName: 'Field A',
    createdAt: now.subtract(const Duration(days: 5)),
  );

  final userBooking2 = BookingEntity(
    id: 'booking-2',
    userId: 'user-1',
    fieldId: 'field-2',
    date: now,
    startTime: '14:00',
    endTime: '15:00',
    totalPrice: 150,
    currency: 'EGP',
    status: BookingStatus.confirmed,
    userName: 'Test User',
    fieldName: 'Field B',
    createdAt: now.subtract(const Duration(days: 2)),
  );

  final otherUserBooking = BookingEntity(
    id: 'booking-3',
    userId: 'user-2',
    fieldId: 'field-1',
    date: now,
    startTime: '16:00',
    endTime: '17:00',
    totalPrice: 100,
    currency: 'EGP',
    status: BookingStatus.pending,
    userName: 'Other User',
    fieldName: 'Field A',
    createdAt: now,
  );

  final allBookings = [userBooking1, userBooking2, otherUserBooking];

  setUp(() {
    mockGetAllBookings = MockGetAllBookingsUseCase();
    mockActivateUser = MockActivateUserUseCase();
    mockDeactivateUser = MockDeactivateUserUseCase();

    cubit = UserDetailsCubit(
      getAllBookingsUseCase: mockGetAllBookings,
      activateUserUseCase: mockActivateUser,
      deactivateUserUseCase: mockDeactivateUser,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('UserDetailsCubit', () {
    test('initial state is UserDetailsLoading', () {
      expect(cubit.state, const UserDetailsLoading());
    });
  });

  group('initialize', () {
    blocTest<UserDetailsCubit, UserDetailsState>(
      'emits [Loading, Loaded] with filtered bookings when loading succeeds',
      build: () {
        when(
          () => mockGetAllBookings(),
        ).thenAnswer((_) async => Right(allBookings));
        return cubit;
      },
      act: (cubit) => cubit.initialize(testUser),
      expect: () => [
        const UserDetailsLoading(),
        isA<UserDetailsLoaded>()
            .having((s) => s.user.id, 'user id', 'user-1')
            .having((s) => s.bookings.length, 'bookings count', 2),
      ],
    );

    blocTest<UserDetailsCubit, UserDetailsState>(
      'emits [Loading, Error] when loading fails',
      build: () {
        when(
          () => mockGetAllBookings(),
        ).thenAnswer((_) async => const Left(ServerFailure('Network error')));
        return cubit;
      },
      act: (cubit) => cubit.initialize(testUser),
      expect: () => [
        const UserDetailsLoading(),
        isA<UserDetailsError>()
            .having((s) => s.message, 'message', 'Network error')
            .having((s) => s.user?.id, 'user id', 'user-1'),
      ],
    );

    blocTest<UserDetailsCubit, UserDetailsState>(
      'correctly computes stats from bookings',
      build: () {
        when(
          () => mockGetAllBookings(),
        ).thenAnswer((_) async => Right(allBookings));
        return cubit;
      },
      act: (cubit) => cubit.initialize(testUser),
      verify: (cubit) {
        final state = cubit.state as UserDetailsLoaded;
        expect(state.stats.totalBookings, 2);
        // totalSpent only counts completed bookings (userBooking1 = 100)
        expect(state.stats.totalSpent, 100.0);
        expect(state.stats.memberDays, greaterThanOrEqualTo(29));
      },
    );
  });

  group('dialog management', () {
    final loadedState = UserDetailsLoaded(
      user: testUser,
      bookings: [userBooking1, userBooking2],
      stats: const UserDetailsStats(),
    );

    blocTest<UserDetailsCubit, UserDetailsState>(
      'showStatusToggleDialog sets dialog visible',
      build: () => UserDetailsCubit(
        getAllBookingsUseCase: mockGetAllBookings,
        activateUserUseCase: mockActivateUser,
        deactivateUserUseCase: mockDeactivateUser,
      ),
      seed: () => loadedState,
      act: (cubit) => cubit.showStatusToggleDialog(),
      expect: () => [
        isA<UserDetailsLoaded>().having(
          (s) => s.showStatusDialog,
          'showStatusDialog',
          true,
        ),
      ],
    );

    blocTest<UserDetailsCubit, UserDetailsState>(
      'hideStatusToggleDialog hides dialog',
      build: () => UserDetailsCubit(
        getAllBookingsUseCase: mockGetAllBookings,
        activateUserUseCase: mockActivateUser,
        deactivateUserUseCase: mockDeactivateUser,
      ),
      seed: () => loadedState.copyWith(showStatusDialog: true),
      act: (cubit) => cubit.hideStatusToggleDialog(),
      expect: () => [
        isA<UserDetailsLoaded>().having(
          (s) => s.showStatusDialog,
          'showStatusDialog',
          false,
        ),
      ],
    );
  });

  group('toggleUserStatus', () {
    final activeLoadedState = UserDetailsLoaded(
      user: testUser,
      bookings: [userBooking1, userBooking2],
      stats: const UserDetailsStats(),
    );

    final inactiveLoadedState = UserDetailsLoaded(
      user: inactiveUser,
      bookings: [],
      stats: const UserDetailsStats(),
    );

    blocTest<UserDetailsCubit, UserDetailsState>(
      'deactivates active user successfully',
      build: () {
        when(
          () => mockDeactivateUser(userId: 'user-1'),
        ).thenAnswer((_) async => const Right(null));
        return UserDetailsCubit(
          getAllBookingsUseCase: mockGetAllBookings,
          activateUserUseCase: mockActivateUser,
          deactivateUserUseCase: mockDeactivateUser,
        );
      },
      seed: () => activeLoadedState,
      act: (cubit) => cubit.toggleUserStatus(),
      expect: () => [
        isA<UserDetailsLoaded>()
            .having((s) => s.isTogglingStatus, 'isTogglingStatus', true)
            .having((s) => s.showStatusDialog, 'showStatusDialog', false),
        isA<UserStatusToggled>()
            .having((s) => s.wasActivated, 'wasActivated', false)
            .having((s) => s.user.isActive, 'isActive', false),
      ],
    );

    blocTest<UserDetailsCubit, UserDetailsState>(
      'activates inactive user successfully',
      build: () {
        when(
          () => mockActivateUser(userId: 'user-2'),
        ).thenAnswer((_) async => const Right(null));
        return UserDetailsCubit(
          getAllBookingsUseCase: mockGetAllBookings,
          activateUserUseCase: mockActivateUser,
          deactivateUserUseCase: mockDeactivateUser,
        );
      },
      seed: () => inactiveLoadedState,
      act: (cubit) => cubit.toggleUserStatus(),
      expect: () => [
        isA<UserDetailsLoaded>().having(
          (s) => s.isTogglingStatus,
          'isTogglingStatus',
          true,
        ),
        isA<UserStatusToggled>()
            .having((s) => s.wasActivated, 'wasActivated', true)
            .having((s) => s.user.isActive, 'isActive', true),
      ],
    );

    blocTest<UserDetailsCubit, UserDetailsState>(
      'emits Error when toggle fails',
      build: () {
        when(
          () => mockDeactivateUser(userId: 'user-1'),
        ).thenAnswer((_) async => const Left(ServerFailure('Toggle failed')));
        return UserDetailsCubit(
          getAllBookingsUseCase: mockGetAllBookings,
          activateUserUseCase: mockActivateUser,
          deactivateUserUseCase: mockDeactivateUser,
        );
      },
      seed: () => activeLoadedState,
      act: (cubit) => cubit.toggleUserStatus(),
      expect: () => [
        isA<UserDetailsLoaded>(),
        isA<UserDetailsError>().having(
          (s) => s.message,
          'message',
          'Toggle failed',
        ),
      ],
    );
  });

  group('restoreAfterToggle', () {
    test('restores to loaded state with updated data', () {
      cubit.restoreAfterToggle(testUser, [userBooking1, userBooking2]);

      expect(cubit.state, isA<UserDetailsLoaded>());
      final state = cubit.state as UserDetailsLoaded;
      expect(state.user.id, 'user-1');
      expect(state.bookings.length, 2);
    });
  });

  group('helper methods', () {
    test('getMemberSinceFormatted returns correct format', () {
      final date = DateTime(2024, 3, 15);
      final formatted = cubit.getMemberSinceFormatted(date);
      expect(formatted, 'Mar 15, 2024');
    });

    test('getStatusColorIndex returns correct values', () {
      expect(cubit.getStatusColorIndex('completed'), 0);
      expect(cubit.getStatusColorIndex('confirmed'), 1);
      expect(cubit.getStatusColorIndex('pending'), 2);
      expect(cubit.getStatusColorIndex('cancelled'), 3);
      expect(cubit.getStatusColorIndex('unknown'), 4);
    });

    test('getStatusColorIndex is case insensitive', () {
      expect(cubit.getStatusColorIndex('COMPLETED'), 0);
      expect(cubit.getStatusColorIndex('Confirmed'), 1);
      expect(cubit.getStatusColorIndex('PENDING'), 2);
    });
  });
}
