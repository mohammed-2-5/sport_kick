import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/premium_owner_settings_section.dart';

/// Account section for owner settings.
///
/// Includes profile editing, password change, and business hours access.
class OwnerAccountSection extends StatelessWidget {
  final VoidCallback onBusinessHoursTap;

  const OwnerAccountSection({super.key, required this.onBusinessHoursTap});

  @override
  Widget build(BuildContext context) {
    return PremiumOwnerSettingsSection(
      title: context.l10n.accountSection,
      icon: Icons.person_outline,
      children: [
        OwnerSettingsTile(
          label: context.l10n.editProfile,
          icon: Icons.edit_outlined,
          onTap: () {
            HapticFeedback.lightImpact();
            context.pushNamed('ownerProfile');
          },
        ),
        OwnerSettingsTile(
          label: context.l10n.changePassword,
          icon: Icons.lock_outline,
          onTap: () {
            HapticFeedback.lightImpact();
            context.pushNamed('changePassword');
          },
        ),
        OwnerSettingsTile(
          label: context.l10n.businessHours,
          icon: Icons.access_time,
          onTap: () {
            HapticFeedback.lightImpact();
            onBusinessHoursTap();
          },
        ),
      ],
    );
  }
}
