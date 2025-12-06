import 'package:flutter/material.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/settings/settings_section.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/settings/settings_tile.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/settings/coming_soon_dialog.dart';

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
          title: 'Change Password',
          subtitle: 'Update your login password',
          onTap: () => showComingSoonDialog(context, 'Change Password'),
        ),
        const Divider(height: 1, indent: 56),
        SettingsTile(
          icon: Icons.security,
          title: 'Two-Factor Authentication',
          subtitle: 'Add an extra layer of security',
          onTap: () => showComingSoonDialog(context, '2FA Settings'),
        ),
        const Divider(height: 1, indent: 56),
        SettingsTile(
          icon: Icons.history,
          title: 'Login Activity',
          subtitle: 'View recent login attempts',
          onTap: () => showComingSoonDialog(context, 'Login Activity'),
        ),
      ],
    );
  }
}
