import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';

/// Base state for user management operations.
sealed class UserManagementState extends Equatable {
  const UserManagementState();

  @override
  List<Object?> get props => [];
}

/// Initial state.
class UserManagementInitial extends UserManagementState {
  const UserManagementInitial();
}

/// Loading state with optional message.
class UserManagementLoading extends UserManagementState {
  final String message;

  const UserManagementLoading({this.message = 'Loading...'});

  @override
  List<Object?> get props => [message];
}

/// Error state with error message.
class UserManagementError extends UserManagementState {
  final String message;

  const UserManagementError(this.message);

  @override
  List<Object?> get props => [message];
}

/// List of users loaded.
class UsersListLoaded extends UserManagementState {
  final List<UserEntity> users;

  const UsersListLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

/// User activated successfully.
class UserActivated extends UserManagementState {
  final String userId;

  const UserActivated(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// User deactivated successfully.
class UserDeactivated extends UserManagementState {
  final String userId;

  const UserDeactivated(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// Field assigned to admin successfully.
class FieldAssigned extends UserManagementState {
  final String adminId;
  final String fieldId;

  const FieldAssigned({required this.adminId, required this.fieldId});

  @override
  List<Object?> get props => [adminId, fieldId];
}

/// Bulk action completed successfully.
class BulkActionCompleted extends UserManagementState {
  final String message;

  const BulkActionCompleted(this.message);

  @override
  List<Object?> get props => [message];
}
