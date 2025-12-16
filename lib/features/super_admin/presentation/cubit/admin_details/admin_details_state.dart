import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';

/// State for admin details screen.
///
/// Manages admin data, assigned fields, and action states.
sealed class AdminDetailsState extends Equatable {
  const AdminDetailsState();

  @override
  List<Object?> get props => [];
}

/// Initial loading state.
final class AdminDetailsLoading extends AdminDetailsState {
  const AdminDetailsLoading();
}

/// Admin details loaded successfully.
final class AdminDetailsLoaded extends AdminDetailsState {
  final UserEntity admin;
  final List<FieldEntity> assignedFields;
  final List<FieldEntity> availableFields;
  final AdminDetailsStats stats;
  final bool isTogglingStatus;
  final bool isAssigningField;
  final bool showStatusDialog;
  final bool showAssignDialog;
  final String? selectedFieldId;

  const AdminDetailsLoaded({
    required this.admin,
    this.assignedFields = const [],
    this.availableFields = const [],
    required this.stats,
    this.isTogglingStatus = false,
    this.isAssigningField = false,
    this.showStatusDialog = false,
    this.showAssignDialog = false,
    this.selectedFieldId,
  });

  AdminDetailsLoaded copyWith({
    UserEntity? admin,
    List<FieldEntity>? assignedFields,
    List<FieldEntity>? availableFields,
    AdminDetailsStats? stats,
    bool? isTogglingStatus,
    bool? isAssigningField,
    bool? showStatusDialog,
    bool? showAssignDialog,
    String? selectedFieldId,
    bool clearSelectedField = false,
  }) {
    return AdminDetailsLoaded(
      admin: admin ?? this.admin,
      assignedFields: assignedFields ?? this.assignedFields,
      availableFields: availableFields ?? this.availableFields,
      stats: stats ?? this.stats,
      isTogglingStatus: isTogglingStatus ?? this.isTogglingStatus,
      isAssigningField: isAssigningField ?? this.isAssigningField,
      showStatusDialog: showStatusDialog ?? this.showStatusDialog,
      showAssignDialog: showAssignDialog ?? this.showAssignDialog,
      selectedFieldId: clearSelectedField
          ? null
          : (selectedFieldId ?? this.selectedFieldId),
    );
  }

  @override
  List<Object?> get props => [
    admin,
    assignedFields,
    availableFields,
    stats,
    isTogglingStatus,
    isAssigningField,
    showStatusDialog,
    showAssignDialog,
    selectedFieldId,
  ];
}

/// Field assigned successfully.
final class FieldAssignedSuccess extends AdminDetailsState {
  final UserEntity admin;
  final FieldEntity field;

  const FieldAssignedSuccess({required this.admin, required this.field});

  String get message => '${field.name} assigned to ${admin.displayName}';

  @override
  List<Object?> get props => [admin, field];
}

/// Status toggle completed successfully.
final class AdminStatusToggled extends AdminDetailsState {
  final UserEntity admin;
  final bool wasActivated;

  const AdminStatusToggled({required this.admin, required this.wasActivated});

  String get message => wasActivated
      ? 'Admin activated successfully'
      : 'Admin deactivated successfully';

  @override
  List<Object?> get props => [admin, wasActivated];
}

/// Error state.
final class AdminDetailsError extends AdminDetailsState {
  final String message;
  final UserEntity? admin;

  const AdminDetailsError({required this.message, this.admin});

  @override
  List<Object?> get props => [message, admin];
}

/// Statistics for admin details.
class AdminDetailsStats extends Equatable {
  final int totalFields;
  final int activeFields;
  final int totalBookings;
  final double totalRevenue;
  final int memberDays;
  final double averageRating;

  const AdminDetailsStats({
    this.totalFields = 0,
    this.activeFields = 0,
    this.totalBookings = 0,
    this.totalRevenue = 0,
    this.memberDays = 0,
    this.averageRating = 0,
  });

  factory AdminDetailsStats.fromFields(
    List<FieldEntity> fields,
    DateTime memberSince,
    double totalRevenue,
  ) {
    final active = fields.where((f) => f.isActive).length;
    final totalBookings = fields.fold<int>(
      0,
      (sum, f) => sum + f.totalBookings,
    );

    double totalRating = 0;
    int ratingCount = 0;
    for (final field in fields) {
      final rating = field.averageRating ?? 0;
      if (rating > 0) {
        totalRating += rating;
        ratingCount++;
      }
    }

    return AdminDetailsStats(
      totalFields: fields.length,
      activeFields: active,
      totalBookings: totalBookings,
      totalRevenue: totalRevenue,
      memberDays: DateTime.now().difference(memberSince).inDays,
      averageRating: ratingCount > 0 ? totalRating / ratingCount : 0,
    );
  }

  @override
  List<Object?> get props => [
    totalFields,
    activeFields,
    totalBookings,
    totalRevenue,
    memberDays,
    averageRating,
  ];
}
