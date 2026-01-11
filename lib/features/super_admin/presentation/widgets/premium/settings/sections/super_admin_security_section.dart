import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/settings/super_admin_settings_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/settings/super_admin_settings_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/settings/premium_settings_section.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/settings/premium_settings_tile.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/settings/premium_settings_toggle.dart';

/// Security section for super admin settings.
///
/// Manages session timeout, failed login logging, and security settings.
class SuperAdminSecuritySection extends StatelessWidget {
  final SuperAdminSettingsLoaded state;
  final SuperAdminSettingsCubit cubit;

  const SuperAdminSecuritySection({
    super.key,
    required this.state,
    required this.cubit,
  });

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
