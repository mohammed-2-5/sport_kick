import 'package:flutter/foundation.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';

/// Extension for user management operations.
///
/// Handles:
/// - Loading regular users
/// - Activating/deactivating user accounts
/// - Bulk user operations
extension UserManagementOperations on SuperAdminCubit {
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
}
