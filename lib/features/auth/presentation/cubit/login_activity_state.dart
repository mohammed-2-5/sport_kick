import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/auth/domain/entities/login_activity_entity.dart';

/// Login Activity State
///
/// Represents the state of login activity data.
sealed class LoginActivityState extends Equatable {
  const LoginActivityState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any data is loaded.
class LoginActivityInitial extends LoginActivityState {
  const LoginActivityInitial();
}

/// Loading state while fetching data.
class LoginActivityLoading extends LoginActivityState {
  const LoginActivityLoading();
}

/// State when login activity is loaded successfully.
class LoginActivityLoaded extends LoginActivityState {
  final List<LoginActivityEntity> activities;
  final bool hasMore;
  final bool isLoadingMore;

  const LoginActivityLoaded({
    required this.activities,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [activities, hasMore, isLoadingMore];

  LoginActivityLoaded copyWith({
    List<LoginActivityEntity>? activities,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return LoginActivityLoaded(
      activities: activities ?? this.activities,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

/// Error state when something goes wrong.
class LoginActivityError extends LoginActivityState {
  final String message;

  const LoginActivityError(this.message);

  @override
  List<Object?> get props => [message];
}
