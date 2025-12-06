import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/owner/presentation/widgets/settings/settings_section.dart';
import 'package:spo_kick/features/owner/presentation/widgets/settings/settings_tile.dart';

/// Account section widget for owner settings page.
class OwnerAccountSection extends StatelessWidget {
  const OwnerAccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'Account',
      icon: Icons.person_outline,
      children: [
        SettingsTile(
          leading: const Icon(Icons.lock_reset, color: AppColors.primary),
          title: 'Change Password',
          subtitle: 'Update your account password',
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            context.pushNamed('changePassword');
          },
        ),
        const SizedBox(height: 8),
        SettingsTile(
          leading: const Icon(Icons.edit, color: AppColors.info),
          title: 'Edit Profile',
          subtitle: 'Update your personal information',
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            context.pushNamed('ownerProfile');
          },
        ),
      ],
    );
  }
}
