import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';

import 'package:spo_kick/features/super_admin/domain/entities/admin_invitation_entity.dart';
import 'package:spo_kick/features/super_admin/domain/entities/city_entity.dart';
import 'package:spo_kick/features/super_admin/domain/entities/platform_statistics_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';

import '../../../../helpers/mock_dependencies.dart';

void main() {
  late SuperAdminCubit cubit;
  late MockGetPlatformStatisticsUseCase mockGetPlatformStatisticsUseCase;
  late MockCreateAdminAccountUseCase mockCreateAdminAccountUseCase;
  late MockGetAllAdminsUseCase mockGetAllAdminsUseCase;
  late MockGetAllUsersUseCase mockGetAllUsersUseCase;
  late MockAssignFieldToAdminUseCase mockAssignFieldToAdminUseCase;
  late MockGetActiveCitiesUseCase mockGetActiveCitiesUseCase;
  late MockCreateCityUseCase mockCreateCityUseCase;
  late MockUpdateCityUseCase mockUpdateCityUseCase;
  late MockDeleteCityUseCase mockDeleteCityUseCase;
  late MockGetAllFieldsUseCase mockGetAllFieldsUseCase;
  late MockGetAllBookingsUseCase mockGetAllBookingsUseCase;
  late MockDeactivateUserUseCase mockDeactivateUserUseCase;
  late MockActivateUserUseCase mockActivateUserUseCase;
  late MockCreateFieldUseCase mockCreateFieldUseCase;
  late MockSuperAdminUpdateFieldUseCase mockUpdateFieldUseCase;
  late MockSuperAdminDeleteFieldUseCase mockDeleteFieldUseCase;
  late MockVerifyFieldUseCase mockVerifyFieldUseCase;
  late MockUpdateBookingStatusUseCase mockUpdateBookingStatusUseCase;
  late MockCancelBookingUseCase mockCancelBookingUseCase;
  late MockCsvExportService mockCsvExportService;
  late MockPdfExportService mockPdfExportService;

  // Test data
  late PlatformStatisticsEntity tPlatformStatistics;
  late AdminInvitationEntity tAdminInvitation;
  late List<UserEntity> tAdmins;
  late List<UserEntity> tUsers;
  late List<CityEntity> tCities;

  setUp(() {
    // Initialize mocks
    mockGetPlatformStatisticsUseCase = MockGetPlatformStatisticsUseCase();
    mockCreateAdminAccountUseCase = MockCreateAdminAccountUseCase();
    mockGetAllAdminsUseCase = MockGetAllAdminsUseCase();
    mockGetAllUsersUseCase = MockGetAllUsersUseCase();
    mockAssignFieldToAdminUseCase = MockAssignFieldToAdminUseCase();
    mockGetActiveCitiesUseCase = MockGetActiveCitiesUseCase();
    mockCreateCityUseCase = MockCreateCityUseCase();
    mockUpdateCityUseCase = MockUpdateCityUseCase();
    mockDeleteCityUseCase = MockDeleteCityUseCase();
    mockGetAllFieldsUseCase = MockGetAllFieldsUseCase();
    mockGetAllBookingsUseCase = MockGetAllBookingsUseCase();
    mockDeactivateUserUseCase = MockDeactivateUserUseCase();
    mockActivateUserUseCase = MockActivateUserUseCase();
    mockCreateFieldUseCase = MockCreateFieldUseCase();
    mockUpdateFieldUseCase = MockSuperAdminUpdateFieldUseCase();
    mockDeleteFieldUseCase = MockSuperAdminDeleteFieldUseCase();
    mockVerifyFieldUseCase = MockVerifyFieldUseCase();
    mockUpdateBookingStatusUseCase = MockUpdateBookingStatusUseCase();
    mockCancelBookingUseCase = MockCancelBookingUseCase();
    mockCsvExportService = MockCsvExportService();
    mockPdfExportService = MockPdfExportService();

    // Initialize test data
    final now = DateTime.now();

    tPlatformStatistics = const PlatformStatisticsEntity(
      totalUsers: 150,
      newUsersThisMonth: 25,
      totalAdmins: 10,
      activeFields: 45,
      totalFields: 50,
      citiesWithFields: 5,
      activeCities: 8,
      totalBookings: 500,
      pendingBookings: 15,
      confirmedBookings: 300,
      completedBookings: 180,
      canceledBookings: 5,
      manualBookings: 20,
      bookingsThisMonth: 75,
      totalRevenue: 125000.0,
      revenueThisMonth: 18500.0,
    );

    tAdminInvitation = AdminInvitationEntity(
      id: 'invitation-1',
      email: 'admin@test.com',
      defaultPassword: 'Admin2024@Test',
      fullName: 'Test Admin',
      phone: '+201234567890',
      createdBy: 'super-admin-1',
      adminId: 'admin-1',
      status: AdminInvitationStatus.pending,
      createdAt: now,
    );

    tAdmins = [
      UserEntity(
        id: 'admin-1',
        email: 'admin1@test.com',
        fullName: 'Admin One',
        role: 'admin',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      UserEntity(
        id: 'admin-2',
        email: 'admin2@test.com',
        fullName: 'Admin Two',
        role: 'admin',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
    ];

    tUsers = [
      UserEntity(
        id: 'user-1',
        email: 'user1@test.com',
        fullName: 'User One',
        role: 'user',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      UserEntity(
        id: 'user-2',
        email: 'user2@test.com',
        fullName: 'User Two',
        role: 'user',
        isActive: false,
        createdAt: now,
        updatedAt: now,
      ),
    ];

    tCities = [
      CityEntity(
        id: 'city-1',
        name: 'Cairo',
        isActive: true,
        fieldsCount: 25,
        createdAt: now,
        updatedAt: now,
      ),
      CityEntity(
        id: 'city-2',
        name: 'Alexandria',
        isActive: true,
        fieldsCount: 20,
        createdAt: now,
        updatedAt: now,
      ),
    ];

    // Create cubit
    cubit = SuperAdminCubit(
      getPlatformStatisticsUseCase: mockGetPlatformStatisticsUseCase,
      createAdminAccountUseCase: mockCreateAdminAccountUseCase,
      getAllAdminsUseCase: mockGetAllAdminsUseCase,
      getAllUsersUseCase: mockGetAllUsersUseCase,
      assignFieldToAdminUseCase: mockAssignFieldToAdminUseCase,
      getActiveCitiesUseCase: mockGetActiveCitiesUseCase,
      createCityUseCase: mockCreateCityUseCase,
      updateCityUseCase: mockUpdateCityUseCase,
      deleteCityUseCase: mockDeleteCityUseCase,
      getAllFieldsUseCase: mockGetAllFieldsUseCase,
      getAllBookingsUseCase: mockGetAllBookingsUseCase,
      updateBookingStatusUseCase: mockUpdateBookingStatusUseCase,
      cancelBookingUseCase: mockCancelBookingUseCase,
      deactivateUserUseCase: mockDeactivateUserUseCase,
      activateUserUseCase: mockActivateUserUseCase,
      createFieldUseCase: mockCreateFieldUseCase,
      updateFieldUseCase: mockUpdateFieldUseCase,
      deleteFieldUseCase: mockDeleteFieldUseCase,
      verifyFieldUseCase: mockVerifyFieldUseCase,
      csvExportService: mockCsvExportService,
      pdfExportService: mockPdfExportService,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('SuperAdminCubit -', () {
    test('initial state should be SuperAdminInitial', () {
      expect(cubit.state, equals(const SuperAdminInitial()));
    });

    group('loadPlatformStatistics -', () {
      blocTest<SuperAdminCubit, SuperAdminState>(
        'should emit [Loading, PlatformStatisticsLoaded] when successful',
        build: () {
          when(
            () => mockGetPlatformStatisticsUseCase(),
          ).thenAnswer((_) async => Right(tPlatformStatistics));
          return cubit;
        },
        act: (cubit) => cubit.loadPlatformStatistics(),
        expect: () => [
          const SuperAdminLoading(message: 'Loading statistics...'),
          PlatformStatisticsLoaded(tPlatformStatistics),
        ],
        verify: (_) {
          verify(() => mockGetPlatformStatisticsUseCase()).called(1);
        },
      );

      blocTest<SuperAdminCubit, SuperAdminState>(
        'should emit [Loading, Error] when use case fails',
        build: () {
          when(
            () => mockGetPlatformStatisticsUseCase(),
          ).thenAnswer((_) async => const Left(ServerFailure('Server error')));
          return cubit;
        },
        act: (cubit) => cubit.loadPlatformStatistics(),
        expect: () => [
          const SuperAdminLoading(message: 'Loading statistics...'),
          const SuperAdminError('Server error'),
        ],
      );
    });

    group('createAdmin -', () {
      const tEmail = 'newadmin@test.com';
      const tFullName = 'New Admin';

      blocTest<SuperAdminCubit, SuperAdminState>(
        'should emit [Loading, AdminAccountCreated] when successful',
        build: () {
          when(
            () => mockCreateAdminAccountUseCase(
              email: any(named: 'email'),
              fullName: any(named: 'fullName'),
              phone: any(named: 'phone'),
              defaultPassword: any(named: 'defaultPassword'),
            ),
          ).thenAnswer((_) async => Right(tAdminInvitation));
          return cubit;
        },
        act: (cubit) => cubit.createAdmin(email: tEmail, fullName: tFullName),
        expect: () => [
          const SuperAdminLoading(message: 'Creating admin account...'),
          AdminAccountCreated(tAdminInvitation),
        ],
      );
    });

    group('loadAdmins -', () {
      blocTest<SuperAdminCubit, SuperAdminState>(
        'should emit [Loading, AdminsListLoaded] when successful',
        build: () {
          when(
            () => mockGetAllAdminsUseCase(),
          ).thenAnswer((_) async => Right(tAdmins));
          return cubit;
        },
        act: (cubit) => cubit.loadAdmins(),
        expect: () => [
          const SuperAdminLoading(message: 'Loading admins...'),
          AdminsListLoaded(tAdmins),
        ],
      );
    });

    group('loadUsers -', () {
      blocTest<SuperAdminCubit, SuperAdminState>(
        'should emit [Loading, UsersListLoaded] when successful',
        build: () {
          when(
            () => mockGetAllUsersUseCase(),
          ).thenAnswer((_) async => Right(tUsers));
          return cubit;
        },
        act: (cubit) => cubit.loadUsers(),
        expect: () => [
          const SuperAdminLoading(message: 'Loading users...'),
          UsersListLoaded(tUsers),
        ],
      );
    });

    group('assignField -', () {
      const tAdminId = 'admin-1';
      const tFieldId = 'field-1';

      blocTest<SuperAdminCubit, SuperAdminState>(
        'should emit [Loading, FieldAssigned] when successful',
        build: () {
          when(
            () => mockAssignFieldToAdminUseCase(
              adminId: any(named: 'adminId'),
              fieldId: any(named: 'fieldId'),
              notes: any(named: 'notes'),
            ),
          ).thenAnswer((_) async => const Right(null));
          return cubit;
        },
        act: (cubit) => cubit.assignField(adminId: tAdminId, fieldId: tFieldId),
        expect: () => [
          const SuperAdminLoading(message: 'Assigning field...'),
          const FieldAssigned(adminId: tAdminId, fieldId: tFieldId),
        ],
      );
    });

    group('loadCities -', () {
      blocTest<SuperAdminCubit, SuperAdminState>(
        'should emit [Loading, CitiesLoaded] when successful',
        build: () {
          when(
            () => mockGetActiveCitiesUseCase(),
          ).thenAnswer((_) async => Right(tCities));
          return cubit;
        },
        act: (cubit) => cubit.loadCities(),
        expect: () => [
          const SuperAdminLoading(message: 'Loading cities...'),
          CitiesLoaded(tCities),
        ],
      );
    });

    group('deactivateUser -', () {
      const tUserId = 'user-1';

      blocTest<SuperAdminCubit, SuperAdminState>(
        'should emit [Loading, UserDeactivated, Loading, UsersListLoaded]',
        build: () {
          when(
            () => mockDeactivateUserUseCase(userId: any(named: 'userId')),
          ).thenAnswer((_) async => const Right(null));
          when(
            () => mockGetAllUsersUseCase(),
          ).thenAnswer((_) async => Right(tUsers));
          return cubit;
        },
        act: (cubit) => cubit.deactivateUser(tUserId),
        expect: () => [
          const SuperAdminLoading(message: 'Deactivating user...'),
          const UserDeactivated(tUserId),
          const SuperAdminLoading(message: 'Loading users...'),
          UsersListLoaded(tUsers),
        ],
      );
    });

    group('activateUser -', () {
      const tUserId = 'user-2';

      blocTest<SuperAdminCubit, SuperAdminState>(
        'should emit [Loading, UserActivated, Loading, UsersListLoaded]',
        build: () {
          when(
            () => mockActivateUserUseCase(userId: any(named: 'userId')),
          ).thenAnswer((_) async => const Right(null));
          when(
            () => mockGetAllUsersUseCase(),
          ).thenAnswer((_) async => Right(tUsers));
          return cubit;
        },
        act: (cubit) => cubit.activateUser(tUserId),
        expect: () => [
          const SuperAdminLoading(message: 'Activating user...'),
          const UserActivated(tUserId),
          const SuperAdminLoading(message: 'Loading users...'),
          UsersListLoaded(tUsers),
        ],
      );
    });

    group('bulkActivateUsers -', () {
      final tUserIds = ['user-1', 'user-2', 'user-3'];

      blocTest<SuperAdminCubit, SuperAdminState>(
        'should emit BulkActionCompleted when all succeed',
        build: () {
          when(
            () => mockActivateUserUseCase(userId: any(named: 'userId')),
          ).thenAnswer((_) async => const Right(null));
          when(
            () => mockGetAllUsersUseCase(),
          ).thenAnswer((_) async => Right(tUsers));
          return cubit;
        },
        act: (cubit) => cubit.bulkActivateUsers(tUserIds),
        expect: () => [
          const SuperAdminLoading(message: 'Activating users...'),
          const BulkActionCompleted('Successfully activated 3 users'),
          const SuperAdminLoading(message: 'Loading users...'),
          UsersListLoaded(tUsers),
        ],
      );
    });

    group('exportUsersToCSV -', () {
      blocTest<SuperAdminCubit, SuperAdminState>(
        'should call CSV export service with users',
        build: () {
          when(
            () => mockCsvExportService.exportUsersToCsv(any(), any()),
          ).thenAnswer((_) async => {});
          return cubit;
        },
        act: (cubit) => cubit.exportUsersToCSV(tUsers),
        verify: (_) {
          verify(
            () => mockCsvExportService.exportUsersToCsv(tUsers, any()),
          ).called(1);
        },
        expect: () => [],
      );
    });

    group('reset -', () {
      blocTest<SuperAdminCubit, SuperAdminState>(
        'should emit SuperAdminInitial',
        build: () => cubit,
        seed: () => const SuperAdminError('Some error'),
        act: (cubit) => cubit.reset(),
        expect: () => [const SuperAdminInitial()],
      );
    });
  });
}
