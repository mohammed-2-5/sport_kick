import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/features/settings/presentation/constants/settings_constants.dart';
import 'package:spo_kick/features/settings/presentation/widgets/shared/settings_section.dart';
import 'package:spo_kick/features/settings/presentation/widgets/shared/settings_tile.dart';
import 'package:url_launcher/url_launcher.dart';

/// About settings section for user settings page.
/// Includes privacy policy, terms, help, and version info.
class AboutSettingsSection extends StatelessWidget {
  const AboutSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'About',
      icon: Icons.info_outline,
      children: [
        SettingsTile(
          leading: const Icon(
            Icons.privacy_tip_outlined,
            color: AppColors.info,
          ),
          title: 'Privacy Policy',
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            context.pushNamed('privacyPolicy');
          },
        ),
        const SizedBox(height: SettingsConstants.itemSpacing),
        SettingsTile(
          leading: const Icon(
            Icons.description_outlined,
            color: AppColors.info,
          ),
          title: 'Terms of Service',
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            context.pushNamed('termsOfService');
          },
        ),
        const SizedBox(height: SettingsConstants.itemSpacing),
        SettingsTile(
          leading: const Icon(Icons.help_outline, color: AppColors.warning),
          title: 'Help & Support',
          subtitle: 'Email us your questions',
          trailing: const Icon(Icons.email),
          onTap: () => _launchUrl(
            context,
            'mailto:${SettingsConstants.supportEmail}?subject=Sport%20Kick%20Support',
          ),
        ),
        const SizedBox(height: SettingsConstants.itemSpacing),
        const SettingsTile(
          leading: Icon(Icons.info, color: AppColors.mediumGrey),
          title: 'Version',
          trailing: Text(
            SettingsConstants.appVersion,
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }

  Future<void> _launchUrl(BuildContext context, String urlString) async {
    final url = Uri.parse(urlString);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (!context.mounted) return;
        SnackbarHelper.showError(context, 'Could not open the link');
      }
    } catch (e) {
      if (!context.mounted) return;
      SnackbarHelper.showError(context, 'Error opening link: $e');
    }
  }
}
