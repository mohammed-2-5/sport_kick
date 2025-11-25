import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/fields/domain/usecases/get_all_fields_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/activate_user_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/assign_field_to_admin_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/create_admin_account_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/create_field_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/deactivate_user_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_active_cities_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_all_admins_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_all_bookings_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_all_users_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_platform_statistics_usecase.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';

/// Cubit for managing super admin state.
///
/// Handles all super admin operations:
/// - Platform statistics
/// - Admin creation
/// - Field assignments
/// - User management
/// - City management
/// - Fields management
/// - Bookings management
class SuperAdminCubit extends Cubit<SuperAdminState> {
  final GetPlatformStatisticsUseCase getPlatformStatisticsUseCase;
  final CreateAdminAccountUseCase createAdminAccountUseCase;
  final CreateFieldUseCase createFieldUseCase;
  final GetAllAdminsUseCase getAllAdminsUseCase;
  final GetAllUsersUseCase getAllUsersUseCase;
  final AssignFieldToAdminUseCase assignFieldToAdminUseCase;
  final GetActiveCitiesUseCase getActiveCitiesUseCase;
  final GetAllFieldsUseCase getAllFieldsUseCase;
  final GetAllBookingsUseCase getAllBookingsUseCase;
  final DeactivateUserUseCase deactivateUserUseCase;
  final ActivateUserUseCase activateUserUseCase;

  SuperAdminCubit({
    required this.getPlatformStatisticsUseCase,
    required this.createAdminAccountUseCase,
    required this.createFieldUseCase,
    required this.getAllAdminsUseCase,
    required this.getAllUsersUseCase,
    required this.assignFieldToAdminUseCase,
    required this.getActiveCitiesUseCase,
    required this.getAllFieldsUseCase,
    required this.getAllBookingsUseCase,
    required this.deactivateUserUseCase,
    required this.activateUserUseCase,
  }) : super(const SuperAdminInitial());

  /// Load platform-wide statistics for dashboard.
  Future<void> loadPlatformStatistics() async {
    debugPrint('🔄 [SuperAdminCubit] Loading platform statistics...');
    emit(const SuperAdminLoading(message: 'Loading statistics...'));

    final result = await getPlatformStatisticsUseCase();

    result.fold(
      (failure) {
        debugPrint(
          '❌ [SuperAdminCubit] Error loading statistics: ${failure.message}',
        );
        emit(SuperAdminError(failure.message));
      },
      (statistics) {
        debugPrint('✅ [SuperAdminCubit] Platform statistics loaded');
        debugPrint('   Users: ${statistics.totalUsers}');
        debugPrint('   Admins: ${statistics.totalAdmins}');
        debugPrint('   Fields: ${statistics.activeFields}');
        debugPrint('   Bookings: ${statistics.totalBookings}');
        emit(PlatformStatisticsLoaded(statistics));
      },
    );
  }

  /// Create a new admin account.
  ///
  /// Generates default password if not provided.
  /// Returns invitation with credentials that must be saved.
  Future<void> createAdmin({
    required String email,
    required String fullName,
    String? phone,
    String? defaultPassword,
  }) async {
    debugPrint('🔄 [SuperAdminCubit] Creating admin account...');
    debugPrint('   Email: $email');
    debugPrint('   Name: $fullName');

    emit(const SuperAdminLoading(message: 'Creating admin account...'));

    final result = await createAdminAccountUseCase(
      email: email,
      fullName: fullName,
      phone: phone,
      defaultPassword: defaultPassword,
    );

    result.fold(
      (failure) {
        debugPrint(
          '❌ [SuperAdminCubit] Error creating admin: ${failure.message}',
        );
        emit(SuperAdminError(failure.message));
      },
      (invitation) {
        debugPrint('✅ [SuperAdminCubit] Admin created successfully!');
        debugPrint('   Admin ID: ${invitation.adminId}');
        debugPrint('   Email: ${invitation.email}');
        debugPrint('   Password: ${invitation.defaultPassword}');
        emit(AdminAccountCreated(invitation));
      },
    );
  }

  /// Load list of all admins.
  Future<void> loadAdmins() async {
    debugPrint('🔄 [SuperAdminCubit] Loading admins list...');
    emit(const SuperAdminLoading(message: 'Loading admins...'));

    final result = await getAllAdminsUseCase();

    result.fold(
      (failure) {
        debugPrint(
          '❌ [SuperAdminCubit] Error loading admins: ${failure.message}',
        );
        emit(SuperAdminError(failure.message));
      },
      (admins) {
        debugPrint('✅ [SuperAdminCubit] Loaded ${admins.length} admins');
        emit(AdminsListLoaded(admins));
      },
    );
  }

  /// Load list of all regular users.
  Future<void> loadUsers() async {
    debugPrint('🔄 [SuperAdminCubit] Loading users list...');
    emit(const SuperAdminLoading(message: 'Loading users...'));

    final result = await getAllUsersUseCase();

    result.fold(
      (failure) {
        debugPrint(
          '❌ [SuperAdminCubit] Error loading users: ${failure.message}',
        );
        emit(SuperAdminError(failure.message));
      },
      (users) {
        debugPrint('✅ [SuperAdminCubit] Loaded ${users.length} users');
        emit(UsersListLoaded(users));
      },
    );
  }

