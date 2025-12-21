import 'package:flutter/material.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/settings/settings_section.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/settings/settings_tile.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/settings/coming_soon_dialog.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// System preferences section widget for super admin settings page.
/// Includes date format, currency, and notification settings.
class SystemPreferencesSection extends StatelessWidget {
  const SystemPreferencesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      children: [
        // Date Format - To be implemented
        SettingsTile(
          icon: Icons.calendar_today,
          title: context.l10n.dateFormat,
          subtitle: context.l10n.ddMmYyyy,
          onTap: () =>
              showComingSoonDialog(context, context.l10n.dateFormatSettings),
        ),
        const Divider(height: 1, indent: 56),
        // Currency - To be implemented
        SettingsTile(
          icon: Icons.attach_money,
          title: context.l10n.currency,
          subtitle: context.l10n.egpEgyptianPound,
          onTap: () =>
              showComingSoonDialog(context, context.l10n.currencySettings),
        ),
        const Divider(height: 1, indent: 56),
        // Notifications - To be implemented
        SettingsTile(
          icon: Icons.notifications,
          title: context.l10n.notifications,
          subtitle: context.l10n.systemAlertsAndUpdates,
          onTap: () =>
              showComingSoonDialog(context, context.l10n.notificationSettings),
        ),
        // Language Selection - Future implementation
        // SettingsTile(
        //   icon: Icons.language,
        //   title: 'Language',
        //   subtitle: 'English',
        //   onTap: () => showComingSoonDialog(context, 'Language Selection'),
        // ),
      ],
    );
  }
}
