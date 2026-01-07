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
        SettingsTile(
          icon: Icons.access_time,
          title: context.l10n.operatingHours,
          subtitle: context.l10n.configureDefaultPlatformHours,
          onTap: () =>
              showComingSoonDialog(context, context.l10n.operatingHours),
        ),
      ],
    );
  }
}
