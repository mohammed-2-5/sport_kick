import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/settings/super_admin_settings_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/settings/super_admin_settings_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/settings/premium_settings_section.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/settings/premium_settings_tile.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/settings/premium_settings_toggle.dart';

/// Platform configuration section for super admin settings.
///
/// Handles new registrations, email verification, and operating hours settings.
class SuperAdminPlatformSection extends StatelessWidget {
  final SuperAdminSettingsLoaded state;
  final SuperAdminSettingsCubit cubit;

  const SuperAdminPlatformSection({
    super.key,
    required this.state,
    required this.cubit,
  });

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
