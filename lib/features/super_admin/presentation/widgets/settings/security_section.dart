import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/settings/settings_section.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/settings/settings_tile.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/settings/coming_soon_dialog.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Security section widget for super admin settings page.
/// Includes change password, 2FA, and login activity options.
class SecuritySection extends StatelessWidget {
  const SecuritySection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      children: [
        SettingsTile(
          icon: Icons.lock,
          title: context.l10n.changePassword,
          subtitle: context.l10n.updateYourLoginPassword,
          onTap: () => context.pushNamed("changePassword"),
        ),
        const Divider(height: 1, indent: 56),
        // Login Activity - To be implemented
        SettingsTile(
          icon: Icons.history,
          title: context.l10n.loginActivity,
          subtitle: context.l10n.viewRecentLoginAttempts,
          onTap: () =>
              showComingSoonDialog(context, context.l10n.loginActivity),
        ),
        // Two-Factor Authentication - Future implementation
        // const Divider(height: 1, indent: 56),
        // SettingsTile(
        //   icon: Icons.security,
        //   title: context.l10n.twoFactorAuthentication,
        //   subtitle: context.l10n.addAnExtraLayerOfSecurity,
        //   onTap: () => showComingSoonDialog(context, '2FA Settings'),
        // ),
      ],
    );
  }
}
