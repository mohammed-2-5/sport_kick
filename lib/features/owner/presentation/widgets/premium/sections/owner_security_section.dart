import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/premium_owner_settings_section.dart';

/// Security section for owner settings.
///
/// Provides access to login activity and active sessions management.
class OwnerSecuritySection extends StatelessWidget {
  const OwnerSecuritySection({super.key});

  @override
  Widget build(BuildContext context) {
    return PremiumOwnerSettingsSection(
      title: context.l10n.securitySection,
      icon: Icons.security_outlined,
      children: [
        OwnerSettingsTile(
          label: context.l10n.loginActivity,
          icon: Icons.history,
          value: context.l10n.viewHistory,
          onTap: () {
            HapticFeedback.lightImpact();
            context.pushNamed('loginActivity');
          },
        ),
        OwnerSettingsTile(
          label: context.l10n.activeSessions,
          icon: Icons.devices,
          value: context.l10n.manage,
          onTap: () {
            HapticFeedback.lightImpact();
            context.pushNamed('loginActivity');
          },
        ),
      ],
    );
  }
}
