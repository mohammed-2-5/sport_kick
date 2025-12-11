import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
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
                backgroundColor: AppColors.backgroundLight,
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
        const SliverToBoxAdapter(
          child: PremiumCurvedHeader(
            title: 'Settings',
            subtitle: 'Platform configuration',
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
      title: 'Platform',
      icon: Icons.settings,
      isSaving: state.savingSection == 'platform',
      children: [
        PremiumSettingsToggle(
          label: 'Maintenance Mode',
          description: 'Temporarily disable app access',
          icon: Icons.construction,
          iconColor: Colors.orange,
          value: state.maintenanceMode,
          onChanged: cubit.toggleMaintenanceMode,
        ),
        PremiumSettingsToggle(
          label: 'Allow Registrations',
          description: 'Allow new user sign-ups',
          icon: Icons.person_add,
          iconColor: Colors.green,
          value: state.allowNewRegistrations,
          onChanged: cubit.toggleAllowRegistrations,
        ),
        PremiumSettingsToggle(
          label: 'Email Verification',
          description: 'Require email verification for new users',
          icon: Icons.mark_email_read,
          iconColor: Colors.blue,
          value: state.requireEmailVerification,
          onChanged: cubit.toggleEmailVerification,
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
      title: 'Notifications',
      icon: Icons.notifications,
      isSaving: state.savingSection == 'notifications',
      children: [
        PremiumSettingsToggle(
          label: 'Email Notifications',
          description: 'Receive email alerts',
          icon: Icons.email,
          iconColor: Colors.blue,
          value: state.emailNotifications,
          onChanged: cubit.toggleEmailNotifications,
        ),
        PremiumSettingsToggle(
          label: 'Push Notifications',
          description: 'Receive push alerts',
          icon: Icons.phone_android,
          iconColor: Colors.purple,
          value: state.pushNotifications,
          onChanged: cubit.togglePushNotifications,
        ),
        PremiumSettingsToggle(
          label: 'Admin Alerts',
          description: 'Important admin notifications',
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
      title: 'Security',
      icon: Icons.security,
      isSaving: state.savingSection == 'security',
      children: [
        PremiumSettingsToggle(
          label: 'Two-Factor Auth',
          description: 'Add extra security layer',
          icon: Icons.phonelink_lock,
          iconColor: Colors.green,
          value: state.twoFactorAuth,
          onChanged: cubit.toggleTwoFactorAuth,
        ),
        PremiumSettingsTile(
          label: 'Session Timeout',
          value: '${state.sessionTimeout} min',
          icon: Icons.timer,
          iconColor: Colors.blue,
          onTap: () => _showTimeoutPicker(context, state.sessionTimeout, cubit),
        ),
        PremiumSettingsToggle(
          label: 'Log Failed Logins',
          description: 'Track failed login attempts',
          icon: Icons.error_outline,
          iconColor: Colors.red,
          value: state.logFailedLogins,
          onChanged: cubit.toggleLogFailedLogins,
        ),
        PremiumSettingsTile(
          label: 'Change Password',
          icon: Icons.lock,
          iconColor: AppColors.premiumGold,
          onTap: () {
            // Navigate to change password
          },
        ),
      ],
    );
  }

  void _showTimeoutPicker(
    BuildContext context,
    int currentValue,
    SuperAdminSettingsCubit cubit,
  ) {
    final options = [15, 30, 60, 120];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Session Timeout',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
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
                      : AppColors.textSecondary,
                ),
                title: Text('$minutes minutes'),
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
      title: 'About',
      icon: Icons.info_outline,
      children: [
        PremiumSettingsTile(
          label: 'App Version',
          value: cubit.appVersion,
          icon: Icons.apps,
          iconColor: AppColors.accentCyan,
          showArrow: false,
          onTap: null,
        ),
        PremiumSettingsTile(
          label: 'Build Number',
          value: cubit.buildNumber,
          icon: Icons.build,
          iconColor: Colors.grey,
          showArrow: false,
          onTap: null,
        ),
        PremiumSettingsTile(
          label: 'Privacy Policy',
          icon: Icons.privacy_tip,
          iconColor: Colors.blue,
          onTap: () => context.pushNamed('privacyPolicy'),
        ),
        PremiumSettingsTile(
          label: 'Terms of Service',
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
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        onTap();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: Colors.red, size: 20),
            SizedBox(width: 8),
            Text(
              'Logout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.red,
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
      color: Colors.black54,
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppColors.premiumGold),
            SizedBox(height: 16),
            Text(
              'Logging out...',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
