import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/activate_user_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/deactivate_user_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_all_users_usecase.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/user_management/user_management_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/user_management/user_management_state.dart';

// Mock Use Cases
class MockGetAllUsersUseCase extends Mock implements GetAllUsersUseCase {}

class MockActivateUserUseCase extends Mock implements ActivateUserUseCase {}

class MockDeactivateUserUseCase extends Mock implements DeactivateUserUseCase {}

void main() {
  late UserManagementCubit cubit;
  late MockGetAllUsersUseCase mockGetAllUsers;
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
    createdAt: now,
    updatedAt: now,
  );

  final inactiveUser = UserEntity(
    id: 'user-2',
    email: 'inactive@test.com',
    fullName: 'Inactive User',
    role: 'user',
    isActive: false,
    createdAt: now,
    updatedAt: now,
  );

  final allUsers = [testUser, inactiveUser];

  setUp(() {
    mockGetAllUsers = MockGetAllUsersUseCase();
    mockActivateUser = MockActivateUserUseCase();
    mockDeactivateUser = MockDeactivateUserUseCase();

    cubit = UserManagementCubit(
      getAllUsersUseCase: mockGetAllUsers,
      activateUserUseCase: mockActivateUser,
      deactivateUserUseCase: mockDeactivateUser,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('UserManagementCubit', () {
    test('initial state is UserManagementInitial', () {
      expect(cubit.state, const UserManagementInitial());
    });
  });

  group('loadUsers', () {
    blocTest<UserManagementCubit, UserManagementState>(
      'emits [Loading, UsersListLoaded] when loading succeeds',
      build: () {
        when(() => mockGetAllUsers()).thenAnswer((_) async => Right(allUsers));
        return cubit;
      },
      act: (cubit) => cubit.loadUsers(),
      expect: () => [
        isA<UserManagementLoading>().having(
          (s) => s.message,
          'message',
          'Loading users...',
        ),
        isA<UsersListLoaded>().having((s) => s.users.length, 'count', 2),
      ],
    );

    blocTest<UserManagementCubit, UserManagementState>(
      'emits [Loading, Error] when loading fails',
      build: () {
        when(
          () => mockGetAllUsers(),
        ).thenAnswer((_) async => const Left(ServerFailure('Network error')));
        return cubit;
      },
      act: (cubit) => cubit.loadUsers(),
      expect: () => [
        isA<UserManagementLoading>(),
        isA<UserManagementError>().having(
          (s) => s.message,
          'message',
          'Network error',
        ),
      ],
    );
  });

  group('activateUser', () {
    blocTest<UserManagementCubit, UserManagementState>(
      'emits [Loading, UserActivated] and reloads on success',
      build: () {
        when(
          () => mockActivateUser(userId: 'user-2'),
        ).thenAnswer((_) async => const Right(null));
        when(() => mockGetAllUsers()).thenAnswer((_) async => Right(allUsers));
        return cubit;
      },
      act: (cubit) => cubit.activateUser('user-2'),
      expect: () => [
        isA<UserManagementLoading>().having(
          (s) => s.message,
          'message',
          'Activating user...',
        ),
        isA<UserActivated>().having((s) => s.userId, 'userId', 'user-2'),
        isA<UserManagementLoading>(),
        isA<UsersListLoaded>(),
      ],
    );

    blocTest<UserManagementCubit, UserManagementState>(
      'emits Error when activation fails',
      build: () {
        when(() => mockActivateUser(userId: 'user-2')).thenAnswer(
          (_) async => const Left(ServerFailure('Activation failed')),
        );
        return cubit;
      },
      act: (cubit) => cubit.activateUser('user-2'),
      expect: () => [
        isA<UserManagementLoading>(),
        isA<UserManagementError>().having(
          (s) => s.message,
          'message',
          'Activation failed',
        ),
      ],
    );
  });

  group('deactivateUser', () {
    blocTest<UserManagementCubit, UserManagementState>(
      'emits [Loading, UserDeactivated] and reloads on success',
      build: () {
        when(
          () => mockDeactivateUser(userId: 'user-1'),
        ).thenAnswer((_) async => const Right(null));
        when(() => mockGetAllUsers()).thenAnswer((_) async => Right(allUsers));
        return cubit;
      },
      act: (cubit) => cubit.deactivateUser('user-1'),
      expect: () => [
        isA<UserManagementLoading>().having(
          (s) => s.message,
          'message',
          'Deactivating user...',
        ),
        isA<UserDeactivated>().having((s) => s.userId, 'userId', 'user-1'),
        isA<UserManagementLoading>(),
        isA<UsersListLoaded>(),
      ],
    );

    blocTest<UserManagementCubit, UserManagementState>(
      'emits Error when deactivation fails',
      build: () {
        when(() => mockDeactivateUser(userId: 'user-1')).thenAnswer(
          (_) async => const Left(ServerFailure('Deactivation failed')),
        );
        return cubit;
      },
      act: (cubit) => cubit.deactivateUser('user-1'),
      expect: () => [
        isA<UserManagementLoading>(),
        isA<UserManagementError>().having(
          (s) => s.message,
          'message',
          'Deactivation failed',
        ),
      ],
    );
  });

  group('bulkActivateUsers', () {
    blocTest<UserManagementCubit, UserManagementState>(
      'emits [Loading, BulkActionCompleted] and reloads on success',
      build: () {
        when(
          () => mockActivateUser(userId: any(named: 'userId')),
        ).thenAnswer((_) async => const Right(null));
        when(() => mockGetAllUsers()).thenAnswer((_) async => Right(allUsers));
        return cubit;
      },
      act: (cubit) => cubit.bulkActivateUsers(['user-1', 'user-2']),
      expect: () => [
        isA<UserManagementLoading>(),
        isA<BulkActionCompleted>().having(
          (s) => s.message,
          'message',
          'Successfully activated 2 users',
        ),
        isA<UserManagementLoading>(),
        isA<UsersListLoaded>(),
      ],
    );

    blocTest<UserManagementCubit, UserManagementState>(
      'emits Error with partial success when some fail',
      build: () {
        var callCount = 0;
        when(() => mockActivateUser(userId: any(named: 'userId'))).thenAnswer(
          (_) async => ++callCount == 1
              ? const Right(null)
              : const Left(ServerFailure('Failed')),
        );
        when(() => mockGetAllUsers()).thenAnswer((_) async => Right(allUsers));
        return cubit;
      },
      act: (cubit) => cubit.bulkActivateUsers(['user-1', 'user-2']),
      expect: () => [
        isA<UserManagementLoading>(),
        isA<UserManagementError>().having(
          (s) => s.message,
          'message',
          'Activated 1 users, but 1 failed',
        ),
        isA<UserManagementLoading>(),
        isA<UsersListLoaded>(),
      ],
    );
  });

  group('bulkDeactivateUsers', () {
    blocTest<UserManagementCubit, UserManagementState>(
      'emits [Loading, BulkActionCompleted] and reloads on success',
      build: () {
        when(
          () => mockDeactivateUser(userId: any(named: 'userId')),
        ).thenAnswer((_) async => const Right(null));
        when(() => mockGetAllUsers()).thenAnswer((_) async => Right(allUsers));
        return cubit;
      },
      act: (cubit) => cubit.bulkDeactivateUsers(['user-1', 'user-2']),
      expect: () => [
        isA<UserManagementLoading>(),
        isA<BulkActionCompleted>().having(
          (s) => s.message,
          'message',
          'Successfully deactivated 2 users',
        ),
        isA<UserManagementLoading>(),
        isA<UsersListLoaded>(),
      ],
    );

    blocTest<UserManagementCubit, UserManagementState>(
      'emits Error with partial success when some fail',
      build: () {
        var callCount = 0;
        when(() => mockDeactivateUser(userId: any(named: 'userId'))).thenAnswer(
          (_) async => ++callCount == 1
              ? const Right(null)
              : const Left(ServerFailure('Failed')),
        );
        when(() => mockGetAllUsers()).thenAnswer((_) async => Right(allUsers));
        return cubit;
      },
      act: (cubit) => cubit.bulkDeactivateUsers(['user-1', 'user-2']),
      expect: () => [
        isA<UserManagementLoading>(),
        isA<UserManagementError>().having(
          (s) => s.message,
          'message',
          'Deactivated 1 users, but 1 failed',
        ),
        isA<UserManagementLoading>(),
        isA<UsersListLoaded>(),
      ],
    );
  });

  group('reset', () {
    blocTest<UserManagementCubit, UserManagementState>(
      'resets to initial state',
      build: () => cubit,
      seed: () => UsersListLoaded(allUsers),
      act: (cubit) => cubit.reset(),
      expect: () => [const UserManagementInitial()],
    );
  });
}
