import 'package:flutter/material.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/settings/settings_section.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/settings/settings_tile.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/settings/coming_soon_dialog.dart';

/// About section widget for super admin settings page.
/// Includes version, terms of service, and privacy policy.
class SuperAdminAboutSection extends StatelessWidget {
  const SuperAdminAboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      children: [
        SettingsTile(
          icon: Icons.info,
          title: 'Version',
          subtitle: '1.0.0+1',
          onTap: () {},
        ),
        const Divider(height: 1, indent: 56),
        SettingsTile(
          icon: Icons.description,
          title: 'Terms of Service',
          onTap: () => showComingSoonDialog(context, 'Terms of Service'),
        ),
        const Divider(height: 1, indent: 56),
        SettingsTile(
          icon: Icons.privacy_tip,
          title: 'Privacy Policy',
          onTap: () => showComingSoonDialog(context, 'Privacy Policy'),
        ),
      ],
    );
  }
}