  /// Assign a field to an admin.
  Future<void> assignField({
    required String adminId,
    required String fieldId,
    String? notes,
  }) async {
    debugPrint('🔄 [SuperAdminCubit] Assigning field to admin...');
    debugPrint('   Admin ID: $adminId');
    debugPrint('   Field ID: $fieldId');

    emit(const SuperAdminLoading(message: 'Assigning field...'));

    final result = await assignFieldToAdminUseCase(
      adminId: adminId,
      fieldId: fieldId,
      notes: notes,
    );

    result.fold(
      (failure) {
        debugPrint(
          '❌ [SuperAdminCubit] Error assigning field: ${failure.message}',
        );
        emit(SuperAdminError(failure.message));
      },
      (_) {
        debugPrint('✅ [SuperAdminCubit] Field assigned successfully');
        emit(FieldAssigned(adminId: adminId, fieldId: fieldId));
      },
    );
  }

  /// Load list of active cities.
  Future<void> loadCities() async {
    debugPrint('🔄 [SuperAdminCubit] Loading cities...');
    emit(const SuperAdminLoading(message: 'Loading cities...'));

    final result = await getActiveCitiesUseCase();

    result.fold(
      (failure) {
        debugPrint(
          '❌ [SuperAdminCubit] Error loading cities: ${failure.message}',
        );
        emit(SuperAdminError(failure.message));
      },
      (cities) {
        debugPrint('✅ [SuperAdminCubit] Loaded ${cities.length} cities');
        emit(CitiesLoaded(cities));
      },
    );
  }

  /// Load all fields in the system.
  Future<void> loadAllFields() async {
    debugPrint('🔄 [SuperAdminCubit] Loading all fields...');
    emit(const SuperAdminLoading(message: 'Loading fields...'));

    final result = await getAllFieldsUseCase();

    result.fold(
      (failure) {
        debugPrint(
          '❌ [SuperAdminCubit] Error loading fields: ${failure.message}',
        );
        emit(SuperAdminError(failure.message));
      },
      (fields) {
        debugPrint('✅ [SuperAdminCubit] Loaded ${fields.length} fields');
        emit(AllFieldsLoaded(fields));
      },
    );
  }

  /// Load all bookings in the system.
  Future<void> loadAllBookings() async {
    debugPrint('🔄 [SuperAdminCubit] Loading all bookings...');
    emit(const SuperAdminLoading(message: 'Loading bookings...'));

    final result = await getAllBookingsUseCase();

    result.fold(
      (failure) {
        debugPrint(
          '❌ [SuperAdminCubit] Error loading bookings: ${failure.message}',
        );
        emit(SuperAdminError(failure.message));
      },
      (bookings) {
        debugPrint('✅ [SuperAdminCubit] Loaded ${bookings.length} bookings');
        emit(AllBookingsLoaded(bookings));
      },
    );
  }

  /// Deactivate a user account.
  Future<void> deactivateUser(String userId) async {
    debugPrint('🔄 [SuperAdminCubit] Deactivating user: $userId');
    emit(const SuperAdminLoading(message: 'Deactivating user...'));

    final result = await deactivateUserUseCase(userId: userId);

    result.fold(
      (failure) {
        debugPrint(
          '❌ [SuperAdminCubit] Error deactivating user: ${failure.message}',
        );
        emit(SuperAdminError(failure.message));
      },
      (_) {
        debugPrint('✅ [SuperAdminCubit] User deactivated successfully');
        emit(UserDeactivated(userId));
        // Reload users list
        loadUsers();
      },
    );
  }

  /// Activate a user account.
  Future<void> activateUser(String userId) async {
    debugPrint('🔄 [SuperAdminCubit] Activating user: $userId');
    emit(const SuperAdminLoading(message: 'Activating user...'));

    final result = await activateUserUseCase(userId: userId);

    result.fold(
      (failure) {
        debugPrint(
          '❌ [SuperAdminCubit] Error activating user: ${failure.message}',
        );
        emit(SuperAdminError(failure.message));
      },
      (_) {
        debugPrint('✅ [SuperAdminCubit] User activated successfully');
        emit(UserActivated(userId));
        // Reload users list
        loadUsers();
      },
    );
  }

