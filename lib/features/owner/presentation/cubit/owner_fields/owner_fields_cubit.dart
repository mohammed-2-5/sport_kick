import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:spo_kick/features/owner/domain/usecases/get_owner_fields_usecase.dart';
import 'package:spo_kick/features/owner/domain/usecases/delete_field_usecase.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_fields/owner_fields_state.dart';

/// Cubit for managing owner fields page.
///
/// Handles:
/// - Loading fields
/// - Filtering by status
/// - Search functionality
/// - Delete field
class OwnerFieldsCubit extends Cubit<OwnerFieldsState> {
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final GetOwnerFieldsUseCase _getOwnerFieldsUseCase;
  final DeleteFieldUseCase _deleteFieldUseCase;

  OwnerFieldsCubit({
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required GetOwnerFieldsUseCase getOwnerFieldsUseCase,
    required DeleteFieldUseCase deleteFieldUseCase,
  }) : _getCurrentUserUseCase = getCurrentUserUseCase,
       _getOwnerFieldsUseCase = getOwnerFieldsUseCase,
       _deleteFieldUseCase = deleteFieldUseCase,
       super(const OwnerFieldsLoading());

  /// Load all fields.
  Future<void> loadFields() async {
    emit(const OwnerFieldsLoading());

    try {
      // Get current user
      final userResult = await _getCurrentUserUseCase();
      String ownerId = '';

      userResult.fold((failure) => null, (user) => ownerId = user?.id ?? '');

      if (ownerId.isEmpty) {
        emit(const OwnerFieldsError('Unable to load owner data'));
        return;
      }

      // Load fields
      final result = await _getOwnerFieldsUseCase(ownerId: ownerId);

      result.fold(
        (failure) => emit(OwnerFieldsError(failure.message)),
        (fields) => emit(OwnerFieldsLoaded(allFields: fields)),
      );
    } catch (e) {
      emit(OwnerFieldsError(e.toString()));
    }
  }

  /// Refresh fields.
  Future<void> refresh() async {
    final currentState = state;
    if (currentState is OwnerFieldsLoaded) {
      emit(currentState.copyWith(isRefreshing: true));
    }

    await loadFields();
  }

  /// Update search query.
  void search(String query) {
    final currentState = state;
    if (currentState is OwnerFieldsLoaded) {
      emit(currentState.copyWith(searchQuery: query));
    }
  }

  /// Clear search.
  void clearSearch() {
    final currentState = state;
    if (currentState is OwnerFieldsLoaded) {
      emit(currentState.copyWith(searchQuery: ''));
    }
  }

  /// Filter by status.
  void filterByStatus(bool? isActive) {
    final currentState = state;
    if (currentState is OwnerFieldsLoaded) {
      emit(
        currentState.copyWith(
          activeFilter: isActive,
          clearFilter: isActive == null,
        ),
      );
    }
  }

  /// Delete field.
  Future<void> deleteField(String fieldId) async {
    final result = await _deleteFieldUseCase(fieldId);

    result.fold((failure) => emit(OwnerFieldsError(failure.message)), (
      _,
    ) async {
      // Reload fields after successful deletion
      await loadFields();
    });
  }

  /// Get stats for the current filter.
  Map<String, int> getStats() {
    final currentState = state;
    if (currentState is! OwnerFieldsLoaded) {
      return {'total': 0, 'active': 0, 'inactive': 0};
    }

    return {
      'total': currentState.allFields.length,
      'active': currentState.activeCount,
      'inactive': currentState.inactiveCount,
    };
  }
}
