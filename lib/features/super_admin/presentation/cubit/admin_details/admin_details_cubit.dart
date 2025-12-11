import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/domain/usecases/get_all_fields_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/activate_user_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/assign_field_to_admin_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/deactivate_user_usecase.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/admin_details/admin_details_state.dart';

/// Cubit for managing admin details screen state.
///
/// Handles:
/// - Loading admin's assigned fields
/// - Field assignment operations
/// - Status toggle operations
/// - Dialog state management
class AdminDetailsCubit extends Cubit<AdminDetailsState> {
  final GetAllFieldsUseCase _getAllFieldsUseCase;
  final AssignFieldToAdminUseCase _assignFieldToAdminUseCase;
  final ActivateUserUseCase _activateUserUseCase;
  final DeactivateUserUseCase _deactivateUserUseCase;

  AdminDetailsCubit({
    required GetAllFieldsUseCase getAllFieldsUseCase,
    required AssignFieldToAdminUseCase assignFieldToAdminUseCase,
    required ActivateUserUseCase activateUserUseCase,
    required DeactivateUserUseCase deactivateUserUseCase,
  }) : _getAllFieldsUseCase = getAllFieldsUseCase,
       _assignFieldToAdminUseCase = assignFieldToAdminUseCase,
       _activateUserUseCase = activateUserUseCase,
       _deactivateUserUseCase = deactivateUserUseCase,
       super(const AdminDetailsLoading());

  /// Initialize with admin data and load fields.
  Future<void> initialize(UserEntity admin) async {
    emit(const AdminDetailsLoading());

    final result = await _getAllFieldsUseCase();

    result.fold(
      (failure) =>
          emit(AdminDetailsError(message: failure.message, admin: admin)),
      (allFields) {
        final assignedFields = allFields
            .where((f) => f.ownerId == admin.id)
            .toList();

        final availableFields = allFields
            .where((f) => f.ownerId == null || f.ownerId!.isEmpty)
            .toList();

        final stats = AdminDetailsStats.fromFields(
          assignedFields,
          admin.createdAt,
        );

        emit(
          AdminDetailsLoaded(
            admin: admin,
            assignedFields: assignedFields,
            availableFields: availableFields,
            stats: stats,
          ),
        );
      },
    );
  }

  /// Refresh fields data.
  Future<void> refreshFields() async {
    final currentState = state;
    if (currentState is! AdminDetailsLoaded) return;

    final result = await _getAllFieldsUseCase();

    result.fold(
      (failure) => emit(
        AdminDetailsError(message: failure.message, admin: currentState.admin),
      ),
      (allFields) {
        final assignedFields = allFields
            .where((f) => f.ownerId == currentState.admin.id)
            .toList();

        final availableFields = allFields
            .where((f) => f.ownerId == null || f.ownerId!.isEmpty)
            .toList();

        final stats = AdminDetailsStats.fromFields(
          assignedFields,
          currentState.admin.createdAt,
        );

        emit(
          currentState.copyWith(
            assignedFields: assignedFields,
            availableFields: availableFields,
            stats: stats,
          ),
        );
      },
    );
  }

  /// Show assign field dialog.
  void showAssignFieldDialog() {
    final currentState = state;
    if (currentState is AdminDetailsLoaded) {
      emit(
        currentState.copyWith(showAssignDialog: true, clearSelectedField: true),
      );
    }
  }

  /// Hide assign field dialog.
  void hideAssignFieldDialog() {
    final currentState = state;
    if (currentState is AdminDetailsLoaded) {
      emit(
        currentState.copyWith(
          showAssignDialog: false,
          clearSelectedField: true,
        ),
      );
    }
  }

  /// Select a field for assignment.
  void selectField(String fieldId) {
    final currentState = state;
    if (currentState is AdminDetailsLoaded) {
      emit(currentState.copyWith(selectedFieldId: fieldId));
    }
  }

  /// Assign selected field to admin.
  Future<void> assignSelectedField() async {
    final currentState = state;
    if (currentState is! AdminDetailsLoaded ||
        currentState.selectedFieldId == null) {
      return;
    }

    emit(
      currentState.copyWith(isAssigningField: true, showAssignDialog: false),
    );

    final result = await _assignFieldToAdminUseCase(
      adminId: currentState.admin.id,
      fieldId: currentState.selectedFieldId!,
    );

    result.fold(
      (failure) => emit(
        AdminDetailsError(message: failure.message, admin: currentState.admin),
      ),
      (_) {
        final assignedField = currentState.availableFields.firstWhere(
          (f) => f.id == currentState.selectedFieldId,
        );
        emit(
          FieldAssignedSuccess(admin: currentState.admin, field: assignedField),
        );
      },
    );
  }

  /// Show status toggle confirmation dialog.
  void showStatusToggleDialog() {
    final currentState = state;
    if (currentState is AdminDetailsLoaded) {
      emit(currentState.copyWith(showStatusDialog: true));
    }
  }

  /// Hide status toggle confirmation dialog.
  void hideStatusToggleDialog() {
    final currentState = state;
    if (currentState is AdminDetailsLoaded) {
      emit(currentState.copyWith(showStatusDialog: false));
    }
  }

  /// Toggle admin active status.
  Future<void> toggleAdminStatus() async {
    final currentState = state;
    if (currentState is! AdminDetailsLoaded) return;

    emit(
      currentState.copyWith(isTogglingStatus: true, showStatusDialog: false),
    );

    final admin = currentState.admin;
    final result = admin.isActive
        ? await _deactivateUserUseCase(userId: admin.id)
        : await _activateUserUseCase(userId: admin.id);

    result.fold(
      (failure) =>
          emit(AdminDetailsError(message: failure.message, admin: admin)),
      (_) {
        final updatedAdmin = admin.copyWith(isActive: !admin.isActive);
        emit(
          AdminStatusToggled(
            admin: updatedAdmin,
            wasActivated: !admin.isActive,
          ),
        );
      },
    );
  }

  /// Restore to loaded state after action.
  void restoreAfterAction(
    UserEntity updatedAdmin,
    List<FieldEntity> assignedFields,
    List<FieldEntity> availableFields,
  ) {
    final stats = AdminDetailsStats.fromFields(
      assignedFields,
      updatedAdmin.createdAt,
    );

    emit(
      AdminDetailsLoaded(
        admin: updatedAdmin,
        assignedFields: assignedFields,
        availableFields: availableFields,
        stats: stats,
      ),
    );
  }

  /// Get formatted date string.
  String getFormattedDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
