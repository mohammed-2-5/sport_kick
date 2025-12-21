import 'package:flutter/material.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/settings/settings_section.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/settings/settings_tile.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/settings/coming_soon_dialog.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

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
          title: context.l10n.operatingHours,
          subtitle: context.l10n.configureDefaultPlatformHours,
          onTap: () =>
              showComingSoonDialog(context, context.l10n.operatingHours),
        ),
        // Payment Settings - Future implementation
        // const Divider(height: 1, indent: 56),
        // SettingsTile(
        //   icon: Icons.payments,
        //   title: context.l10n.paymentSettings,
        //   subtitle: context.l10n.configurePaymentMethodsAndFees,
        //   onTap: () => showComingSoonDialog(context, 'Payment Settings'),
        // ),
        // Email Templates - Future implementation
        // const Divider(height: 1, indent: 56),
        // SettingsTile(
        //   icon: Icons.email,
        //   title: context.l10n.emailTemplates,
        //   subtitle: context.l10n.customizeEmailNotifications,
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
//       title:  Text(context.l10n.maintenanceMode),
//       subtitle:  Text(context.l10n.enableDisablePlatformAccess),
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
