import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/activate_user_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/deactivate_user_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_all_users_usecase.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/user_management/user_management_state.dart';

/// Cubit for user management operations.
///
/// Handles:
/// - Loading regular users
/// - Activating/deactivating user accounts
/// - Bulk user operations
class UserManagementCubit extends Cubit<UserManagementState> {
  final GetAllUsersUseCase getAllUsersUseCase;
  final ActivateUserUseCase activateUserUseCase;
  final DeactivateUserUseCase deactivateUserUseCase;

  UserManagementCubit({
    required this.getAllUsersUseCase,
    required this.activateUserUseCase,
    required this.deactivateUserUseCase,
  }) : super(const UserManagementInitial());

  /// Load list of all regular users.
  Future<void> loadUsers() async {
    debugPrint('🔄 [UserManagementCubit] Loading users list...');
    emit(const UserManagementLoading(message: 'Loading users...'));

    final result = await getAllUsersUseCase();

    result.fold(
      (failure) {
        debugPrint(
          '❌ [UserManagementCubit] Error loading users: ${failure.message}',
        );
        emit(UserManagementError(failure.message));
      },
      (users) {
        debugPrint('✅ [UserManagementCubit] Loaded ${users.length} users');
        emit(UsersListLoaded(users));
      },
    );
  }

  /// Deactivate a user account.
  Future<void> deactivateUser(String userId) async {
    debugPrint('🔄 [UserManagementCubit] Deactivating user: $userId');
    emit(const UserManagementLoading(message: 'Deactivating user...'));

    final result = await deactivateUserUseCase(userId: userId);

    result.fold(
      (failure) {
        debugPrint(
          '❌ [UserManagementCubit] Error deactivating user: ${failure.message}',
        );
        emit(UserManagementError(failure.message));
      },
      (_) {
        debugPrint('✅ [UserManagementCubit] User deactivated successfully');
        emit(UserDeactivated(userId));
        // Reload users list
        loadUsers();
      },
    );
  }

  /// Activate a user account.
  Future<void> activateUser(String userId) async {
    debugPrint('🔄 [UserManagementCubit] Activating user: $userId');
    emit(const UserManagementLoading(message: 'Activating user...'));

    final result = await activateUserUseCase(userId: userId);

    result.fold(
      (failure) {
        debugPrint(
          '❌ [UserManagementCubit] Error activating user: ${failure.message}',
        );
        emit(UserManagementError(failure.message));
      },
      (_) {
        debugPrint('✅ [UserManagementCubit] User activated successfully');
        emit(UserActivated(userId));
        // Reload users list
        loadUsers();
      },
    );
  }

  /// Bulk activate multiple users.
  Future<void> bulkActivateUsers(List<String> userIds) async {
    debugPrint(
      '🔄 [UserManagementCubit] Bulk activating ${userIds.length} users',
    );
    emit(const UserManagementLoading(message: 'Activating user...'));

    int successCount = 0;
    int failureCount = 0;

    for (final userId in userIds) {
      final result = await activateUserUseCase(userId: userId);
      result.fold((_) => failureCount++, (_) => successCount++);
    }

    debugPrint(
      '✅ [UserManagementCubit] Bulk activation complete: $successCount succeeded, $failureCount failed',
    );

    if (failureCount > 0) {
      emit(
        UserManagementError(
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
      '🔄 [UserManagementCubit] Bulk deactivating ${userIds.length} users',
    );
    emit(const UserManagementLoading(message: 'Deactivating user...'));

    int successCount = 0;
    int failureCount = 0;

    for (final userId in userIds) {
      final result = await deactivateUserUseCase(userId: userId);
      result.fold((_) => failureCount++, (_) => successCount++);
    }

    debugPrint(
      '✅ [UserManagementCubit] Bulk deactivation complete: $successCount succeeded, $failureCount failed',
    );

    if (failureCount > 0) {
      emit(
        UserManagementError(
          'Deactivated $successCount users, but $failureCount failed',
        ),
      );
    } else {
      emit(BulkActionCompleted('Successfully deactivated $successCount users'));
    }

    // Reload users list
    loadUsers();
  }

  /// Reset to initial state.
  void reset() {
    emit(const UserManagementInitial());
  }
}