  /// Create a new field and assign it to an admin.
  ///
  /// Only super admin can create fields.
  Future<void> createField({
    required String ownerId,
    required String sportCategoryId,
    required String name,
    required String address,
    required String city,
    required double pricePerHour,
    String? description,
    double? latitude,
    double? longitude,
    String currency = 'EGP',
    String? surfaceType,
    int? capacity,
    bool isIndoor = false,
    List<String> images = const [],
    String? videoUrl,
    List<String> facilities = const [],
  }) async {
    debugPrint('🔄 [SuperAdminCubit] Creating field...');
    debugPrint('   Name: $name');
    debugPrint('   Owner ID: $ownerId');
    debugPrint('   City: $city');

    emit(const SuperAdminLoading(message: 'Creating field...'));

    final result = await createFieldUseCase(
      ownerId: ownerId,
      sportCategoryId: sportCategoryId,
      name: name,
      description: description,
      address: address,
      city: city,
      latitude: latitude,
      longitude: longitude,
      pricePerHour: pricePerHour,
      currency: currency,
      surfaceType: surfaceType,
      capacity: capacity,
      isIndoor: isIndoor,
      images: images,
      videoUrl: videoUrl,
      facilities: facilities,
    );

    result.fold(
      (failure) {
        debugPrint(
          '❌ [SuperAdminCubit] Error creating field: ${failure.message}',
        );
        emit(SuperAdminError(failure.message));
      },
      (field) {
        debugPrint('✅ [SuperAdminCubit] Field created successfully!');
        debugPrint('   Field ID: ${field.id}');
        debugPrint('   Name: ${field.name}');
        emit(FieldCreated(field));
      },
    );
  }

  /// Bulk activate multiple users.
  Future<void> bulkActivateUsers(List<String> userIds) async {
    debugPrint('🔄 [SuperAdminCubit] Bulk activating ${userIds.length} users');
    emit(const SuperAdminLoading(message: 'Activating users...'));

    int successCount = 0;
    int failureCount = 0;

    for (final userId in userIds) {
      final result = await activateUserUseCase(userId: userId);
      result.fold((_) => failureCount++, (_) => successCount++);
    }

    debugPrint(
      '✅ [SuperAdminCubit] Bulk activation complete: $successCount succeeded, $failureCount failed',
    );

    if (failureCount > 0) {
      emit(
        SuperAdminError(
          'Activated $successCount users, but $failureCount failed',
        ),
      );
    } else {
      emit(BulkActionCompleted('Successfully activated $successCount users'));
    }

    // Reload users list
    loadUsers();
  }

  /// Bulk deactivate multiple users.
  Future<void> bulkDeactivateUsers(List<String> userIds) async {
    debugPrint(
      '🔄 [SuperAdminCubit] Bulk deactivating ${userIds.length} users',
    );
    emit(const SuperAdminLoading(message: 'Deactivating users...'));

    int successCount = 0;
    int failureCount = 0;

    for (final userId in userIds) {
      final result = await deactivateUserUseCase(userId: userId);
      result.fold((_) => failureCount++, (_) => successCount++);
    }

    debugPrint(
      '✅ [SuperAdminCubit] Bulk deactivation complete: $successCount succeeded, $failureCount failed',
    );

    if (failureCount > 0) {
      emit(
        SuperAdminError(
          'Deactivated $successCount users, but $failureCount failed',
        ),
      );
    } else {
      emit(BulkActionCompleted('Successfully deactivated $successCount users'));
    }

    // Reload users list
    loadUsers();
  }

  /// Bulk activate multiple admins.
  Future<void> bulkActivateAdmins(List<String> adminIds) async {
    debugPrint(
      '🔄 [SuperAdminCubit] Bulk activating ${adminIds.length} admins',
    );
    emit(const SuperAdminLoading(message: 'Activating admins...'));

    int successCount = 0;
    int failureCount = 0;

    for (final adminId in adminIds) {
      final result = await activateUserUseCase(userId: adminId);
      result.fold((_) => failureCount++, (_) => successCount++);
    }

    debugPrint(
      '✅ [SuperAdminCubit] Bulk activation complete: $successCount succeeded, $failureCount failed',
    );

    if (failureCount > 0) {
      emit(
        SuperAdminError(
          'Activated $successCount admins, but $failureCount failed',
        ),
      );
    } else {
      emit(BulkActionCompleted('Successfully activated $successCount admins'));
    }

    // Reload admins list
    loadAdmins();
  }

  /// Bulk deactivate multiple admins.
  Future<void> bulkDeactivateAdmins(List<String> adminIds) async {
    debugPrint(
      '🔄 [SuperAdminCubit] Bulk deactivating ${adminIds.length} admins',
    );
    emit(const SuperAdminLoading(message: 'Deactivating admins...'));

    int successCount = 0;
    int failureCount = 0;

    for (final adminId in adminIds) {
      final result = await deactivateUserUseCase(userId: adminId);
      result.fold((_) => failureCount++, (_) => successCount++);
    }

    debugPrint(
      '✅ [SuperAdminCubit] Bulk deactivation complete: $successCount succeeded, $failureCount failed',
    );

    if (failureCount > 0) {
      emit(
        SuperAdminError(
          'Deactivated $successCount admins, but $failureCount failed',
        ),
      );
    } else {
      emit(
        BulkActionCompleted('Successfully deactivated $successCount admins'),
      );
    }

    // Reload admins list
    loadAdmins();
  }

  /// Reset to initial state.
  void reset() {
    debugPrint('🔄 [SuperAdminCubit] Resetting state');
    emit(const SuperAdminInitial());
  }
}
