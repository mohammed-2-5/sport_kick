import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/activate_user_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/deactivate_user_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_all_users_usecase.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/users_list/super_admin_users_list_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/users_list/super_admin_users_list_state.dart';

// Mock Use Cases
class MockGetAllUsersUseCase extends Mock implements GetAllUsersUseCase {}

class MockActivateUserUseCase extends Mock implements ActivateUserUseCase {}

class MockDeactivateUserUseCase extends Mock implements DeactivateUserUseCase {}

void main() {
  late SuperAdminUsersListCubit cubit;
  late MockGetAllUsersUseCase mockGetAllUsers;
  late MockActivateUserUseCase mockActivateUser;
  late MockDeactivateUserUseCase mockDeactivateUser;

  // Test data
  final now = DateTime.now();
  final activeUser = UserEntity(
    id: 'user-1',
    email: 'active@test.com',
    fullName: 'Active User',
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

  final userWithPhone = UserEntity(
    id: 'user-3',
    email: 'phone@test.com',
    fullName: 'User With Phone',
    phone: '0123456789',
    role: 'user',
    isActive: true,
    createdAt: now,
    updatedAt: now,
  );

  final allUsers = [activeUser, inactiveUser, userWithPhone];

  setUp(() {
    mockGetAllUsers = MockGetAllUsersUseCase();
    mockActivateUser = MockActivateUserUseCase();
    mockDeactivateUser = MockDeactivateUserUseCase();

    cubit = SuperAdminUsersListCubit(
      getAllUsersUseCase: mockGetAllUsers,
      activateUserUseCase: mockActivateUser,
      deactivateUserUseCase: mockDeactivateUser,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('SuperAdminUsersListCubit', () {
    test('initial state is SuperAdminUsersListLoading', () {
      expect(cubit.state, const SuperAdminUsersListLoading());
    });

    test('getStats returns zeros when not loaded', () {
      final stats = cubit.getStats();
      expect(stats['total'], 0);
      expect(stats['active'], 0);
      expect(stats['inactive'], 0);
    });
  });

  group('loadUsers', () {
    blocTest<SuperAdminUsersListCubit, SuperAdminUsersListState>(
      'emits [Loading, Loaded] when loading succeeds',
      build: () {
        when(() => mockGetAllUsers()).thenAnswer((_) async => Right(allUsers));
        return cubit;
      },
      act: (cubit) => cubit.loadUsers(),
      expect: () => [
        const SuperAdminUsersListLoading(),
        isA<SuperAdminUsersListLoaded>().having(
          (s) => s.allUsers.length,
          'count',
          3,
        ),
      ],
    );

    blocTest<SuperAdminUsersListCubit, SuperAdminUsersListState>(
      'emits [Loading, Error] when loading fails',
      build: () {
        when(
          () => mockGetAllUsers(),
        ).thenAnswer((_) async => const Left(ServerFailure('Network error')));
        return cubit;
      },
      act: (cubit) => cubit.loadUsers(),
      expect: () => [
        const SuperAdminUsersListLoading(),
        isA<SuperAdminUsersListError>().having(
          (s) => s.message,
          'message',
          'Network error',
        ),
      ],
    );
  });

  group('refresh', () {
    final loadedState = SuperAdminUsersListLoaded(allUsers: allUsers);

    blocTest<SuperAdminUsersListCubit, SuperAdminUsersListState>(
      'sets isRefreshing and reloads users',
      build: () {
        when(() => mockGetAllUsers()).thenAnswer((_) async => Right(allUsers));
        return SuperAdminUsersListCubit(
          getAllUsersUseCase: mockGetAllUsers,
          activateUserUseCase: mockActivateUser,
          deactivateUserUseCase: mockDeactivateUser,
        );
      },
      seed: () => loadedState,
      act: (cubit) => cubit.refresh(),
      expect: () => [
        isA<SuperAdminUsersListLoaded>().having(
          (s) => s.isRefreshing,
          'isRefreshing',
          true,
        ),
        const SuperAdminUsersListLoading(),
        isA<SuperAdminUsersListLoaded>(),
      ],
    );
  });

  group('search', () {
    final loadedState = SuperAdminUsersListLoaded(allUsers: allUsers);

    blocTest<SuperAdminUsersListCubit, SuperAdminUsersListState>(
      'updates search query',
      build: () => SuperAdminUsersListCubit(
        getAllUsersUseCase: mockGetAllUsers,
        activateUserUseCase: mockActivateUser,
        deactivateUserUseCase: mockDeactivateUser,
      ),
      seed: () => loadedState,
      act: (cubit) => cubit.search('Active'),
      expect: () => [
        isA<SuperAdminUsersListLoaded>().having(
          (s) => s.searchQuery,
          'searchQuery',
          'Active',
        ),
      ],
    );
  });

  group('clearSearch', () {
    final loadedState = SuperAdminUsersListLoaded(
      allUsers: allUsers,
      searchQuery: 'test',
    );

    blocTest<SuperAdminUsersListCubit, SuperAdminUsersListState>(
      'clears search query',
      build: () => SuperAdminUsersListCubit(
        getAllUsersUseCase: mockGetAllUsers,
        activateUserUseCase: mockActivateUser,
        deactivateUserUseCase: mockDeactivateUser,
      ),
      seed: () => loadedState,
      act: (cubit) => cubit.clearSearch(),
      expect: () => [
        isA<SuperAdminUsersListLoaded>().having(
          (s) => s.searchQuery,
          'searchQuery',
          '',
        ),
      ],
    );
  });

  group('filterByStatus', () {
    final loadedState = SuperAdminUsersListLoaded(allUsers: allUsers);

    blocTest<SuperAdminUsersListCubit, SuperAdminUsersListState>(
      'filters by Active status',
      build: () => SuperAdminUsersListCubit(
        getAllUsersUseCase: mockGetAllUsers,
        activateUserUseCase: mockActivateUser,
        deactivateUserUseCase: mockDeactivateUser,
      ),
      seed: () => loadedState,
      act: (cubit) => cubit.filterByStatus('Active'),
      expect: () => [
        isA<SuperAdminUsersListLoaded>().having(
          (s) => s.statusFilter,
          'statusFilter',
          'Active',
        ),
      ],
    );

    blocTest<SuperAdminUsersListCubit, SuperAdminUsersListState>(
      'clears filter when null is passed',
      build: () => SuperAdminUsersListCubit(
        getAllUsersUseCase: mockGetAllUsers,
        activateUserUseCase: mockActivateUser,
        deactivateUserUseCase: mockDeactivateUser,
      ),
      seed: () => loadedState.copyWith(statusFilter: 'Active'),
      act: (cubit) => cubit.filterByStatus(null),
      expect: () => [
        isA<SuperAdminUsersListLoaded>().having(
          (s) => s.statusFilter,
          'statusFilter',
          isNull,
        ),
      ],
    );
  });

  group('selection mode', () {
    final loadedState = SuperAdminUsersListLoaded(allUsers: allUsers);

    blocTest<SuperAdminUsersListCubit, SuperAdminUsersListState>(
      'toggleSelectionMode enables selection mode',
      build: () => SuperAdminUsersListCubit(
        getAllUsersUseCase: mockGetAllUsers,
        activateUserUseCase: mockActivateUser,
        deactivateUserUseCase: mockDeactivateUser,
      ),
      seed: () => loadedState,
      act: (cubit) => cubit.toggleSelectionMode(),
      expect: () => [
        isA<SuperAdminUsersListLoaded>().having(
          (s) => s.isSelectionMode,
          'isSelectionMode',
          true,
        ),
      ],
    );

    blocTest<SuperAdminUsersListCubit, SuperAdminUsersListState>(
      'toggleSelection adds user to selection',
      build: () => SuperAdminUsersListCubit(
        getAllUsersUseCase: mockGetAllUsers,
        activateUserUseCase: mockActivateUser,
        deactivateUserUseCase: mockDeactivateUser,
      ),
      seed: () => loadedState.copyWith(isSelectionMode: true),
      act: (cubit) => cubit.toggleSelection('user-1'),
      expect: () => [
        isA<SuperAdminUsersListLoaded>().having(
          (s) => s.selectedIds,
          'selectedIds',
          {'user-1'},
        ),
      ],
    );

    blocTest<SuperAdminUsersListCubit, SuperAdminUsersListState>(
      'selectAll selects all filtered users',
      build: () => SuperAdminUsersListCubit(
        getAllUsersUseCase: mockGetAllUsers,
        activateUserUseCase: mockActivateUser,
        deactivateUserUseCase: mockDeactivateUser,
      ),
      seed: () => loadedState.copyWith(isSelectionMode: true),
      act: (cubit) => cubit.selectAll(),
      expect: () => [
        isA<SuperAdminUsersListLoaded>().having(
          (s) => s.selectedIds,
          'selectedIds',
          {'user-1', 'user-2', 'user-3'},
        ),
      ],
    );

    blocTest<SuperAdminUsersListCubit, SuperAdminUsersListState>(
      'deselectAll clears all selections',
      build: () => SuperAdminUsersListCubit(
        getAllUsersUseCase: mockGetAllUsers,
        activateUserUseCase: mockActivateUser,
        deactivateUserUseCase: mockDeactivateUser,
      ),
      seed: () => loadedState.copyWith(
        isSelectionMode: true,
        selectedIds: {'user-1', 'user-2'},
      ),
      act: (cubit) => cubit.deselectAll(),
      expect: () => [
        isA<SuperAdminUsersListLoaded>().having(
          (s) => s.selectedIds,
          'selectedIds',
          isEmpty,
        ),
      ],
    );
  });

  group('activateUser', () {
    blocTest<SuperAdminUsersListCubit, SuperAdminUsersListState>(
      'emits ActionSuccess and reloads on success',
      build: () {
        when(
          () => mockActivateUser(userId: 'user-2'),
        ).thenAnswer((_) async => const Right(null));
        when(() => mockGetAllUsers()).thenAnswer((_) async => Right(allUsers));
        return cubit;
      },
      act: (cubit) => cubit.activateUser('user-2'),
      expect: () => [
        const SuperAdminUsersListActionSuccess('User activated'),
        const SuperAdminUsersListLoading(),
        isA<SuperAdminUsersListLoaded>(),
      ],
    );

    blocTest<SuperAdminUsersListCubit, SuperAdminUsersListState>(
      'emits Error on failure',
      build: () {
        when(
          () => mockActivateUser(userId: 'user-2'),
        ).thenAnswer((_) async => const Left(ServerFailure('Failed')));
        return cubit;
      },
      act: (cubit) => cubit.activateUser('user-2'),
      expect: () => [const SuperAdminUsersListError('Failed')],
    );
  });

  group('deactivateUser', () {
    blocTest<SuperAdminUsersListCubit, SuperAdminUsersListState>(
      'emits ActionSuccess and reloads on success',
      build: () {
        when(
          () => mockDeactivateUser(userId: 'user-1'),
        ).thenAnswer((_) async => const Right(null));
        when(() => mockGetAllUsers()).thenAnswer((_) async => Right(allUsers));
        return cubit;
      },
      act: (cubit) => cubit.deactivateUser('user-1'),
      expect: () => [
        const SuperAdminUsersListActionSuccess('User deactivated'),
        const SuperAdminUsersListLoading(),
        isA<SuperAdminUsersListLoaded>(),
      ],
    );
  });

  group('bulkActivateUsers', () {
    blocTest<SuperAdminUsersListCubit, SuperAdminUsersListState>(
      'emits ActionSuccess when all succeed',
      build: () {
        when(
          () => mockActivateUser(userId: any(named: 'userId')),
        ).thenAnswer((_) async => const Right(null));
        when(() => mockGetAllUsers()).thenAnswer((_) async => Right(allUsers));
        return cubit;
      },
      act: (cubit) => cubit.bulkActivateUsers(['user-1', 'user-2']),
      expect: () => [
        const SuperAdminUsersListActionSuccess('Activated 2 users'),
        const SuperAdminUsersListLoading(),
        isA<SuperAdminUsersListLoaded>(),
      ],
    );

    blocTest<SuperAdminUsersListCubit, SuperAdminUsersListState>(
      'emits Error when all fail',
      build: () {
        when(
          () => mockActivateUser(userId: any(named: 'userId')),
        ).thenAnswer((_) async => const Left(ServerFailure('Failed')));
        when(() => mockGetAllUsers()).thenAnswer((_) async => Right(allUsers));
        return cubit;
      },
      act: (cubit) => cubit.bulkActivateUsers(['user-1', 'user-2']),
      expect: () => [
        const SuperAdminUsersListError('Failed to activate users'),
        const SuperAdminUsersListLoading(),
        isA<SuperAdminUsersListLoaded>(),
      ],
    );
  });

  group('bulkDeactivateUsers', () {
    blocTest<SuperAdminUsersListCubit, SuperAdminUsersListState>(
      'emits ActionSuccess when all succeed',
      build: () {
        when(
          () => mockDeactivateUser(userId: any(named: 'userId')),
        ).thenAnswer((_) async => const Right(null));
        when(() => mockGetAllUsers()).thenAnswer((_) async => Right(allUsers));
        return cubit;
      },
      act: (cubit) => cubit.bulkDeactivateUsers(['user-1', 'user-2']),
      expect: () => [
        const SuperAdminUsersListActionSuccess('Deactivated 2 users'),
        const SuperAdminUsersListLoading(),
        isA<SuperAdminUsersListLoaded>(),
      ],
    );
  });

  group('getStats', () {
    test('returns correct stats when loaded', () async {
      when(() => mockGetAllUsers()).thenAnswer((_) async => Right(allUsers));

      await cubit.loadUsers();
      final stats = cubit.getStats();

      expect(stats['total'], 3);
      expect(stats['active'], 2);
      expect(stats['inactive'], 1);
    });
  });
}
