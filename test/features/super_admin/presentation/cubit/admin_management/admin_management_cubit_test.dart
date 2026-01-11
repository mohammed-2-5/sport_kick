import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/super_admin/domain/entities/admin_invitation_entity.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/activate_user_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/create_admin_account_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/deactivate_user_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_all_admins_usecase.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/admin_management/admin_management_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/admin_management/admin_management_state.dart';

// Mock Use Cases
class MockCreateAdminAccountUseCase extends Mock
    implements CreateAdminAccountUseCase {}

class MockGetAllAdminsUseCase extends Mock implements GetAllAdminsUseCase {}

class MockActivateUserUseCase extends Mock implements ActivateUserUseCase {}

class MockDeactivateUserUseCase extends Mock implements DeactivateUserUseCase {}

void main() {
  late AdminManagementCubit cubit;
  late MockCreateAdminAccountUseCase mockCreateAdmin;
  late MockGetAllAdminsUseCase mockGetAllAdmins;
  late MockActivateUserUseCase mockActivateUser;
  late MockDeactivateUserUseCase mockDeactivateUser;

  // Test data
  final now = DateTime.now();

  final testInvitation = AdminInvitationEntity(
    id: 'invitation-1',
    adminId: 'admin-1',
    email: 'test@example.com',
    fullName: 'Test Admin',
    defaultPassword: 'password123',
    createdBy: 'super-admin-1',
    status: AdminInvitationStatus.pending,
    createdAt: now,
  );

  setUp(() {
    mockCreateAdmin = MockCreateAdminAccountUseCase();
    mockGetAllAdmins = MockGetAllAdminsUseCase();
    mockActivateUser = MockActivateUserUseCase();
    mockDeactivateUser = MockDeactivateUserUseCase();

    cubit = AdminManagementCubit(
      createAdminAccountUseCase: mockCreateAdmin,
      getAllAdminsUseCase: mockGetAllAdmins,
      activateUserUseCase: mockActivateUser,
      deactivateUserUseCase: mockDeactivateUser,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('AdminManagementCubit', () {
    test('initial state is AdminManagementInitial', () {
      expect(cubit.state, const AdminManagementInitial());
    });
  });

  group('createAdmin', () {
    blocTest<AdminManagementCubit, AdminManagementState>(
      'emits [Loading, AdminAccountCreated] when creation succeeds',
      build: () {
        when(
          () => mockCreateAdmin(
            email: 'test@example.com',
            fullName: 'Test Admin',
            phone: null,
            defaultPassword: null,
          ),
        ).thenAnswer((_) async => Right(testInvitation));
        return cubit;
      },
      act: (cubit) =>
          cubit.createAdmin(email: 'test@example.com', fullName: 'Test Admin'),
      expect: () => [
        isA<AdminManagementLoading>().having(
          (s) => s.message,
          'message',
          'Creating admin account...',
        ),
        isA<AdminAccountCreated>().having(
          (s) => s.invitation.email,
          'email',
          'test@example.com',
        ),
      ],
    );

    blocTest<AdminManagementCubit, AdminManagementState>(
      'emits [Loading, Error] when creation fails',
      build: () {
        when(
          () => mockCreateAdmin(
            email: 'test@example.com',
            fullName: 'Test Admin',
            phone: null,
            defaultPassword: null,
          ),
        ).thenAnswer(
          (_) async => const Left(ServerFailure('Email already exists')),
        );
        return cubit;
      },
      act: (cubit) =>
          cubit.createAdmin(email: 'test@example.com', fullName: 'Test Admin'),
      expect: () => [
        isA<AdminManagementLoading>(),
        isA<AdminManagementError>().having(
          (s) => s.message,
          'message',
          'Email already exists',
        ),
      ],
    );
  });

  group('loadAdmins', () {
    blocTest<AdminManagementCubit, AdminManagementState>(
      'emits [Loading, AdminsListLoaded] when loading succeeds',
      build: () {
        when(() => mockGetAllAdmins()).thenAnswer((_) async => const Right([]));
        return cubit;
      },
      act: (cubit) => cubit.loadAdmins(),
      expect: () => [
        isA<AdminManagementLoading>().having(
          (s) => s.message,
          'message',
          'Loading admins...',
        ),
        isA<AdminsListLoaded>().having((s) => s.admins.length, 'count', 0),
      ],
    );

    blocTest<AdminManagementCubit, AdminManagementState>(
      'emits [Loading, Error] when loading fails',
      build: () {
        when(
          () => mockGetAllAdmins(),
        ).thenAnswer((_) async => const Left(ServerFailure('Network error')));
        return cubit;
      },
      act: (cubit) => cubit.loadAdmins(),
      expect: () => [
        isA<AdminManagementLoading>(),
        isA<AdminManagementError>().having(
          (s) => s.message,
          'message',
          'Network error',
        ),
      ],
    );
  });

  group('toggleAdminStatus', () {
    blocTest<AdminManagementCubit, AdminManagementState>(
      'deactivates admin and emits success',
      build: () {
        when(
          () => mockDeactivateUser(userId: 'admin-1'),
        ).thenAnswer((_) async => const Right(null));
        when(() => mockGetAllAdmins()).thenAnswer((_) async => const Right([]));
        return cubit;
      },
      act: (cubit) => cubit.toggleAdminStatus('admin-1', false),
      expect: () => [
        isA<AdminManagementLoading>().having(
          (s) => s.message,
          'message',
          'Deactivating admin...',
        ),
        isA<BulkActionCompleted>().having(
          (s) => s.message,
          'message',
          'Admin deactivated successfully',
        ),
        isA<AdminManagementLoading>(),
        isA<AdminsListLoaded>(),
      ],
    );

    blocTest<AdminManagementCubit, AdminManagementState>(
      'activates admin and emits success',
      build: () {
        when(
          () => mockActivateUser(userId: 'admin-2'),
        ).thenAnswer((_) async => const Right(null));
        when(() => mockGetAllAdmins()).thenAnswer((_) async => const Right([]));
        return cubit;
      },
      act: (cubit) => cubit.toggleAdminStatus('admin-2', true),
      expect: () => [
        isA<AdminManagementLoading>().having(
          (s) => s.message,
          'message',
          'Activating admin...',
        ),
        isA<BulkActionCompleted>().having(
          (s) => s.message,
          'message',
          'Admin activated successfully',
        ),
        isA<AdminManagementLoading>(),
        isA<AdminsListLoaded>(),
      ],
    );

    blocTest<AdminManagementCubit, AdminManagementState>(
      'emits Error when toggle fails',
      build: () {
        when(
          () => mockDeactivateUser(userId: 'admin-1'),
        ).thenAnswer((_) async => const Left(ServerFailure('Toggle failed')));
        return cubit;
      },
      act: (cubit) => cubit.toggleAdminStatus('admin-1', false),
      expect: () => [
        isA<AdminManagementLoading>(),
        isA<AdminManagementError>().having(
          (s) => s.message,
          'message',
          'Toggle failed',
        ),
      ],
    );
  });

  group('bulkActivateAdmins', () {
    blocTest<AdminManagementCubit, AdminManagementState>(
      'emits BulkActionCompleted when all succeed',
      build: () {
        when(
          () => mockActivateUser(userId: any(named: 'userId')),
        ).thenAnswer((_) async => const Right(null));
        when(() => mockGetAllAdmins()).thenAnswer((_) async => const Right([]));
        return cubit;
      },
      act: (cubit) => cubit.bulkActivateAdmins(['admin-1', 'admin-2']),
      expect: () => [
        isA<AdminManagementLoading>().having(
          (s) => s.message,
          'message',
          'Activating admins...',
        ),
        isA<BulkActionCompleted>().having(
          (s) => s.message,
          'message',
          'Successfully activated 2 admins',
        ),
        isA<AdminManagementLoading>(),
        isA<AdminsListLoaded>(),
      ],
    );
  });

  group('bulkDeactivateAdmins', () {
    blocTest<AdminManagementCubit, AdminManagementState>(
      'emits BulkActionCompleted when all succeed',
      build: () {
        when(
          () => mockDeactivateUser(userId: any(named: 'userId')),
        ).thenAnswer((_) async => const Right(null));
        when(() => mockGetAllAdmins()).thenAnswer((_) async => const Right([]));
        return cubit;
      },
      act: (cubit) => cubit.bulkDeactivateAdmins(['admin-1', 'admin-2']),
      expect: () => [
        isA<AdminManagementLoading>().having(
          (s) => s.message,
          'message',
          'Deactivating admins...',
        ),
        isA<BulkActionCompleted>().having(
          (s) => s.message,
          'message',
          'Successfully deactivated 2 admins',
        ),
        isA<AdminManagementLoading>(),
        isA<AdminsListLoaded>(),
      ],
    );

    blocTest<AdminManagementCubit, AdminManagementState>(
      'emits Error with partial success',
      build: () {
        var callCount = 0;
        when(() => mockDeactivateUser(userId: any(named: 'userId'))).thenAnswer(
          (_) async => ++callCount == 1
              ? const Right(null)
              : const Left(ServerFailure('Failed')),
        );
        when(() => mockGetAllAdmins()).thenAnswer((_) async => const Right([]));
        return cubit;
      },
      act: (cubit) => cubit.bulkDeactivateAdmins(['admin-1', 'admin-2']),
      expect: () => [
        isA<AdminManagementLoading>(),
        isA<AdminManagementError>().having(
          (s) => s.message,
          'message',
          'Deactivated 1 admins, but 1 failed',
        ),
        isA<AdminManagementLoading>(),
        isA<AdminsListLoaded>(),
      ],
    );
  });

  group('reset', () {
    blocTest<AdminManagementCubit, AdminManagementState>(
      'resets to initial state',
      build: () => cubit,
      seed: () => const AdminsListLoaded([]),
      act: (cubit) => cubit.reset(),
      expect: () => [const AdminManagementInitial()],
    );
  });
}
