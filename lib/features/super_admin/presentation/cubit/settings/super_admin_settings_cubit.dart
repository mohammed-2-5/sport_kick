import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/services/notification_service.dart';
import 'package:spo_kick/features/auth/domain/usecases/logout_usecase.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/settings/super_admin_settings_state.dart';

/// Cubit for managing super admin settings.
///
/// Handles:
/// - Platform configuration
/// - Notification preferences
/// - Security settings
/// - Logout functionality
class SuperAdminSettingsCubit extends Cubit<SuperAdminSettingsState> {
  final LogoutUseCase _logoutUseCase;

  SuperAdminSettingsCubit({required LogoutUseCase logoutUseCase})
    : _logoutUseCase = logoutUseCase,
      super(const SuperAdminSettingsLoaded());

  /// Toggle maintenance mode.
  void toggleMaintenanceMode(bool value) {
    final currentState = state;
    if (currentState is SuperAdminSettingsLoaded) {
      emit(
        currentState.copyWith(
          maintenanceMode: value,
          savingSection: 'platform',
        ),
      );
      _simulateSave();
    }
  }

  /// Toggle allow new registrations.
  void toggleAllowRegistrations(bool value) {
    final currentState = state;
    if (currentState is SuperAdminSettingsLoaded) {
      emit(
        currentState.copyWith(
          allowNewRegistrations: value,
          savingSection: 'platform',
        ),
      );
      _simulateSave();
    }
  }

  /// Toggle require email verification.
  void toggleEmailVerification(bool value) {
    final currentState = state;
    if (currentState is SuperAdminSettingsLoaded) {
      emit(
        currentState.copyWith(
          requireEmailVerification: value,
          savingSection: 'platform',
        ),
      );
      _simulateSave();
    }
  }

  /// Toggle email notifications.
  void toggleEmailNotifications(bool value) {
    final currentState = state;
    if (currentState is SuperAdminSettingsLoaded) {
      emit(
        currentState.copyWith(
          emailNotifications: value,
          savingSection: 'notifications',
        ),
      );
      _simulateSave();
    }
  }

  /// Toggle push notifications.
  Future<void> togglePushNotifications(bool value) async {
    final currentState = state;
    if (currentState is SuperAdminSettingsLoaded) {
      emit(
        currentState.copyWith(
          pushNotifications: value,
          savingSection: 'notifications',
        ),
      );

      // Handle FCM topic subscription
      try {
        final notificationService = NotificationService.instance;
        if (value) {
          await notificationService.subscribeToTopic('super_admins');
          debugPrint('[SuperAdminSettings] Subscribed to super_admins topic');
        } else {
          await notificationService.unsubscribeFromTopic('super_admins');
          debugPrint(
            '[SuperAdminSettings] Unsubscribed from super_admins topic',
          );
        }
      } catch (e) {
        debugPrint('[SuperAdminSettings] Error toggling push: $e');
      }

      _simulateSave();
    }
  }

  /// Toggle admin alerts.
  Future<void> toggleAdminAlerts(bool value) async {
    final currentState = state;
    if (currentState is SuperAdminSettingsLoaded) {
      emit(
        currentState.copyWith(
          adminAlerts: value,
          savingSection: 'notifications',
        ),
      );

      // Handle FCM topic subscription for admin alerts
      try {
        final notificationService = NotificationService.instance;
        if (value) {
          await notificationService.subscribeToTopic('admin_alerts');
          debugPrint('[SuperAdminSettings] Subscribed to admin_alerts topic');
        } else {
          await notificationService.unsubscribeFromTopic('admin_alerts');
          debugPrint(
            '[SuperAdminSettings] Unsubscribed from admin_alerts topic',
          );
        }
      } catch (e) {
        debugPrint('[SuperAdminSettings] Error toggling admin alerts: $e');
      }

      _simulateSave();
    }
  }

  /// Toggle two-factor authentication.
  void toggleTwoFactorAuth(bool value) {
    final currentState = state;
    if (currentState is SuperAdminSettingsLoaded) {
      emit(
        currentState.copyWith(twoFactorAuth: value, savingSection: 'security'),
      );
      _simulateSave();
    }
  }

  /// Toggle log failed logins.
  void toggleLogFailedLogins(bool value) {
    final currentState = state;
    if (currentState is SuperAdminSettingsLoaded) {
      emit(
        currentState.copyWith(
          logFailedLogins: value,
          savingSection: 'security',
        ),
      );
      _simulateSave();
    }
  }

  /// Update session timeout.
  void updateSessionTimeout(int minutes) {
    final currentState = state;
    if (currentState is SuperAdminSettingsLoaded) {
      emit(
        currentState.copyWith(
          sessionTimeout: minutes,
          savingSection: 'security',
        ),
      );
      _simulateSave();
    }
  }

  /// Show logout confirmation dialog.
  void showLogoutDialog() {
    final currentState = state;
    if (currentState is SuperAdminSettingsLoaded) {
      emit(currentState.copyWith(showLogoutDialog: true));
    }
  }

  /// Hide logout confirmation dialog.
  void hideLogoutDialog() {
    final currentState = state;
    if (currentState is SuperAdminSettingsLoaded) {
      emit(currentState.copyWith(showLogoutDialog: false));
    }
  }

  /// Perform logout.
  Future<void> logout() async {
    final currentState = state;
    if (currentState is SuperAdminSettingsLoaded) {
      emit(currentState.copyWith(isLoggingOut: true, showLogoutDialog: false));

      final result = await _logoutUseCase();

      result.fold(
        (failure) => emit(SuperAdminSettingsError(failure.message)),
        (_) => emit(const SuperAdminLoggedOut()),
      );
    }
  }

  /// Simulate saving settings (in real app, would call API).
  Future<void> _simulateSave() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final currentState = state;
    if (currentState is SuperAdminSettingsLoaded) {
      emit(currentState.copyWith(clearSavingSection: true));
    }
  }

  /// Get app version.
  String get appVersion => '1.0.0';

  /// Get build number.
  String get buildNumber => '100';
}
