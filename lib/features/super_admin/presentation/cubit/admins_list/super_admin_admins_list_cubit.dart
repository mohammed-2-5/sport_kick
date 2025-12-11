import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/activate_user_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/deactivate_user_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_all_admins_usecase.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/admins_list/super_admin_admins_list_state.dart';

/// Cubit for managing super admin admins list page.
///
/// Handles:
/// - Loading admins
/// - Search functionality
/// - Status filtering
/// - Selection mode
/// - Bulk actions
/// - Individual actions
class SuperAdminAdminsListCubit extends Cubit<SuperAdminAdminsListState> {
  final GetAllAdminsUseCase _getAllAdminsUseCase;
  final ActivateUserUseCase _activateUserUseCase;
  final DeactivateUserUseCase _deactivateUserUseCase;

  SuperAdminAdminsListCubit({
    required GetAllAdminsUseCase getAllAdminsUseCase,
    required ActivateUserUseCase activateUserUseCase,
    required DeactivateUserUseCase deactivateUserUseCase,
  }) : _getAllAdminsUseCase = getAllAdminsUseCase,
       _activateUserUseCase = activateUserUseCase,
       _deactivateUserUseCase = deactivateUserUseCase,
       super(const SuperAdminAdminsListLoading());

  /// Load all admins.
  Future<void> loadAdmins() async {
    emit(const SuperAdminAdminsListLoading());

    try {
      final result = await _getAllAdminsUseCase();

      result.fold(
        (failure) => emit(SuperAdminAdminsListError(failure.message)),
        (admins) => emit(SuperAdminAdminsListLoaded(allAdmins: admins)),
      );
    } catch (e) {
      emit(SuperAdminAdminsListError(e.toString()));
    }
  }

  /// Refresh admins.
  Future<void> refresh() async {
    final currentState = state;
    if (currentState is SuperAdminAdminsListLoaded) {
      emit(currentState.copyWith(isRefreshing: true));
    }

    await loadAdmins();
  }

  /// Update search query.
  void search(String query) {
    final currentState = state;
    if (currentState is SuperAdminAdminsListLoaded) {
      emit(currentState.copyWith(searchQuery: query));
    }
  }

  /// Clear search.
  void clearSearch() {
    final currentState = state;
    if (currentState is SuperAdminAdminsListLoaded) {
      emit(currentState.copyWith(searchQuery: ''));
    }
  }

  /// Filter by status.
  void filterByStatus(String? status) {
    final currentState = state;
    if (currentState is SuperAdminAdminsListLoaded) {
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
    if (currentState is SuperAdminAdminsListLoaded) {
      emit(
        currentState.copyWith(
          isSelectionMode: !currentState.isSelectionMode,
          selectedIds: {}, // Clear selections when toggling
        ),
      );
    }
  }

  /// Toggle single admin selection.
  void toggleSelection(String adminId) {
    final currentState = state;
    if (currentState is SuperAdminAdminsListLoaded) {
      final newSelected = Set<String>.from(currentState.selectedIds);
      if (newSelected.contains(adminId)) {
        newSelected.remove(adminId);
      } else {
        newSelected.add(adminId);
      }
      emit(currentState.copyWith(selectedIds: newSelected));
    }
  }

  /// Select all filtered admins.
  void selectAll() {
    final currentState = state;
    if (currentState is SuperAdminAdminsListLoaded) {
      final adminIds = currentState.filteredAdmins.map((a) => a.id).toSet();
      emit(currentState.copyWith(selectedIds: adminIds));
    }
  }

  /// Deselect all admins.
  void deselectAll() {
    final currentState = state;
    if (currentState is SuperAdminAdminsListLoaded) {
      emit(currentState.copyWith(selectedIds: {}));
    }
  }

  /// Activate single admin.
  Future<void> activateAdmin(String adminId) async {
    final result = await _activateUserUseCase(userId: adminId);

    result.fold((failure) => emit(SuperAdminAdminsListError(failure.message)), (
      _,
    ) async {
      emit(const SuperAdminAdminsListActionSuccess('Admin activated'));
      await loadAdmins();
    });
  }

  /// Deactivate single admin.
  Future<void> deactivateAdmin(String adminId) async {
    final result = await _deactivateUserUseCase(userId: adminId);

    result.fold((failure) => emit(SuperAdminAdminsListError(failure.message)), (
      _,
    ) async {
      emit(const SuperAdminAdminsListActionSuccess('Admin deactivated'));
      await loadAdmins();
    });
  }

  /// Bulk activate admins.
  Future<void> bulkActivateAdmins(List<String> adminIds) async {
    int successCount = 0;
    int failureCount = 0;

    for (final adminId in adminIds) {
      final result = await _activateUserUseCase(userId: adminId);
      result.fold((_) => failureCount++, (_) => successCount++);
    }

    if (successCount > 0) {
      emit(
        SuperAdminAdminsListActionSuccess(
          'Activated $successCount admin${successCount > 1 ? 's' : ''}',
        ),
      );
    } else if (failureCount > 0) {
      emit(const SuperAdminAdminsListError('Failed to activate admins'));
    }

    await loadAdmins();
  }

  /// Bulk deactivate admins.
  Future<void> bulkDeactivateAdmins(List<String> adminIds) async {
    int successCount = 0;
    int failureCount = 0;

    for (final adminId in adminIds) {
      final result = await _deactivateUserUseCase(userId: adminId);
      result.fold((_) => failureCount++, (_) => successCount++);
    }

    if (successCount > 0) {
      emit(
        SuperAdminAdminsListActionSuccess(
          'Deactivated $successCount admin${successCount > 1 ? 's' : ''}',
        ),
      );
    } else if (failureCount > 0) {
      emit(const SuperAdminAdminsListError('Failed to deactivate admins'));
    }

    await loadAdmins();
  }

  /// Get stats for the current filter.
  Map<String, int> getStats() {
    final currentState = state;
    if (currentState is! SuperAdminAdminsListLoaded) {
      return {'total': 0, 'active': 0, 'inactive': 0};
    }

    return {
      'total': currentState.allAdmins.length,
      'active': currentState.activeCount,
      'inactive': currentState.inactiveCount,
    };
  }
}
