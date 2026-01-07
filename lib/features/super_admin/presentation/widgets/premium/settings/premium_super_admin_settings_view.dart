import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/settings/super_admin_settings_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/settings/super_admin_settings_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/settings/premium_logout_dialog.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/settings/premium_settings_section.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/settings/premium_settings_tile.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/settings/premium_settings_toggle.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/settings/premium_system_preferences_section.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/theme/theme_extensions.dart';

/// Premium super admin settings view.
///
/// Features:
/// - Premium curved header
/// - Platform configuration section
/// - Notification preferences section
/// - Security settings section
/// - About section
/// - Logout with confirmation
/// - All logic handled by SuperAdminSettingsCubit
class PremiumSuperAdminSettingsView extends StatelessWidget {
  const PremiumSuperAdminSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          context.goNamed('login');
        }
      },
      child: BlocConsumer<SuperAdminSettingsCubit, SuperAdminSettingsState>(
        listener: (context, state) {
          if (state is SuperAdminSettingsError) {
            SnackbarHelper.showError(context, state.message);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Scaffold(
                backgroundColor: Theme.of(context).colorScheme.surface,
                body: _buildBody(context, state),
              ),

              // Logout dialog
              if (state is SuperAdminSettingsLoaded && state.showLogoutDialog)
                PremiumLogoutDialog(
                  onConfirm: () {
                    context.read<SuperAdminSettingsCubit>().hideLogoutDialog();
                    context.read<AuthCubit>().logout();
                  },
                  onCancel: () => context
                      .read<SuperAdminSettingsCubit>()
                      .hideLogoutDialog(),
                ),

              // Loading overlay (Optional: could also listen to AuthCubit loading)
              if (state is SuperAdminSettingsLoaded && state.isLoggingOut)
                const _LoadingOverlay(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, SuperAdminSettingsState state) {
    if (state is! SuperAdminSettingsLoaded) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.premiumGold),
      );
    }

    final cubit = context.read<SuperAdminSettingsCubit>();

    return CustomScrollView(
      slivers: [
        // Premium Header
        SliverToBoxAdapter(
          child: PremiumCurvedHeader(
            title: context.l10n.settings,
            subtitle: context.l10n.platformConfiguration,
            showBackButton: true,
          ),
        ),

        // Content
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Platform Configuration
              _PlatformSection(state: state, cubit: cubit),
              const SizedBox(height: 24),

              // System Preferences (Date Format & Currency)
              const PremiumSystemPreferencesSection(),
              const SizedBox(height: 24),

              // Notifications
              _NotificationsSection(state: state, cubit: cubit),
              const SizedBox(height: 24),

              // Security
              _SecuritySection(state: state, cubit: cubit),
              const SizedBox(height: 24),

              // About
              _AboutSection(cubit: cubit),
              const SizedBox(height: 24),

              // Logout Button
              _LogoutButton(onTap: () => cubit.showLogoutDialog()),
              const SizedBox(height: 32),
            ]),
          ),
        ),
      ],
    );
  }
}

/// Platform configuration section.
class _PlatformSection extends StatelessWidget {
  final SuperAdminSettingsLoaded state;
  final SuperAdminSettingsCubit cubit;

  const _PlatformSection({required this.state, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return PremiumSettingsSection(
      title: context.l10n.platform,
      icon: Icons.settings,
      isSaving: state.savingSection == context.l10n.platformSettings,
      children: [
        PremiumSettingsToggle(
          label: context.l10n.allowRegistrations,
          description: context.l10n.allowNewUserSignUps,
          icon: Icons.person_add,
          iconColor: Colors.green,
          value: state.allowNewRegistrations,
          onChanged: cubit.toggleAllowRegistrations,
        ),
        PremiumSettingsToggle(
          label: context.l10n.emailVerification,
          description: context.l10n.requireEmailVerificationForNewUsers,
          icon: Icons.mark_email_read,
          iconColor: Colors.blue,
          value: state.requireEmailVerification,
          onChanged: cubit.toggleEmailVerification,
        ),
        PremiumSettingsTile(
          label: context.l10n.operatingHours,
          value: context.l10n.configureDefaults,
          icon: Icons.access_time,
          iconColor: AppColors.accentCyan,
          onTap: () => context.pushNamed('platformOperatingHours'),
        ),
      ],
    );
  }
}

/// Notifications section.
class _NotificationsSection extends StatelessWidget {
  final SuperAdminSettingsLoaded state;
  final SuperAdminSettingsCubit cubit;

