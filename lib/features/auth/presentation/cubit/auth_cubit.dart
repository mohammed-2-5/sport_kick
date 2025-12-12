import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/services/notification_service.dart';
import 'package:spo_kick/features/auth/domain/entities/login_activity_entity.dart';
import 'package:spo_kick/features/auth/domain/usecases/change_password_usecase.dart';
import 'package:spo_kick/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:spo_kick/features/auth/domain/usecases/log_login_activity_usecase.dart';
import 'package:spo_kick/features/auth/domain/usecases/login_usecase.dart';
import 'package:spo_kick/features/auth/domain/usecases/logout_usecase.dart';
import 'package:spo_kick/features/auth/domain/usecases/register_usecase.dart';
import 'package:spo_kick/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:spo_kick/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';

import '../../domain/entities/user_entity.dart';

/// Cubit for managing authentication state.
///
/// This cubit handles all authentication-related operations:
/// - Checking if user is logged in
/// - Login
/// - Registration
/// - Logout
/// - Profile updates
/// - Password reset
class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final ChangePasswordUseCase changePasswordUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final LogLoginActivityUseCase? logLoginActivityUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
    required this.changePasswordUseCase,
    required this.resetPasswordUseCase,
    required this.updateProfileUseCase,
    this.logLoginActivityUseCase,
  }) : super(const AuthInitial());

  /// Checks if user is currently logged in.
  ///
  /// This should be called when the app starts to determine
  /// whether to show login screen or home screen.
  Future<void> checkAuthStatus() async {
    emit(const AuthLoading());

    final result = await getCurrentUserUseCase();

    result.fold(
      (failure) {
        // If error occurs, treat as not authenticated
        emit(const Unauthenticated());
      },
      (user) {
        if (user != null) {
          // Setup notifications for existing session
          _setupNotifications(user);
          emit(Authenticated(user));
        } else {
          emit(const Unauthenticated());
        }
      },
    );
  }

  /// Logs in a user with email and password.
  ///
  /// Emits [AuthLoading] while logging in.
  /// Emits [Authenticated] on success with user data.
  /// Emits [AuthError] on failure with error message.
  Future<void> login({required String email, required String password}) async {
    emit(const AuthLoading());

    final result = await loginUseCase(
      LoginParams(email: email, password: password),
    );

    result.fold(
      (failure) {
        debugPrint('❌ Login Error: ${failure.message}');
        // Log failed login attempt (fire and forget)
        _logLoginActivity(null, LoginStatus.failed);
        emit(AuthError(failure.message));
      },
      (user) {
        debugPrint('✅ Login Success: ${user.email}');
        // Log successful login (fire and forget)
        _logLoginActivity(user.id, LoginStatus.success);
        _setupNotifications(user);
        emit(Authenticated(user));
      },
    );
  }

  /// Registers a new user.
  ///
  /// Emits [AuthLoading] while registering.
  /// Emits [Authenticated] on success with user data (auto-login).
  /// Emits [AuthError] on failure with error message.
  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    emit(const AuthLoading());

    final result = await registerUseCase(
      RegisterParams(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
      ),
    );

    result.fold(
      (failure) {
        // Print error to console for debugging
        debugPrint('❌ Registration Error: ${failure.message}');
        emit(AuthError(failure.message));
      },
      (user) {
        debugPrint('✅ Registration Success: ${user.email}');
        _setupNotifications(user);
        emit(Authenticated(user));
      },
    );
  }

  /// Logs out the current user.
  ///
  /// Emits [AuthLoading] while logging out.
  /// Emits [Unauthenticated] on success.
  /// Emits [AuthError] on failure.
  Future<void> logout() async {
    // Clean up notifications before logout
    final user = currentUser;
    if (user != null) {
      await _cleanupNotifications(user.id);
    }

    emit(const AuthLoading());

    final result = await logoutUseCase();

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const Unauthenticated()),
    );
  }

  /// Changes the user's password.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final result = await changePasswordUseCase(
      ChangePasswordParams(
        currentPassword: currentPassword,
        newPassword: newPassword,
      ),
    );

    result.fold(
      (failure) {
        debugPrint('❌ Password Change Error: ${failure.message}');
        emit(AuthError(failure.message));
        checkAuthStatus();
      },
      (_) {
        debugPrint('✅ Password Change Success');
        emit(const PasswordChanged());
        checkAuthStatus();
      },
    );
  }

  /// Resets the user's password via email.
  Future<void> resetPassword(String email) async {
    emit(const AuthLoading());
    final result = await resetPasswordUseCase(email);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (success) => emit(const PasswordResetEmailSent()),
    );
  }

  /// Updates the user's profile information.
  Future<void> updateProfile({String? fullName, String? phone}) async {
    emit(const AuthLoading());

    final result = await updateProfileUseCase(
      UpdateProfileParams(fullName: fullName, phone: phone),
    );

    result.fold(
      (failure) {
        debugPrint('❌ Profile Update Error: ${failure.message}');
        emit(AuthError(failure.message));
        // Re-emit authenticated state with current user to restore UI
        checkAuthStatus();
      },
      (updatedUser) {
        debugPrint('✅ Profile Update Success: ${updatedUser.displayName}');
        emit(ProfileUpdated(updatedUser));
        emit(Authenticated(updatedUser));
      },
    );
  }

  /// Gets the currently authenticated user.
  ///
  /// Returns the user from the current state if available.
  UserEntity? get currentUser {
    final currentState = state;
    if (currentState is Authenticated) {
      return currentState.user;
    }
    return null;
  }

  /// Checks if user is currently authenticated.
  bool get isAuthenticated => state is Authenticated;

  /// Checks if auth operation is in progress.
  bool get isLoading => state is AuthLoading;

  /// Resets error state back to unauthenticated.
  ///
  /// Use this to clear error messages after user has seen them.
  void clearError() {
    if (state is AuthError) {
      emit(const Unauthenticated());
    }
  }

  /// Sets up push notifications for the authenticated user.
  Future<void> _setupNotifications(UserEntity user) async {
    try {
      final notificationService = NotificationService.instance;

      // Save FCM token for this user
      await notificationService.saveTokenForUser(user.id, user.role);

      // Subscribe to role-specific topics
      await notificationService.subscribeToRoleTopics(user.role);

      debugPrint('[AuthCubit] Notifications setup for user: ${user.email}');
    } catch (e) {
      debugPrint('[AuthCubit] Error setting up notifications: $e');
    }
  }

  /// Cleans up push notifications on logout.
  Future<void> _cleanupNotifications(String userId) async {
    try {
      final notificationService = NotificationService.instance;

      // Remove FCM token
      await notificationService.removeTokenForUser(userId);

      // Unsubscribe from all topics
      await notificationService.unsubscribeFromAllTopics();

      debugPrint('[AuthCubit] Notifications cleaned up for user: $userId');
    } catch (e) {
      debugPrint('[AuthCubit] Error cleaning up notifications: $e');
    }
  }

  /// Logs login activity (fire and forget - does not block auth flow).
  void _logLoginActivity(String? userId, LoginStatus status) {
    if (logLoginActivityUseCase == null || userId == null) return;

    // Fire and forget - don't await
    logLoginActivityUseCase!(userId: userId, status: status).then(
      (result) => result.fold(
        (failure) => debugPrint(
          '[AuthCubit] Failed to log activity: ${failure.message}',
        ),
        (_) => debugPrint('[AuthCubit] Login activity logged: $status'),
      ),
    );
  }
}
