import 'package:equatable/equatable.dart';

/// Base state for owner profile update operations.
sealed class OwnerProfileUpdateState extends Equatable {
  const OwnerProfileUpdateState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class OwnerProfileUpdateInitial extends OwnerProfileUpdateState {
  const OwnerProfileUpdateInitial();
}

/// Loading state with optional message
class OwnerProfileUpdateLoading extends OwnerProfileUpdateState {
  final String message;

  const OwnerProfileUpdateLoading({this.message = 'Loading...'});

  @override
  List<Object?> get props => [message];
}

/// Error state
class OwnerProfileUpdateError extends OwnerProfileUpdateState {
  final String message;

  const OwnerProfileUpdateError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Profile updated successfully
class ProfileUpdated extends OwnerProfileUpdateState {
  final String message;

  const ProfileUpdated(this.message);

  @override
  List<Object?> get props => [message];
}
