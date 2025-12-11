import 'package:equatable/equatable.dart';

/// State for super admin settings.
///
/// Manages all settings sections and preferences.
sealed class SuperAdminSettingsState extends Equatable {
  const SuperAdminSettingsState();

  @override
  List<Object?> get props => [];
}

/// Initial loading state.
final class SuperAdminSettingsInitial extends SuperAdminSettingsState {
  const SuperAdminSettingsInitial();
}

/// Settings loaded successfully.
final class SuperAdminSettingsLoaded extends SuperAdminSettingsState {
  // Platform Settings
  final bool maintenanceMode;
  final bool allowNewRegistrations;
  final bool requireEmailVerification;

  // Notification Settings
  final bool emailNotifications;
  final bool pushNotifications;
  final bool adminAlerts;

  // Security Settings
  final bool twoFactorAuth;
  final int sessionTimeout; // in minutes
  final bool logFailedLogins;

  // UI State
  final bool isLoggingOut;
  final bool showLogoutDialog;
  final String? savingSection;

  const SuperAdminSettingsLoaded({
    this.maintenanceMode = false,
    this.allowNewRegistrations = true,
    this.requireEmailVerification = true,
    this.emailNotifications = true,
    this.pushNotifications = true,
    this.adminAlerts = true,
    this.twoFactorAuth = false,
    this.sessionTimeout = 30,
    this.logFailedLogins = true,
    this.isLoggingOut = false,
    this.showLogoutDialog = false,
    this.savingSection,
  });

  SuperAdminSettingsLoaded copyWith({
    bool? maintenanceMode,
    bool? allowNewRegistrations,
    bool? requireEmailVerification,
    bool? emailNotifications,
    bool? pushNotifications,
    bool? adminAlerts,
    bool? twoFactorAuth,
    int? sessionTimeout,
    bool? logFailedLogins,
    bool? isLoggingOut,
    bool? showLogoutDialog,
    String? savingSection,
    bool clearSavingSection = false,
  }) {
    return SuperAdminSettingsLoaded(
      maintenanceMode: maintenanceMode ?? this.maintenanceMode,
      allowNewRegistrations:
          allowNewRegistrations ?? this.allowNewRegistrations,
      requireEmailVerification:
          requireEmailVerification ?? this.requireEmailVerification,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      adminAlerts: adminAlerts ?? this.adminAlerts,
      twoFactorAuth: twoFactorAuth ?? this.twoFactorAuth,
      sessionTimeout: sessionTimeout ?? this.sessionTimeout,
      logFailedLogins: logFailedLogins ?? this.logFailedLogins,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
      showLogoutDialog: showLogoutDialog ?? this.showLogoutDialog,
      savingSection: clearSavingSection
          ? null
          : (savingSection ?? this.savingSection),
    );
  }

  @override
  List<Object?> get props => [
    maintenanceMode,
    allowNewRegistrations,
    requireEmailVerification,
    emailNotifications,
    pushNotifications,
    adminAlerts,
    twoFactorAuth,
    sessionTimeout,
    logFailedLogins,
    isLoggingOut,
    showLogoutDialog,
    savingSection,
  ];
}

/// Logout completed.
final class SuperAdminLoggedOut extends SuperAdminSettingsState {
  const SuperAdminLoggedOut();
}

/// Error state.
final class SuperAdminSettingsError extends SuperAdminSettingsState {
  final String message;

  const SuperAdminSettingsError(this.message);

  @override
  List<Object?> get props => [message];
}
