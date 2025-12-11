import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/activate_user_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/deactivate_user_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_all_users_usecase.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/users_list/super_admin_users_list_state.dart';

/// Cubit for managing super admin users list page.
///
/// Handles:
/// - Loading users
/// - Search functionality
/// - Status filtering
/// - Selection mode
/// - Bulk actions
/// - Individual actions
class SuperAdminUsersListCubit extends Cubit<SuperAdminUsersListState> {
  final GetAllUsersUseCase _getAllUsersUseCase;
  final ActivateUserUseCase _activateUserUseCase;
  final DeactivateUserUseCase _deactivateUserUseCase;

  SuperAdminUsersListCubit({
    required GetAllUsersUseCase getAllUsersUseCase,
    required ActivateUserUseCase activateUserUseCase,
    required DeactivateUserUseCase deactivateUserUseCase,
  }) : _getAllUsersUseCase = getAllUsersUseCase,
       _activateUserUseCase = activateUserUseCase,
       _deactivateUserUseCase = deactivateUserUseCase,
       super(const SuperAdminUsersListLoading());

  /// Load all users.
  Future<void> loadUsers() async {
    emit(const SuperAdminUsersListLoading());

    try {
      final result = await _getAllUsersUseCase();

      result.fold(
        (failure) => emit(SuperAdminUsersListError(failure.message)),
        (users) => emit(SuperAdminUsersListLoaded(allUsers: users)),
      );
    } catch (e) {
      emit(SuperAdminUsersListError(e.toString()));
    }
  }

  /// Refresh users.
  Future<void> refresh() async {
    final currentState = state;
    if (currentState is SuperAdminUsersListLoaded) {
      emit(currentState.copyWith(isRefreshing: true));
    }

    await loadUsers();
  }

  /// Update search query.
  void search(String query) {
    final currentState = state;
    if (currentState is SuperAdminUsersListLoaded) {
      emit(currentState.copyWith(searchQuery: query));
    }
  }

  /// Clear search.
  void clearSearch() {
    final currentState = state;
    if (currentState is SuperAdminUsersListLoaded) {
      emit(currentState.copyWith(searchQuery: ''));
    }
  }

  /// Filter by status.
  void filterByStatus(String? status) {
    final currentState = state;
    if (currentState is SuperAdminUsersListLoaded) {
      emit(
        currentState.copyWith(
          statusFilter: status,
          clearStatusFilter: status == null,
        ),
      );
    }
  }

  /// Toggle selection mode.
  void toggleSelectionMode() {
    final currentState = state;
    if (currentState is SuperAdminUsersListLoaded) {
      emit(
        currentState.copyWith(
          isSelectionMode: !currentState.isSelectionMode,
          selectedIds: {}, // Clear selections when toggling
        ),
      );
    }
  }

  /// Toggle single user selection.
  void toggleSelection(String userId) {
    final currentState = state;
    if (currentState is SuperAdminUsersListLoaded) {
      final newSelected = Set<String>.from(currentState.selectedIds);
      if (newSelected.contains(userId)) {
        newSelected.remove(userId);
      } else {
        newSelected.add(userId);
      }
      emit(currentState.copyWith(selectedIds: newSelected));
    }
  }

  /// Select all filtered users.
  void selectAll() {
    final currentState = state;
    if (currentState is SuperAdminUsersListLoaded) {
      final userIds = currentState.filteredUsers.map((u) => u.id).toSet();
      emit(currentState.copyWith(selectedIds: userIds));
    }
  }

  /// Deselect all users.
  void deselectAll() {
    final currentState = state;
    if (currentState is SuperAdminUsersListLoaded) {
      emit(currentState.copyWith(selectedIds: {}));
    }
  }

  /// Activate single user.
  Future<void> activateUser(String userId) async {
    final result = await _activateUserUseCase(userId: userId);

    result.fold((failure) => emit(SuperAdminUsersListError(failure.message)), (
      _,
    ) async {
      emit(const SuperAdminUsersListActionSuccess('User activated'));
      await loadUsers();
    });
  }

  /// Deactivate single user.
  Future<void> deactivateUser(String userId) async {
    final result = await _deactivateUserUseCase(userId: userId);

    result.fold((failure) => emit(SuperAdminUsersListError(failure.message)), (
      _,
    ) async {
      emit(const SuperAdminUsersListActionSuccess('User deactivated'));
      await loadUsers();
    });
  }

  /// Bulk activate users.
  Future<void> bulkActivateUsers(List<String> userIds) async {
    int successCount = 0;
    int failureCount = 0;

    for (final userId in userIds) {
      final result = await _activateUserUseCase(userId: userId);
      result.fold((_) => failureCount++, (_) => successCount++);
    }

    if (successCount > 0) {
      emit(
        SuperAdminUsersListActionSuccess(
          'Activated $successCount user${successCount > 1 ? 's' : ''}',
        ),
      );
    } else if (failureCount > 0) {
      emit(const SuperAdminUsersListError('Failed to activate users'));
    }

    await loadUsers();
  }

  /// Bulk deactivate users.
  Future<void> bulkDeactivateUsers(List<String> userIds) async {
    int successCount = 0;
    int failureCount = 0;

    for (final userId in userIds) {
      final result = await _deactivateUserUseCase(userId: userId);
      result.fold((_) => failureCount++, (_) => successCount++);
    }

    if (successCount > 0) {
      emit(
        SuperAdminUsersListActionSuccess(
          'Deactivated $successCount user${successCount > 1 ? 's' : ''}',
        ),
      );
    } else if (failureCount > 0) {
      emit(const SuperAdminUsersListError('Failed to deactivate users'));
    }

    await loadUsers();
  }

  /// Get stats for the current filter.
  Map<String, int> getStats() {
    final currentState = state;
    if (currentState is! SuperAdminUsersListLoaded) {
      return {'total': 0, 'active': 0, 'inactive': 0};
    }

    return {
      'total': currentState.allUsers.length,
      'active': currentState.activeCount,
      'inactive': currentState.inactiveCount,
    };
  }
}
