import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/owner/presentation/widgets/settings/settings_section.dart';
import 'package:spo_kick/features/owner/presentation/widgets/settings/settings_tile.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Account section widget for owner settings page.
class OwnerAccountSection extends StatelessWidget {
  const OwnerAccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: context.l10n.account,
      icon: Icons.person_outline,
      children: [
        SettingsTile(
          leading: const Icon(Icons.lock_reset, color: AppColors.primary),
          title: context.l10n.changePassword,
          subtitle: context.l10n.changePasswordDesc,
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            context.pushNamed('changePassword');
          },
        ),
        const SizedBox(height: 8),
        SettingsTile(
          leading: const Icon(Icons.edit, color: AppColors.info),
          title: context.l10n.editProfile,
          subtitle: context.l10n.editProfileDesc,
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            context.pushNamed('ownerProfile');
          },
        ),
      ],
    );
  }
}
