import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';

/// Auth navigation handler.
///
/// Handles navigation logic after authentication based on user role
/// and authentication context.
class AuthNavigationHandler {
  AuthNavigationHandler._();

  /// Handles navigation after successful user login.
  ///
  /// Routes user based on selected login mode and user role.
  static void handleUserLogin({
    required BuildContext context,
    required UserEntity user,
    required String loginMode,
  }) {
    final userRole = user.role;

    // User selected "admin" mode
    if (loginMode == 'admin') {
      if (userRole == 'super_admin') {
        // Super admin goes to super admin dashboard
        context.goNamed('superAdminDashboard');
      } else if (userRole == 'admin') {
        // Field owner goes to owner dashboard
        context.goNamed('ownerDashboard');
      } else {
        // User selected admin but doesn't have admin role
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.adminAccessDenied),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 4),
          ),
        );
        // Navigate to home anyway
        context.goNamed('home');
      }
    } else {
      // Regular user login - navigate to home
      context.goNamed('home');
    }
  }

  /// Handles navigation after successful admin login.
  ///
  /// Validates admin role and handles first-time password change.
  /// Returns true if navigation was handled, false if should logout.
  static bool handleAdminLogin({
    required BuildContext context,
    required UserEntity user,
  }) {
    // Validate admin role
    if (user.role != 'admin' && user.role != 'super_admin') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.adminAccessDenied),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 4),
        ),
      );
      return false; // Signal to logout
    }

    // Check if first login (password_changed field)
    if (!user.passwordChanged) {
      context.goNamed('changePassword');
      return true;
    }

    // Navigate based on role
    if (user.role == 'super_admin') {
      context.goNamed('superAdminDashboard');
    } else {
      context.goNamed('ownerDashboard');
    }

    return true;
  }

  /// Handles navigation after successful registration.
  static void handleRegistration({required BuildContext context}) {
    // Navigate to home on successful registration
    context.goNamed('home');
  }

  /// Handles navigation after logout.
  static void handleLogout({required BuildContext context}) {
    // Navigate to login page
    context.goNamed('login');
  }
}
