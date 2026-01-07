import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/super_admin/domain/entities/admin_invitation_entity.dart';

/// Base state for admin management operations.
sealed class AdminManagementState extends Equatable {
  const AdminManagementState();

  @override
  List<Object?> get props => [];
}

/// Initial state.
class AdminManagementInitial extends AdminManagementState {
  const AdminManagementInitial();
}

/// Loading state with optional message.
class AdminManagementLoading extends AdminManagementState {
  final String message;

  const AdminManagementLoading({this.message = 'Loading...'});

  @override
  List<Object?> get props => [message];
}

/// Error state with error message.
class AdminManagementError extends AdminManagementState {
  final String message;

  const AdminManagementError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Admin account created successfully.
class AdminAccountCreated extends AdminManagementState {
  final AdminInvitationEntity invitation;

  const AdminAccountCreated(this.invitation);

  @override
  List<Object?> get props => [invitation];

  /// Get display message for success notification
  String get successMessage =>
      'Admin created successfully!\n\nEmail: ${invitation.email}\nPassword: ${invitation.defaultPassword}\n\nPlease save these credentials!';
}

/// List of admins loaded.
class AdminsListLoaded extends AdminManagementState {
  final List<UserEntity> admins;

  const AdminsListLoaded(this.admins);

  @override
  List<Object?> get props => [admins];
}

/// Bulk action completed successfully.
class BulkActionCompleted extends AdminManagementState {
  final String message;

  const BulkActionCompleted(this.message);

  @override
  List<Object?> get props => [message];
}