  const _NotificationsSection({required this.state, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return PremiumSettingsSection(
      title: context.l10n.notifications,
      icon: Icons.notifications,
      isSaving: state.savingSection == context.l10n.notificationsTab,
      children: [
        PremiumSettingsToggle(
          label: context.l10n.emailNotifications,
          description: context.l10n.receiveEmailAlerts,
          icon: Icons.email,
          iconColor: Colors.blue,
          value: state.emailNotifications,
          onChanged: cubit.toggleEmailNotifications,
        ),
        PremiumSettingsToggle(
          label: context.l10n.pushNotifications,
          description: context.l10n.receivePushAlerts,
          icon: Icons.phone_android,
          iconColor: Colors.purple,
          value: state.pushNotifications,
          onChanged: cubit.togglePushNotifications,
        ),
        PremiumSettingsToggle(
          label: context.l10n.adminAlerts,
          description: context.l10n.importantAdminNotifications,
          icon: Icons.warning_amber,
          iconColor: Colors.orange,
          value: state.adminAlerts,
          onChanged: cubit.toggleAdminAlerts,
        ),
      ],
    );
  }
}

/// Security section.
class _SecuritySection extends StatelessWidget {
  final SuperAdminSettingsLoaded state;
  final SuperAdminSettingsCubit cubit;

  const _SecuritySection({required this.state, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return PremiumSettingsSection(
      title: context.l10n.security,
      icon: Icons.security,
      isSaving: state.savingSection == context.l10n.securitySettings,
      children: [
        PremiumSettingsTile(
          label: context.l10n.sessionTimeout,
          value: context.l10n.minutesMinutes(state.sessionTimeout),
          icon: Icons.timer,
          iconColor: Colors.blue,
          onTap: () => _showTimeoutPicker(context, state.sessionTimeout, cubit),
        ),
        PremiumSettingsToggle(
          label: context.l10n.logFailedLogins,
          description: context.l10n.trackFailedLoginAttempts,
          icon: Icons.error_outline,
          iconColor: Colors.red,
          value: state.logFailedLogins,
          onChanged: cubit.toggleLogFailedLogins,
        ),
        PremiumSettingsTile(
          label: context.l10n.loginActivity,
          value: context.l10n.viewHistory,
          icon: Icons.history,
          iconColor: Colors.teal,
          onTap: () => context.pushNamed('loginActivity'),
        ),
        PremiumSettingsTile(
          label: context.l10n.changePassword,
          icon: Icons.lock,
          iconColor: AppColors.premiumGold,
          onTap: () => context.pushNamed('changePassword'),
        ),
      ],
    );
  }

  void _showTimeoutPicker(
    BuildContext context,
    int currentValue,
    SuperAdminSettingsCubit cubit,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final options = [15, 30, 60, 120];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              context.l10n.sessionTimeout,
              style: AppTextStyles.titleMedium.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            ...options.map(
              (minutes) => ListTile(
                leading: Icon(
                  currentValue == minutes
                      ? Icons.check_circle
                      : Icons.circle_outlined,
                  color: currentValue == minutes
                      ? AppColors.premiumGold
                      : colorScheme.onSurfaceVariant,
                ),
                title: Text(context.l10n.minutesMinutes(minutes)),
                onTap: () {
                  HapticFeedback.selectionClick();
                  cubit.updateSessionTimeout(minutes);
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

/// About section.
class _AboutSection extends StatelessWidget {
  final SuperAdminSettingsCubit cubit;

  const _AboutSection({required this.cubit});

  @override
  Widget build(BuildContext context) {
    return PremiumSettingsSection(
      title: context.l10n.about,
      icon: Icons.info_outline,
      children: [
        PremiumSettingsTile(
          label: context.l10n.appVersion,
          value: cubit.appVersion,
          icon: Icons.apps,
          iconColor: AppColors.accentCyan,
          showArrow: false,
          onTap: null,
        ),
        PremiumSettingsTile(
          label: context.l10n.buildNumber,
          value: cubit.buildNumber,
          icon: Icons.build,
          iconColor: Theme.of(context).colorScheme.onSurfaceVariant,
          showArrow: false,
          onTap: null,
        ),
        PremiumSettingsTile(
          label: context.l10n.privacyPolicy,
          icon: Icons.privacy_tip,
          iconColor: Colors.blue,
          onTap: () => context.pushNamed('privacyPolicy'),
        ),
        PremiumSettingsTile(
          label: context.l10n.termsOfService,
          icon: Icons.description,
          iconColor: Colors.green,
          onTap: () => context.pushNamed('termsOfService'),
        ),
      ],
    );
  }
}

/// Logout button.
class _LogoutButton extends StatelessWidget {
  final VoidCallback onTap;

  const _LogoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        onTap();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: colorScheme.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.error.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: colorScheme.error, size: 20),
            const SizedBox(width: 8),
            Text(
              context.l10n.logout,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Loading overlay.
class _LoadingOverlay extends StatelessWidget {
  const _LoadingOverlay();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.overlayColor,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: AppColors.premiumGold),
            const SizedBox(height: 16),
            Text(
              context.l10n.loggingOut,
              style: AppTextStyles.bodyLarge.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
