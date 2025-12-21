import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/settings/settings_section.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/settings/settings_tile.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// About section widget for super admin settings page.
/// Includes version, terms of service, and privacy policy.
class SuperAdminAboutSection extends StatelessWidget {
  const SuperAdminAboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      children: [
        SettingsTile(
          icon: Icons.info,
          title: context.l10n.version,
          subtitle: context.l10n.version1001,
          onTap: () {},
        ),
        const Divider(height: 1, indent: 56),
        SettingsTile(
          icon: Icons.description,
          title: context.l10n.termsOfService,
          onTap: () => context.pushNamed('termsOfService'),
        ),
        const Divider(height: 1, indent: 56),
        SettingsTile(
          icon: Icons.privacy_tip,
          title: context.l10n.privacyPolicy,
          onTap: () => context.pushNamed('privacyPolicy'),
        ),
      ],
    );
  }
}
