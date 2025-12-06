import 'package:flutter/material.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/settings/settings_section.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/settings/settings_tile.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/settings/coming_soon_dialog.dart';

/// Platform configuration section widget for super admin settings page.
/// Includes operating hours, payment settings, email templates, and maintenance mode.
class PlatformConfigSection extends StatelessWidget {
  const PlatformConfigSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      children: [
        SettingsTile(
          icon: Icons.access_time,
          title: 'Operating Hours',
          subtitle: 'Configure platform operating hours',
          onTap: () => showComingSoonDialog(context, 'Operating Hours'),
        ),
        const Divider(height: 1, indent: 56),
        SettingsTile(
          icon: Icons.payments,
          title: 'Payment Settings',
          subtitle: 'Configure payment methods and fees',
          onTap: () => showComingSoonDialog(context, 'Payment Settings'),
        ),
        const Divider(height: 1, indent: 56),
        SettingsTile(
          icon: Icons.email,
          title: 'Email Templates',
          subtitle: 'Customize email notifications',
          onTap: () => showComingSoonDialog(context, 'Email Templates'),
        ),
        const Divider(height: 1, indent: 56),
        _MaintenanceModeSwitch(),
      ],
    );
  }
}

class _MaintenanceModeSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.construction),
      title: const Text('Maintenance Mode'),
      subtitle: const Text('Enable/disable platform access'),
      trailing: Switch(
        value: false,
        onChanged: (value) {
          showMaintenanceModeDialog(context, () {
            SnackbarHelper.showInfo(
              context,
              'Maintenance mode feature coming soon',
            );
          });
        },
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Theme.of(context).primaryColor;
          }
          return null;
        }),
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return null;
        }),
      ),
    );
  }
}
