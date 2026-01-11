import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/activate_user_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/deactivate_user_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_all_admins_usecase.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/admins_list/super_admin_admins_list_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/admins_list/super_admin_admins_list_state.dart';

// Mock Use Cases
class MockGetAllAdminsUseCase extends Mock implements GetAllAdminsUseCase {}

class MockActivateUserUseCase extends Mock implements ActivateUserUseCase {}

class MockDeactivateUserUseCase extends Mock implements DeactivateUserUseCase {}

void main() {
  late SuperAdminAdminsListCubit cubit;
  late MockGetAllAdminsUseCase mockGetAllAdmins;
  late MockActivateUserUseCase mockActivateUser;
  late MockDeactivateUserUseCase mockDeactivateUser;

  // Test data
  final now = DateTime.now();
  final activeAdmin = UserEntity(
    id: 'admin-1',
    email: 'admin1@test.com',
    fullName: 'Active Admin',
    role: 'admin',
    isActive: true,
    createdAt: now,
    updatedAt: now,
  );

  final inactiveAdmin = UserEntity(
    id: 'admin-2',
    email: 'admin2@test.com',
    fullName: 'Inactive Admin',
    role: 'admin',
    isActive: false,
    createdAt: now,
    updatedAt: now,
  );

  final adminWithPhone = UserEntity(
    id: 'admin-3',
    email: 'admin3@test.com',
    fullName: 'Admin With Phone',
    phone: '0123456789',
    role: 'admin',
    isActive: true,
    createdAt: now,
    updatedAt: now,
  );

  final allAdmins = [activeAdmin, inactiveAdmin, adminWithPhone];

  setUp(() {
    mockGetAllAdmins = MockGetAllAdminsUseCase();
    mockActivateUser = MockActivateUserUseCase();
    mockDeactivateUser = MockDeactivateUserUseCase();

    cubit = SuperAdminAdminsListCubit(
      getAllAdminsUseCase: mockGetAllAdmins,
      activateUserUseCase: mockActivateUser,
      deactivateUserUseCase: mockDeactivateUser,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('SuperAdminAdminsListCubit', () {
    test('initial state is SuperAdminAdminsListLoading', () {
      expect(cubit.state, const SuperAdminAdminsListLoading());
    });

    test('getStats returns zeros when not loaded', () {
      final stats = cubit.getStats();
      expect(stats['total'], 0);
      expect(stats['active'], 0);
      expect(stats['inactive'], 0);
    });
  });

  group('loadAdmins', () {
    blocTest<SuperAdminAdminsListCubit, SuperAdminAdminsListState>(
      'emits [Loading, Loaded] when admins load successfully',
      build: () {
        when(
          () => mockGetAllAdmins(),
        ).thenAnswer((_) async => Right(allAdmins));
        return cubit;
      },
      act: (cubit) => cubit.loadAdmins(),
      expect: () => [
        const SuperAdminAdminsListLoading(),
        isA<SuperAdminAdminsListLoaded>().having(
          (s) => s.allAdmins.length,
          'admins count',
          3,
        ),
      ],
    );

    blocTest<SuperAdminAdminsListCubit, SuperAdminAdminsListState>(
      'emits [Loading, Error] when loading fails',
      build: () {
        when(
          () => mockGetAllAdmins(),
        ).thenAnswer((_) async => const Left(ServerFailure('Network error')));
        return cubit;
      },
      act: (cubit) => cubit.loadAdmins(),
      expect: () => [
        const SuperAdminAdminsListLoading(),
        const SuperAdminAdminsListError('Network error'),
      ],
    );

    blocTest<SuperAdminAdminsListCubit, SuperAdminAdminsListState>(
      'emits [Loading, Error] when exception is thrown',
      build: () {
        when(() => mockGetAllAdmins()).thenThrow(Exception('Unexpected error'));
        return cubit;
      },
      act: (cubit) => cubit.loadAdmins(),
      expect: () => [
        const SuperAdminAdminsListLoading(),
        isA<SuperAdminAdminsListError>().having(
          (s) => s.message,
          'message',
          contains('Exception'),
        ),
      ],
    );
  });

  group('refresh', () {
    final loadedState = SuperAdminAdminsListLoaded(allAdmins: allAdmins);

    blocTest<SuperAdminAdminsListCubit, SuperAdminAdminsListState>(
      'sets isRefreshing to true then reloads admins',
      build: () {
        when(
          () => mockGetAllAdmins(),
        ).thenAnswer((_) async => Right(allAdmins));
        return SuperAdminAdminsListCubit(
          getAllAdminsUseCase: mockGetAllAdmins,
          activateUserUseCase: mockActivateUser,
          deactivateUserUseCase: mockDeactivateUser,
        );
      },
      seed: () => loadedState,
      act: (cubit) => cubit.refresh(),
      expect: () => [
        isA<SuperAdminAdminsListLoaded>().having(
          (s) => s.isRefreshing,
          'isRefreshing',
          true,
        ),
        const SuperAdminAdminsListLoading(),
        isA<SuperAdminAdminsListLoaded>(),
      ],
    );
  });

  group('search', () {
    final loadedState = SuperAdminAdminsListLoaded(allAdmins: allAdmins);

    blocTest<SuperAdminAdminsListCubit, SuperAdminAdminsListState>(
      'updates search query',
      build: () => SuperAdminAdminsListCubit(
        getAllAdminsUseCase: mockGetAllAdmins,
        activateUserUseCase: mockActivateUser,
        deactivateUserUseCase: mockDeactivateUser,
      ),
      seed: () => loadedState,
      act: (cubit) => cubit.search('Active'),
      expect: () => [
        isA<SuperAdminAdminsListLoaded>().having(
          (s) => s.searchQuery,
          'searchQuery',
          'Active',
        ),
      ],
    );

    blocTest<SuperAdminAdminsListCubit, SuperAdminAdminsListState>(
      'does nothing when not in loaded state',
      build: () => SuperAdminAdminsListCubit(
        getAllAdminsUseCase: mockGetAllAdmins,
        activateUserUseCase: mockActivateUser,
        deactivateUserUseCase: mockDeactivateUser,
      ),
      act: (cubit) => cubit.search('test'),
      expect: () => [],
    );
  });

  group('clearSearch', () {
    final loadedState = SuperAdminAdminsListLoaded(
      allAdmins: allAdmins,
      searchQuery: 'existing search',
    );

    blocTest<SuperAdminAdminsListCubit, SuperAdminAdminsListState>(
      'clears search query',
      build: () => SuperAdminAdminsListCubit(
        getAllAdminsUseCase: mockGetAllAdmins,
        activateUserUseCase: mockActivateUser,
        deactivateUserUseCase: mockDeactivateUser,
      ),
      seed: () => loadedState,
      act: (cubit) => cubit.clearSearch(),
      expect: () => [
        isA<SuperAdminAdminsListLoaded>().having(
          (s) => s.searchQuery,
          'searchQuery',
          '',
        ),
      ],
    );
  });

  group('filterByStatus', () {
    final loadedState = SuperAdminAdminsListLoaded(allAdmins: allAdmins);

    blocTest<SuperAdminAdminsListCubit, SuperAdminAdminsListState>(
      'filters by Active status',
      build: () => SuperAdminAdminsListCubit(
        getAllAdminsUseCase: mockGetAllAdmins,
        activateUserUseCase: mockActivateUser,
        deactivateUserUseCase: mockDeactivateUser,
      ),
      seed: () => loadedState,
      act: (cubit) => cubit.filterByStatus('Active'),
      expect: () => [
        isA<SuperAdminAdminsListLoaded>().having(
          (s) => s.statusFilter,
          'statusFilter',
          'Active',
        ),
      ],
    );

    blocTest<SuperAdminAdminsListCubit, SuperAdminAdminsListState>(
      'filters by Inactive status',
      build: () => SuperAdminAdminsListCubit(
        getAllAdminsUseCase: mockGetAllAdmins,
        activateUserUseCase: mockActivateUser,
        deactivateUserUseCase: mockDeactivateUser,
      ),
      seed: () => loadedState,
      act: (cubit) => cubit.filterByStatus('Inactive'),
      expect: () => [
        isA<SuperAdminAdminsListLoaded>().having(
          (s) => s.statusFilter,
          'statusFilter',
          'Inactive',
        ),
      ],
    );

    blocTest<SuperAdminAdminsListCubit, SuperAdminAdminsListState>(
      'clears filter when null is passed',
      build: () => SuperAdminAdminsListCubit(
        getAllAdminsUseCase: mockGetAllAdmins,
        activateUserUseCase: mockActivateUser,
        deactivateUserUseCase: mockDeactivateUser,
      ),
      seed: () => loadedState.copyWith(statusFilter: 'Active'),
      act: (cubit) => cubit.filterByStatus(null),
      expect: () => [
        isA<SuperAdminAdminsListLoaded>().having(
          (s) => s.statusFilter,
          'statusFilter',
          isNull,
        ),
      ],
    );
  });

  group('selection mode', () {
    final loadedState = SuperAdminAdminsListLoaded(allAdmins: allAdmins);

    blocTest<SuperAdminAdminsListCubit, SuperAdminAdminsListState>(
      'toggleSelectionMode enables selection mode',
      build: () => SuperAdminAdminsListCubit(
        getAllAdminsUseCase: mockGetAllAdmins,
        activateUserUseCase: mockActivateUser,
        deactivateUserUseCase: mockDeactivateUser,
      ),
      seed: () => loadedState,
      act: (cubit) => cubit.toggleSelectionMode(),
      expect: () => [
        isA<SuperAdminAdminsListLoaded>()
            .having((s) => s.isSelectionMode, 'isSelectionMode', true)
            .having((s) => s.selectedIds, 'selectedIds', isEmpty),
      ],
    );

    blocTest<SuperAdminAdminsListCubit, SuperAdminAdminsListState>(
      'toggleSelectionMode disables selection mode and clears selection',
      build: () => SuperAdminAdminsListCubit(
        getAllAdminsUseCase: mockGetAllAdmins,
        activateUserUseCase: mockActivateUser,
        deactivateUserUseCase: mockDeactivateUser,
      ),
      seed: () => loadedState.copyWith(
        isSelectionMode: true,
        selectedIds: {'admin-1', 'admin-2'},
      ),
      act: (cubit) => cubit.toggleSelectionMode(),
      expect: () => [
        isA<SuperAdminAdminsListLoaded>()
            .having((s) => s.isSelectionMode, 'isSelectionMode', false)
            .having((s) => s.selectedIds, 'selectedIds', isEmpty),
      ],
    );

    blocTest<SuperAdminAdminsListCubit, SuperAdminAdminsListState>(
      'toggleSelection adds admin to selection',
      build: () => SuperAdminAdminsListCubit(
        getAllAdminsUseCase: mockGetAllAdmins,
        activateUserUseCase: mockActivateUser,
        deactivateUserUseCase: mockDeactivateUser,
      ),
      seed: () => loadedState.copyWith(isSelectionMode: true),
      act: (cubit) => cubit.toggleSelection('admin-1'),
      expect: () => [
        isA<SuperAdminAdminsListLoaded>().having(
          (s) => s.selectedIds,
          'selectedIds',
          {'admin-1'},
        ),
      ],
    );

    blocTest<SuperAdminAdminsListCubit, SuperAdminAdminsListState>(
      'toggleSelection removes admin from selection if already selected',
      build: () => SuperAdminAdminsListCubit(
        getAllAdminsUseCase: mockGetAllAdmins,
        activateUserUseCase: mockActivateUser,
        deactivateUserUseCase: mockDeactivateUser,
      ),
      seed: () =>
          loadedState.copyWith(isSelectionMode: true, selectedIds: {'admin-1'}),
      act: (cubit) => cubit.toggleSelection('admin-1'),
      expect: () => [
        isA<SuperAdminAdminsListLoaded>().having(
          (s) => s.selectedIds,
          'selectedIds',
          isEmpty,
        ),
      ],
    );

    blocTest<SuperAdminAdminsListCubit, SuperAdminAdminsListState>(
      'selectAll selects all filtered admins',
      build: () => SuperAdminAdminsListCubit(
        getAllAdminsUseCase: mockGetAllAdmins,
        activateUserUseCase: mockActivateUser,
        deactivateUserUseCase: mockDeactivateUser,
      ),
      seed: () => loadedState.copyWith(isSelectionMode: true),
      act: (cubit) => cubit.selectAll(),
      expect: () => [
        isA<SuperAdminAdminsListLoaded>().having(
          (s) => s.selectedIds,
          'selectedIds',
          {'admin-1', 'admin-2', 'admin-3'},
        ),
      ],
    );

    blocTest<SuperAdminAdminsListCubit, SuperAdminAdminsListState>(
      'deselectAll clears all selections',
      build: () => SuperAdminAdminsListCubit(
        getAllAdminsUseCase: mockGetAllAdmins,
        activateUserUseCase: mockActivateUser,
        deactivateUserUseCase: mockDeactivateUser,
      ),
      seed: () => loadedState.copyWith(
        isSelectionMode: true,
        selectedIds: {'admin-1', 'admin-2'},
      ),
      act: (cubit) => cubit.deselectAll(),
      expect: () => [
        isA<SuperAdminAdminsListLoaded>().having(
          (s) => s.selectedIds,
          'selectedIds',
          isEmpty,
        ),
      ],
    );
  });

  group('activateAdmin', () {
    blocTest<SuperAdminAdminsListCubit, SuperAdminAdminsListState>(
      'emits ActionSuccess and reloads on success',
      build: () {
        when(
          () => mockActivateUser(userId: 'admin-2'),
        ).thenAnswer((_) async => const Right(null));
        when(
          () => mockGetAllAdmins(),
        ).thenAnswer((_) async => Right(allAdmins));
        return cubit;
      },
      act: (cubit) => cubit.activateAdmin('admin-2'),
      expect: () => [
        const SuperAdminAdminsListActionSuccess('Admin activated'),
        const SuperAdminAdminsListLoading(),
        isA<SuperAdminAdminsListLoaded>(),
      ],
    );

    blocTest<SuperAdminAdminsListCubit, SuperAdminAdminsListState>(
      'emits Error on failure',
      build: () {
        when(() => mockActivateUser(userId: 'admin-2')).thenAnswer(
          (_) async => const Left(ServerFailure('Activation failed')),
        );
        return cubit;
      },
      act: (cubit) => cubit.activateAdmin('admin-2'),
      expect: () => [const SuperAdminAdminsListError('Activation failed')],
    );
  });

  group('deactivateAdmin', () {
    blocTest<SuperAdminAdminsListCubit, SuperAdminAdminsListState>(
      'emits ActionSuccess and reloads on success',
      build: () {
        when(
          () => mockDeactivateUser(userId: 'admin-1'),
        ).thenAnswer((_) async => const Right(null));
        when(
          () => mockGetAllAdmins(),
        ).thenAnswer((_) async => Right(allAdmins));
        return cubit;
      },
      act: (cubit) => cubit.deactivateAdmin('admin-1'),
      expect: () => [
        const SuperAdminAdminsListActionSuccess('Admin deactivated'),
        const SuperAdminAdminsListLoading(),
        isA<SuperAdminAdminsListLoaded>(),
      ],
    );

    blocTest<SuperAdminAdminsListCubit, SuperAdminAdminsListState>(
      'emits Error on failure',
      build: () {
        when(() => mockDeactivateUser(userId: 'admin-1')).thenAnswer(
          (_) async => const Left(ServerFailure('Deactivation failed')),
        );
        return cubit;
      },
      act: (cubit) => cubit.deactivateAdmin('admin-1'),
      expect: () => [const SuperAdminAdminsListError('Deactivation failed')],
    );
  });

  group('bulkActivateAdmins', () {
    blocTest<SuperAdminAdminsListCubit, SuperAdminAdminsListState>(
      'emits ActionSuccess with count when all succeed',
      build: () {
        when(
          () => mockActivateUser(userId: any(named: 'userId')),
        ).thenAnswer((_) async => const Right(null));
        when(
          () => mockGetAllAdmins(),
        ).thenAnswer((_) async => Right(allAdmins));
        return cubit;
      },
      act: (cubit) => cubit.bulkActivateAdmins(['admin-1', 'admin-2']),
      expect: () => [
        const SuperAdminAdminsListActionSuccess('Activated 2 admins'),
        const SuperAdminAdminsListLoading(),
        isA<SuperAdminAdminsListLoaded>(),
      ],
    );

    blocTest<SuperAdminAdminsListCubit, SuperAdminAdminsListState>(
      'emits ActionSuccess with singular text for single admin',
      build: () {
        when(
          () => mockActivateUser(userId: any(named: 'userId')),
        ).thenAnswer((_) async => const Right(null));
        when(
          () => mockGetAllAdmins(),
        ).thenAnswer((_) async => Right(allAdmins));
        return cubit;
      },
      act: (cubit) => cubit.bulkActivateAdmins(['admin-1']),
      expect: () => [
        const SuperAdminAdminsListActionSuccess('Activated 1 admin'),
        const SuperAdminAdminsListLoading(),
        isA<SuperAdminAdminsListLoaded>(),
      ],
    );

    blocTest<SuperAdminAdminsListCubit, SuperAdminAdminsListState>(
      'emits Error when all fail',
      build: () {
        when(
          () => mockActivateUser(userId: any(named: 'userId')),
        ).thenAnswer((_) async => const Left(ServerFailure('Failed')));
        when(
          () => mockGetAllAdmins(),
        ).thenAnswer((_) async => Right(allAdmins));
        return cubit;
      },
      act: (cubit) => cubit.bulkActivateAdmins(['admin-1', 'admin-2']),
      expect: () => [
        const SuperAdminAdminsListError('Failed to activate admins'),
        const SuperAdminAdminsListLoading(),
        isA<SuperAdminAdminsListLoaded>(),
      ],
    );
  });

  group('bulkDeactivateAdmins', () {
    blocTest<SuperAdminAdminsListCubit, SuperAdminAdminsListState>(
      'emits ActionSuccess with count when all succeed',
      build: () {
        when(
          () => mockDeactivateUser(userId: any(named: 'userId')),
        ).thenAnswer((_) async => const Right(null));
        when(
          () => mockGetAllAdmins(),
        ).thenAnswer((_) async => Right(allAdmins));
        return cubit;
      },
      act: (cubit) => cubit.bulkDeactivateAdmins(['admin-1', 'admin-2']),
      expect: () => [
        const SuperAdminAdminsListActionSuccess('Deactivated 2 admins'),
        const SuperAdminAdminsListLoading(),
        isA<SuperAdminAdminsListLoaded>(),
      ],
    );

    blocTest<SuperAdminAdminsListCubit, SuperAdminAdminsListState>(
      'emits Error when all fail',
      build: () {
        when(
          () => mockDeactivateUser(userId: any(named: 'userId')),
        ).thenAnswer((_) async => const Left(ServerFailure('Failed')));
        when(
          () => mockGetAllAdmins(),
        ).thenAnswer((_) async => Right(allAdmins));
        return cubit;
      },
      act: (cubit) => cubit.bulkDeactivateAdmins(['admin-1', 'admin-2']),
      expect: () => [
        const SuperAdminAdminsListError('Failed to deactivate admins'),
        const SuperAdminAdminsListLoading(),
        isA<SuperAdminAdminsListLoaded>(),
      ],
    );
  });

  group('getStats', () {
    test('returns correct stats when loaded', () async {
      when(() => mockGetAllAdmins()).thenAnswer((_) async => Right(allAdmins));

      await cubit.loadAdmins();
      final stats = cubit.getStats();

      expect(stats['total'], 3);
      expect(stats['active'], 2);
      expect(stats['inactive'], 1);
    });
  });

  group('SuperAdminAdminsListLoaded', () {
    test('filteredAdmins returns all when no filters', () {
      final state = SuperAdminAdminsListLoaded(allAdmins: allAdmins);
      expect(state.filteredAdmins.length, 3);
    });

    test('filteredAdmins filters by search query on name', () {
      final state = SuperAdminAdminsListLoaded(
        allAdmins: allAdmins,
        searchQuery: 'active',
      );
      expect(state.filteredAdmins.length, 2);
    });

    test('filteredAdmins filters by search query on email', () {
      final state = SuperAdminAdminsListLoaded(
        allAdmins: allAdmins,
        searchQuery: 'admin1@',
      );
      expect(state.filteredAdmins.length, 1);
      expect(state.filteredAdmins.first.id, 'admin-1');
    });

    test('filteredAdmins filters by search query on phone', () {
      final state = SuperAdminAdminsListLoaded(
        allAdmins: allAdmins,
        searchQuery: '0123',
      );
      expect(state.filteredAdmins.length, 1);
      expect(state.filteredAdmins.first.id, 'admin-3');
    });

    test('filteredAdmins filters by Active status', () {
      final state = SuperAdminAdminsListLoaded(
        allAdmins: allAdmins,
        statusFilter: 'Active',
      );
      expect(state.filteredAdmins.length, 2);
      expect(state.filteredAdmins.every((a) => a.isActive), true);
    });

    test('filteredAdmins filters by Inactive status', () {
      final state = SuperAdminAdminsListLoaded(
        allAdmins: allAdmins,
        statusFilter: 'Inactive',
      );
      expect(state.filteredAdmins.length, 1);
      expect(state.filteredAdmins.first.isActive, false);
    });

    test('filteredAdmins combines search and status filters', () {
      final state = SuperAdminAdminsListLoaded(
        allAdmins: allAdmins,
        searchQuery: 'Admin',
        statusFilter: 'Active',
      );
      expect(state.filteredAdmins.length, 2);
    });

    test('activeCount returns correct count', () {
      final state = SuperAdminAdminsListLoaded(allAdmins: allAdmins);
      expect(state.activeCount, 2);
    });

    test('inactiveCount returns correct count', () {
      final state = SuperAdminAdminsListLoaded(allAdmins: allAdmins);
      expect(state.inactiveCount, 1);
    });

    test('copyWith creates new instance with updated values', () {
      final state = SuperAdminAdminsListLoaded(allAdmins: allAdmins);
      final newState = state.copyWith(
        searchQuery: 'test',
        statusFilter: 'Active',
      );

      expect(newState.searchQuery, 'test');
      expect(newState.statusFilter, 'Active');
      expect(newState.allAdmins, allAdmins);
    });

    test('copyWith with clearStatusFilter clears status filter', () {
      final state = SuperAdminAdminsListLoaded(
        allAdmins: allAdmins,
        statusFilter: 'Active',
      );
      final newState = state.copyWith(clearStatusFilter: true);

      expect(newState.statusFilter, isNull);
    });

    test('props returns all properties for equality', () {
      final state1 = SuperAdminAdminsListLoaded(allAdmins: allAdmins);
      final state2 = SuperAdminAdminsListLoaded(allAdmins: allAdmins);

      expect(state1.props, state2.props);
    });
  });
}
