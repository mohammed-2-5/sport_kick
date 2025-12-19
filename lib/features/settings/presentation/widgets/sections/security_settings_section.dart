import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/settings/presentation/constants/settings_constants.dart';
import 'package:spo_kick/features/settings/presentation/widgets/shared/settings_section.dart';
import 'package:spo_kick/features/settings/presentation/widgets/shared/settings_tile.dart';

/// Security settings section for user settings page.
///
/// Includes login activity and security-related options.
class SecuritySettingsSection extends StatelessWidget {
  const SecuritySettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: context.l10n.security,
      icon: Icons.security_outlined,
      children: [
        SettingsTile(
          leading: const Icon(Icons.history, color: AppColors.info),
          title: context.l10n.loginActivity,
          subtitle: context.l10n.loginActivityDesc,
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.pushNamed('loginActivity'),
        ),
        const SizedBox(height: SettingsConstants.itemSpacing),
        SettingsTile(
          leading: const Icon(Icons.devices, color: AppColors.secondary),
          title: context.l10n.activeSessions,
          subtitle: context.l10n.activeSessionsDesc,
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.pushNamed('loginActivity'),
        ),
      ],
    );
  }
}
