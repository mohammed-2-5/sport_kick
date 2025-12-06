import 'package:flutter/material.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/settings/settings_section.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/settings/settings_tile.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/settings/coming_soon_dialog.dart';

/// System preferences section widget for super admin settings page.
/// Includes language, date format, currency, and notification settings.
class SystemPreferencesSection extends StatelessWidget {
  const SystemPreferencesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      children: [
        SettingsTile(
          icon: Icons.language,
          title: 'Language',
          subtitle: 'English',
          onTap: () => showComingSoonDialog(context, 'Language Selection'),
        ),
        const Divider(height: 1, indent: 56),
        SettingsTile(
          icon: Icons.calendar_today,
          title: 'Date Format',
          subtitle: 'MMM d, yyyy',
          onTap: () => showComingSoonDialog(context, 'Date Format Settings'),
        ),
        const Divider(height: 1, indent: 56),
        SettingsTile(
          icon: Icons.attach_money,
          title: 'Currency',
          subtitle: 'EGP (Egyptian Pound)',
          onTap: () => showComingSoonDialog(context, 'Currency Settings'),
        ),
        const Divider(height: 1, indent: 56),
        SettingsTile(
          icon: Icons.notifications,
          title: 'Notifications',
          subtitle: 'System alerts and updates',
          onTap: () => showComingSoonDialog(context, 'Notification Settings'),
        ),
      ],
    );
  }
}
