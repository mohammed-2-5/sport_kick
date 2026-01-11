import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/domain/usecases/get_all_fields_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/activate_user_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/assign_field_to_admin_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/deactivate_user_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/reset_admin_password_usecase.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/admin_details/admin_details_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/admin_details/admin_details_state.dart';

// Mock Use Cases
class MockGetAllFieldsUseCase extends Mock implements GetAllFieldsUseCase {}

class MockAssignFieldToAdminUseCase extends Mock
    implements AssignFieldToAdminUseCase {}

class MockActivateUserUseCase extends Mock implements ActivateUserUseCase {}

class MockDeactivateUserUseCase extends Mock implements DeactivateUserUseCase {}

class MockResetAdminPasswordUseCase extends Mock
    implements ResetAdminPasswordUseCase {}

void main() {
  late AdminDetailsCubit cubit;
  late MockGetAllFieldsUseCase mockGetAllFields;
  late MockAssignFieldToAdminUseCase mockAssignField;
  late MockActivateUserUseCase mockActivateUser;
  late MockDeactivateUserUseCase mockDeactivateUser;
  late MockResetAdminPasswordUseCase mockResetPassword;

  // Test data
  final now = DateTime.now();
  final testAdmin = UserEntity(
    id: 'admin-1',
    email: 'admin@test.com',
    fullName: 'Test Admin',
    role: 'admin',
    isActive: true,
    totalRevenue: 5000.0,
    createdAt: now.subtract(const Duration(days: 30)),
    updatedAt: now,
  );

  final inactiveAdmin = UserEntity(
    id: 'admin-2',
    email: 'inactive@test.com',
    fullName: 'Inactive Admin',
    role: 'admin',
    isActive: false,
    createdAt: now.subtract(const Duration(days: 60)),
    updatedAt: now,
  );

  final assignedField = FieldEntity(
    id: 'field-1',
    name: 'Assigned Field',
    sportCategoryId: 'cat-1',
    ownerId: 'admin-1',
    city: 'Cairo',
    address: 'Test Address',
    pricePerHour: 100.0,
    currency: 'EGP',
    isActive: true,
    totalBookings: 50,
    averageRating: 4.5,
    createdAt: now,
    updatedAt: now,
  );

  final availableField = FieldEntity(
    id: 'field-2',
    name: 'Available Field',
    sportCategoryId: 'cat-1',
    ownerId: null,
    city: 'Cairo',
    address: 'Test Address 2',
    pricePerHour: 150.0,
    currency: 'EGP',
    isActive: true,
    createdAt: now,
    updatedAt: now,
  );

  final allFields = [assignedField, availableField];

  setUp(() {
    mockGetAllFields = MockGetAllFieldsUseCase();
    mockAssignField = MockAssignFieldToAdminUseCase();
    mockActivateUser = MockActivateUserUseCase();
    mockDeactivateUser = MockDeactivateUserUseCase();
    mockResetPassword = MockResetAdminPasswordUseCase();

    cubit = AdminDetailsCubit(
      getAllFieldsUseCase: mockGetAllFields,
      assignFieldToAdminUseCase: mockAssignField,
      activateUserUseCase: mockActivateUser,
      deactivateUserUseCase: mockDeactivateUser,
      resetAdminPasswordUseCase: mockResetPassword,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('AdminDetailsCubit', () {
    test('initial state is AdminDetailsLoading', () {
      expect(cubit.state, const AdminDetailsLoading());
    });
  });

  group('initialize', () {
    blocTest<AdminDetailsCubit, AdminDetailsState>(
      'emits [Loading, Loaded] when fields load successfully',
      build: () {
        when(
          () => mockGetAllFields(),
        ).thenAnswer((_) async => Right(allFields));
        return cubit;
      },
      act: (cubit) => cubit.initialize(testAdmin),
      expect: () => [
        const AdminDetailsLoading(),
        isA<AdminDetailsLoaded>()
            .having((s) => s.admin.id, 'admin id', 'admin-1')
            .having((s) => s.assignedFields.length, 'assigned', 1)
            .having((s) => s.availableFields.length, 'available', 1),
      ],
    );

    blocTest<AdminDetailsCubit, AdminDetailsState>(
      'emits [Loading, Error] when loading fails',
      build: () {
        when(
          () => mockGetAllFields(),
        ).thenAnswer((_) async => const Left(ServerFailure('Network error')));
        return cubit;
      },
      act: (cubit) => cubit.initialize(testAdmin),
      expect: () => [
        const AdminDetailsLoading(),
        isA<AdminDetailsError>()
            .having((s) => s.message, 'message', 'Network error')
            .having((s) => s.admin?.id, 'admin id', 'admin-1'),
      ],
    );

    blocTest<AdminDetailsCubit, AdminDetailsState>(
      'correctly calculates stats from fields',
      build: () {
        when(
          () => mockGetAllFields(),
        ).thenAnswer((_) async => Right(allFields));
        return cubit;
      },
      act: (cubit) => cubit.initialize(testAdmin),
      verify: (cubit) {
        final state = cubit.state as AdminDetailsLoaded;
        expect(state.stats.totalFields, 1);
        expect(state.stats.activeFields, 1);
        expect(state.stats.totalBookings, 50);
        expect(state.stats.totalRevenue, 5000.0);
      },
    );
  });

  group('refreshFields', () {
    final loadedState = AdminDetailsLoaded(
      admin: testAdmin,
      assignedFields: [assignedField],
      availableFields: [availableField],
      stats: const AdminDetailsStats(),
    );

    blocTest<AdminDetailsCubit, AdminDetailsState>(
      'updates fields on successful refresh',
      build: () {
        when(
          () => mockGetAllFields(),
        ).thenAnswer((_) async => Right(allFields));
        return AdminDetailsCubit(
          getAllFieldsUseCase: mockGetAllFields,
          assignFieldToAdminUseCase: mockAssignField,
          activateUserUseCase: mockActivateUser,
          deactivateUserUseCase: mockDeactivateUser,
          resetAdminPasswordUseCase: mockResetPassword,
        );
      },
      seed: () => loadedState,
      act: (cubit) => cubit.refreshFields(),
      expect: () => [
        isA<AdminDetailsLoaded>().having(
          (s) => s.assignedFields.length,
          'assigned',
          1,
        ),
      ],
    );

    blocTest<AdminDetailsCubit, AdminDetailsState>(
      'does nothing when not in loaded state',
      build: () => cubit,
      act: (cubit) => cubit.refreshFields(),
      expect: () => [],
    );
  });

  group('dialog management', () {
    final loadedState = AdminDetailsLoaded(
      admin: testAdmin,
      assignedFields: [assignedField],
      availableFields: [availableField],
      stats: const AdminDetailsStats(),
    );

    blocTest<AdminDetailsCubit, AdminDetailsState>(
      'showAssignFieldDialog sets showAssignDialog to true',
      build: () => AdminDetailsCubit(
        getAllFieldsUseCase: mockGetAllFields,
        assignFieldToAdminUseCase: mockAssignField,
        activateUserUseCase: mockActivateUser,
        deactivateUserUseCase: mockDeactivateUser,
        resetAdminPasswordUseCase: mockResetPassword,
      ),
      seed: () => loadedState,
      act: (cubit) => cubit.showAssignFieldDialog(),
      expect: () => [
        isA<AdminDetailsLoaded>().having(
          (s) => s.showAssignDialog,
          'showAssignDialog',
          true,
        ),
      ],
    );

    blocTest<AdminDetailsCubit, AdminDetailsState>(
      'hideAssignFieldDialog sets showAssignDialog to false',
      build: () => AdminDetailsCubit(
        getAllFieldsUseCase: mockGetAllFields,
        assignFieldToAdminUseCase: mockAssignField,
        activateUserUseCase: mockActivateUser,
        deactivateUserUseCase: mockDeactivateUser,
        resetAdminPasswordUseCase: mockResetPassword,
      ),
      seed: () => loadedState.copyWith(showAssignDialog: true),
      act: (cubit) => cubit.hideAssignFieldDialog(),
      expect: () => [
        isA<AdminDetailsLoaded>().having(
          (s) => s.showAssignDialog,
          'showAssignDialog',
          false,
        ),
      ],
    );

    blocTest<AdminDetailsCubit, AdminDetailsState>(
      'showStatusToggleDialog sets showStatusDialog to true',
      build: () => AdminDetailsCubit(
        getAllFieldsUseCase: mockGetAllFields,
        assignFieldToAdminUseCase: mockAssignField,
        activateUserUseCase: mockActivateUser,
        deactivateUserUseCase: mockDeactivateUser,
        resetAdminPasswordUseCase: mockResetPassword,
      ),
      seed: () => loadedState,
      act: (cubit) => cubit.showStatusToggleDialog(),
      expect: () => [
        isA<AdminDetailsLoaded>().having(
          (s) => s.showStatusDialog,
          'showStatusDialog',
          true,
        ),
      ],
    );

    blocTest<AdminDetailsCubit, AdminDetailsState>(
      'hideStatusToggleDialog sets showStatusDialog to false',
      build: () => AdminDetailsCubit(
        getAllFieldsUseCase: mockGetAllFields,
        assignFieldToAdminUseCase: mockAssignField,
        activateUserUseCase: mockActivateUser,
        deactivateUserUseCase: mockDeactivateUser,
        resetAdminPasswordUseCase: mockResetPassword,
      ),
      seed: () => loadedState.copyWith(showStatusDialog: true),
      act: (cubit) => cubit.hideStatusToggleDialog(),
      expect: () => [
        isA<AdminDetailsLoaded>().having(
          (s) => s.showStatusDialog,
          'showStatusDialog',
          false,
        ),
      ],
    );

    blocTest<AdminDetailsCubit, AdminDetailsState>(
      'showResetPasswordDialog sets showResetPasswordDialog to true',
      build: () => AdminDetailsCubit(
        getAllFieldsUseCase: mockGetAllFields,
        assignFieldToAdminUseCase: mockAssignField,
        activateUserUseCase: mockActivateUser,
        deactivateUserUseCase: mockDeactivateUser,
        resetAdminPasswordUseCase: mockResetPassword,
      ),
      seed: () => loadedState,
      act: (cubit) => cubit.showResetPasswordDialog(),
      expect: () => [
        isA<AdminDetailsLoaded>().having(
          (s) => s.showResetPasswordDialog,
          'showResetPasswordDialog',
          true,
        ),
      ],
    );

    blocTest<AdminDetailsCubit, AdminDetailsState>(
      'hideResetPasswordDialog sets showResetPasswordDialog to false',
      build: () => AdminDetailsCubit(
        getAllFieldsUseCase: mockGetAllFields,
        assignFieldToAdminUseCase: mockAssignField,
        activateUserUseCase: mockActivateUser,
        deactivateUserUseCase: mockDeactivateUser,
        resetAdminPasswordUseCase: mockResetPassword,
      ),
      seed: () => loadedState.copyWith(showResetPasswordDialog: true),
      act: (cubit) => cubit.hideResetPasswordDialog(),
      expect: () => [
        isA<AdminDetailsLoaded>().having(
          (s) => s.showResetPasswordDialog,
          'showResetPasswordDialog',
          false,
        ),
      ],
    );
  });

  group('selectField', () {
    final loadedState = AdminDetailsLoaded(
      admin: testAdmin,
      assignedFields: [assignedField],
      availableFields: [availableField],
      stats: const AdminDetailsStats(),
    );

    blocTest<AdminDetailsCubit, AdminDetailsState>(
      'updates selectedFieldId',
      build: () => AdminDetailsCubit(
        getAllFieldsUseCase: mockGetAllFields,
        assignFieldToAdminUseCase: mockAssignField,
        activateUserUseCase: mockActivateUser,
        deactivateUserUseCase: mockDeactivateUser,
        resetAdminPasswordUseCase: mockResetPassword,
      ),
      seed: () => loadedState,
      act: (cubit) => cubit.selectField('field-2'),
      expect: () => [
        isA<AdminDetailsLoaded>().having(
          (s) => s.selectedFieldId,
          'selectedFieldId',
          'field-2',
        ),
      ],
    );
  });

  group('assignSelectedField', () {
    final loadedState = AdminDetailsLoaded(
      admin: testAdmin,
      assignedFields: [assignedField],
      availableFields: [availableField],
      stats: const AdminDetailsStats(),
      selectedFieldId: 'field-2',
    );

    blocTest<AdminDetailsCubit, AdminDetailsState>(
      'emits FieldAssignedSuccess when assignment succeeds',
      build: () {
        when(
          () => mockAssignField(adminId: 'admin-1', fieldId: 'field-2'),
        ).thenAnswer((_) async => const Right(null));
        return AdminDetailsCubit(
          getAllFieldsUseCase: mockGetAllFields,
          assignFieldToAdminUseCase: mockAssignField,
          activateUserUseCase: mockActivateUser,
          deactivateUserUseCase: mockDeactivateUser,
          resetAdminPasswordUseCase: mockResetPassword,
        );
      },
      seed: () => loadedState,
      act: (cubit) => cubit.assignSelectedField(),
      expect: () => [
        isA<AdminDetailsLoaded>()
            .having((s) => s.isAssigningField, 'isAssigningField', true)
            .having((s) => s.showAssignDialog, 'showAssignDialog', false),
        isA<FieldAssignedSuccess>()
            .having((s) => s.admin.id, 'admin id', 'admin-1')
            .having((s) => s.field.id, 'field id', 'field-2'),
      ],
    );

    blocTest<AdminDetailsCubit, AdminDetailsState>(
      'emits Error when assignment fails',
      build: () {
        when(
          () => mockAssignField(adminId: 'admin-1', fieldId: 'field-2'),
        ).thenAnswer(
          (_) async => const Left(ServerFailure('Assignment failed')),
        );
        return AdminDetailsCubit(
          getAllFieldsUseCase: mockGetAllFields,
          assignFieldToAdminUseCase: mockAssignField,
          activateUserUseCase: mockActivateUser,
          deactivateUserUseCase: mockDeactivateUser,
          resetAdminPasswordUseCase: mockResetPassword,
        );
      },
      seed: () => loadedState,
      act: (cubit) => cubit.assignSelectedField(),
      expect: () => [
        isA<AdminDetailsLoaded>(),
        isA<AdminDetailsError>().having(
          (s) => s.message,
          'message',
          'Assignment failed',
        ),
      ],
    );

    blocTest<AdminDetailsCubit, AdminDetailsState>(
      'does nothing when no field is selected',
      build: () => AdminDetailsCubit(
        getAllFieldsUseCase: mockGetAllFields,
        assignFieldToAdminUseCase: mockAssignField,
        activateUserUseCase: mockActivateUser,
        deactivateUserUseCase: mockDeactivateUser,
        resetAdminPasswordUseCase: mockResetPassword,
      ),
      seed: () => loadedState.copyWith(clearSelectedField: true),
      act: (cubit) => cubit.assignSelectedField(),
      expect: () => [],
    );
  });

  group('toggleAdminStatus', () {
    final activeLoadedState = AdminDetailsLoaded(
      admin: testAdmin,
      assignedFields: [assignedField],
      availableFields: [availableField],
      stats: const AdminDetailsStats(),
    );

    final inactiveLoadedState = AdminDetailsLoaded(
      admin: inactiveAdmin,
      assignedFields: [],
      availableFields: [availableField],
      stats: const AdminDetailsStats(),
    );

    blocTest<AdminDetailsCubit, AdminDetailsState>(
      'deactivates active admin successfully',
      build: () {
        when(
          () => mockDeactivateUser(userId: 'admin-1'),
        ).thenAnswer((_) async => const Right(null));
        return AdminDetailsCubit(
          getAllFieldsUseCase: mockGetAllFields,
          assignFieldToAdminUseCase: mockAssignField,
          activateUserUseCase: mockActivateUser,
          deactivateUserUseCase: mockDeactivateUser,
          resetAdminPasswordUseCase: mockResetPassword,
        );
      },
      seed: () => activeLoadedState,
      act: (cubit) => cubit.toggleAdminStatus(),
      expect: () => [
        isA<AdminDetailsLoaded>()
            .having((s) => s.isTogglingStatus, 'isTogglingStatus', true)
            .having((s) => s.showStatusDialog, 'showStatusDialog', false),
        isA<AdminStatusToggled>()
            .having((s) => s.wasActivated, 'wasActivated', false)
            .having((s) => s.admin.isActive, 'isActive', false),
      ],
    );

    blocTest<AdminDetailsCubit, AdminDetailsState>(
      'activates inactive admin successfully',
      build: () {
        when(
          () => mockActivateUser(userId: 'admin-2'),
        ).thenAnswer((_) async => const Right(null));
        return AdminDetailsCubit(
          getAllFieldsUseCase: mockGetAllFields,
          assignFieldToAdminUseCase: mockAssignField,
          activateUserUseCase: mockActivateUser,
          deactivateUserUseCase: mockDeactivateUser,
          resetAdminPasswordUseCase: mockResetPassword,
        );
      },
      seed: () => inactiveLoadedState,
      act: (cubit) => cubit.toggleAdminStatus(),
      expect: () => [
        isA<AdminDetailsLoaded>().having(
          (s) => s.isTogglingStatus,
          'isTogglingStatus',
          true,
        ),
        isA<AdminStatusToggled>()
            .having((s) => s.wasActivated, 'wasActivated', true)
            .having((s) => s.admin.isActive, 'isActive', true),
      ],
    );

    blocTest<AdminDetailsCubit, AdminDetailsState>(
      'emits Error when toggle fails',
      build: () {
        when(
          () => mockDeactivateUser(userId: 'admin-1'),
        ).thenAnswer((_) async => const Left(ServerFailure('Toggle failed')));
        return AdminDetailsCubit(
          getAllFieldsUseCase: mockGetAllFields,
          assignFieldToAdminUseCase: mockAssignField,
          activateUserUseCase: mockActivateUser,
          deactivateUserUseCase: mockDeactivateUser,
          resetAdminPasswordUseCase: mockResetPassword,
        );
      },
      seed: () => activeLoadedState,
      act: (cubit) => cubit.toggleAdminStatus(),
      expect: () => [
        isA<AdminDetailsLoaded>(),
        isA<AdminDetailsError>().having(
          (s) => s.message,
          'message',
          'Toggle failed',
        ),
      ],
    );
  });

  group('resetAdminPassword', () {
    final loadedState = AdminDetailsLoaded(
      admin: testAdmin,
      assignedFields: [assignedField],
      availableFields: [availableField],
      stats: const AdminDetailsStats(),
    );

    blocTest<AdminDetailsCubit, AdminDetailsState>(
      'emits AdminPasswordReset on success',
      build: () {
        when(
          () => mockResetPassword(adminId: 'admin-1'),
        ).thenAnswer((_) async => const Right('newPassword123'));
        return AdminDetailsCubit(
          getAllFieldsUseCase: mockGetAllFields,
          assignFieldToAdminUseCase: mockAssignField,
          activateUserUseCase: mockActivateUser,
          deactivateUserUseCase: mockDeactivateUser,
          resetAdminPasswordUseCase: mockResetPassword,
        );
      },
      seed: () => loadedState,
      act: (cubit) => cubit.resetAdminPassword(),
      expect: () => [
        isA<AdminDetailsLoaded>()
            .having((s) => s.showResetPasswordDialog, 'dialog', false)
            .having((s) => s.isResettingPassword, 'isResetting', true),
        isA<AdminPasswordReset>().having(
          (s) => s.newPassword,
          'password',
          'newPassword123',
        ),
      ],
    );

    blocTest<AdminDetailsCubit, AdminDetailsState>(
      'emits Error when reset fails',
      build: () {
        when(
          () => mockResetPassword(adminId: 'admin-1'),
        ).thenAnswer((_) async => const Left(ServerFailure('Reset failed')));
        return AdminDetailsCubit(
          getAllFieldsUseCase: mockGetAllFields,
          assignFieldToAdminUseCase: mockAssignField,
          activateUserUseCase: mockActivateUser,
          deactivateUserUseCase: mockDeactivateUser,
          resetAdminPasswordUseCase: mockResetPassword,
        );
      },
      seed: () => loadedState,
      act: (cubit) => cubit.resetAdminPassword(),
      expect: () => [
        isA<AdminDetailsLoaded>(),
        isA<AdminDetailsError>()
            .having((s) => s.message, 'message', 'Reset failed')
            .having((s) => s.admin?.id, 'admin id', 'admin-1'),
      ],
    );
  });

  group('restoreAfterAction', () {
    test('restores to loaded state with updated data', () {
      final stats = AdminDetailsStats.fromFields(
        [assignedField],
        testAdmin.createdAt,
        testAdmin.totalRevenue,
      );

      cubit.restoreAfterAction(testAdmin, [assignedField], [availableField]);

      expect(cubit.state, isA<AdminDetailsLoaded>());
      final state = cubit.state as AdminDetailsLoaded;
      expect(state.admin.id, 'admin-1');
      expect(state.assignedFields.length, 1);
      expect(state.availableFields.length, 1);
    });
  });

  group('getFormattedDate', () {
    test('formats date correctly', () {
      final date = DateTime(2024, 3, 15);
      final formatted = cubit.getFormattedDate(date);
      expect(formatted, 'Mar 15, 2024');
    });

    test('formats January correctly', () {
      final date = DateTime(2024, 1, 1);
      final formatted = cubit.getFormattedDate(date);
      expect(formatted, 'Jan 1, 2024');
    });

    test('formats December correctly', () {
      final date = DateTime(2024, 12, 25);
      final formatted = cubit.getFormattedDate(date);
      expect(formatted, 'Dec 25, 2024');
    });
  });

  group('AdminDetailsStats', () {
    test('fromFields calculates correct values', () {
      final fields = [assignedField];
      final stats = AdminDetailsStats.fromFields(
        fields,
        DateTime.now().subtract(const Duration(days: 30)),
        5000.0,
      );

      expect(stats.totalFields, 1);
      expect(stats.activeFields, 1);
      expect(stats.totalBookings, 50);
      expect(stats.totalRevenue, 5000.0);
      expect(stats.memberDays, greaterThanOrEqualTo(29));
      expect(stats.averageRating, 4.5);
    });

    test('fromFields handles empty fields', () {
      final stats = AdminDetailsStats.fromFields([], DateTime.now(), 0);

      expect(stats.totalFields, 0);
      expect(stats.activeFields, 0);
      expect(stats.totalBookings, 0);
      expect(stats.averageRating, 0);
    });
  });
}
