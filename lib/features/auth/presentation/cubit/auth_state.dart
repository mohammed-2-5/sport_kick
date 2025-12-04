import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';

/// Base class for all authentication states.
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state when the app starts.
///
/// This is the default state before checking authentication status.
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// State when authentication operations are in progress.
///
/// This includes:
/// - Checking current user
/// - Logging in
/// - Registering
/// - Logging out
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// State when user is successfully authenticated.
///
/// Contains the authenticated user's data.
class Authenticated extends AuthState {
  final UserEntity user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

/// State when user is not authenticated.
///
/// User should be redirected to login screen.
class Unauthenticated extends AuthState {
  const Unauthenticated();
}

/// State when an authentication error occurs.
///
/// Contains the error message to display to the user.
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

/// State when profile update is in progress.
class ProfileUpdateLoading extends AuthState {
  const ProfileUpdateLoading();
}

/// State when profile update is successful.
///
/// Contains the updated user data.
class ProfileUpdateSuccess extends AuthState {
  final UserEntity user;

  const ProfileUpdateSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

/// State when profile update fails.
class ProfileUpdateError extends AuthState {
  final String message;

  const ProfileUpdateError(this.message);

  @override
  List<Object?> get props => [message];
}

/// State when password reset email is sent successfully.
class PasswordResetEmailSent extends AuthState {
  const PasswordResetEmailSent();
}

class ProfileUpdated extends AuthState {
  final UserEntity user;
  const ProfileUpdated(this.user);

  @override
  List<Object?> get props => [user];
}

/// State when password reset fails.
class PasswordResetError extends AuthState {
  final String message;

  const PasswordResetError(this.message);

  @override
  List<Object?> get props => [message];
}

/// State when password is changed successfully.
class PasswordChanged extends AuthState {
  const PasswordChanged();
}
