import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/premium_owner_settings_section.dart';

/// About section for owner settings.
///
/// Provides links to privacy policy, terms of service, and app version info.
class OwnerAboutSection extends StatelessWidget {
  const OwnerAboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return PremiumOwnerSettingsSection(
      title: context.l10n.aboutSection,
      icon: Icons.info_outline,
      children: [
        OwnerSettingsTile(
          label: context.l10n.privacyPolicy,
          icon: Icons.privacy_tip_outlined,
          onTap: () {
            HapticFeedback.lightImpact();
            context.pushNamed('privacyPolicy');
          },
        ),
        OwnerSettingsTile(
          label: context.l10n.termsOfService,
          icon: Icons.description_outlined,
          onTap: () {
            HapticFeedback.lightImpact();
            context.pushNamed('termsOfService');
          },
        ),
        OwnerSettingsTile(
          label: context.l10n.appVersion,
          icon: Icons.info_outline,
          value: '1.0.0',
          showArrow: false,
          onTap: () {},
        ),
      ],
    );
  }
}
