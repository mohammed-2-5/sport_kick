import 'package:flutter/material.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/settings/settings_section.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/settings/settings_tile.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/settings/coming_soon_dialog.dart';

/// Platform configuration section widget for super admin settings page.
/// Currently includes operating hours configuration.
class PlatformConfigSection extends StatelessWidget {
  const PlatformConfigSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      children: [
        // Operating Hours - To be implemented
        SettingsTile(
          icon: Icons.access_time,
          title: 'Operating Hours',
          subtitle: 'Configure default platform hours',
          onTap: () => showComingSoonDialog(context, 'Operating Hours'),
        ),
        // Payment Settings - Future implementation
        // const Divider(height: 1, indent: 56),
        // SettingsTile(
        //   icon: Icons.payments,
        //   title: 'Payment Settings',
        //   subtitle: 'Configure payment methods and fees',
        //   onTap: () => showComingSoonDialog(context, 'Payment Settings'),
        // ),
        // Email Templates - Future implementation
        // const Divider(height: 1, indent: 56),
        // SettingsTile(
        //   icon: Icons.email,
        //   title: 'Email Templates',
        //   subtitle: 'Customize email notifications',
        //   onTap: () => showComingSoonDialog(context, 'Email Templates'),
        // ),
        // Maintenance Mode - Future implementation
        // const Divider(height: 1, indent: 56),
        // _MaintenanceModeSwitch(),
      ],
    );
  }
}

// Maintenance Mode Switch - Future implementation
// class _MaintenanceModeSwitch extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: const Icon(Icons.construction),
//       title: const Text('Maintenance Mode'),
//       subtitle: const Text('Enable/disable platform access'),
//       trailing: Switch(
//         value: false,
//         onChanged: (value) {
//           showMaintenanceModeDialog(context, () {
//             SnackbarHelper.showInfo(
//               context,
//               'Maintenance mode feature coming soon',
//             );
//           });
//         },
//       ),
//     );
//   }
// }
