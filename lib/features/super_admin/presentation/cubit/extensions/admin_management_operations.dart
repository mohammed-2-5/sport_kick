import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/activate_user_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/create_admin_account_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/deactivate_user_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_all_admins_usecase.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';

/// Mixin for admin management operations.
///
/// Handles:
/// - Creating admin accounts
/// - Loading admin lists
/// - Bulk activate/deactivate operations
mixin AdminManagementOperations on Cubit<SuperAdminState> {
  // Dependencies
  CreateAdminAccountUseCase get createAdminAccountUseCase;
  GetAllAdminsUseCase get getAllAdminsUseCase;
  ActivateUserUseCase get activateUserUseCase;
  DeactivateUserUseCase get deactivateUserUseCase;

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

  /// Toggle admin account status.
  ///
  /// Activates when [shouldActivate] is true, otherwise deactivates.
  /// Reloads the admins list after completion.
  Future<void> toggleAdminStatus(String adminId, bool shouldActivate) async {
    debugPrint(
      '🔄 [SuperAdminCubit] ${shouldActivate ? 'Activating' : 'Deactivating'} admin: $adminId',
    );

    emit(
      SuperAdminLoading(
        message: shouldActivate
            ? 'Activating admin...'
            : 'Deactivating admin...',
      ),
    );

    final result = shouldActivate
        ? await activateUserUseCase(userId: adminId)
        : await deactivateUserUseCase(userId: adminId);

    result.fold(
      (failure) {
        debugPrint(
          '❌ [SuperAdminCubit] Error updating admin status: ${failure.message}',
        );
        emit(SuperAdminError(failure.message));
      },
      (_) {
        final message = shouldActivate
            ? 'Admin activated successfully'
            : 'Admin deactivated successfully';
        emit(BulkActionCompleted(message));
        loadAdmins();
      },
    );
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
}
