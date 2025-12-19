import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/owner/presentation/widgets/settings/settings_section.dart';
import 'package:spo_kick/features/owner/presentation/widgets/settings/settings_tile.dart';
import 'package:spo_kick/features/settings/presentation/constants/settings_constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';

/// About section widget for owner settings page.
class OwnerAboutSection extends StatelessWidget {
  const OwnerAboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: context.l10n.about,
      icon: Icons.info_outline,
      children: [
        SettingsTile(
          leading: const Icon(
            Icons.privacy_tip_outlined,
            color: AppColors.info,
          ),
          title: context.l10n.privacyPolicy,
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            context.pushNamed('privacyPolicy');
          },
        ),
        const SizedBox(height: 8),
        SettingsTile(
          leading: const Icon(
            Icons.description_outlined,
            color: AppColors.info,
          ),
          title: context.l10n.termsOfService,
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            context.pushNamed('termsOfService');
          },
        ),
        const SizedBox(height: 8),
        SettingsTile(
          leading: const Icon(Icons.help_outline, color: AppColors.warning),
          title: context.l10n.helpSupport,
          trailing: const Icon(Icons.email),
          onTap: () => _launchUrl(
            context,
            'mailto:${SettingsConstants.supportEmail}?subject=Sport%20Kick%20Support%20-%20Owner',
          ),
        ),
        const SizedBox(height: 8),
        SettingsTile(
          leading: const Icon(Icons.info, color: AppColors.mediumGrey),
          title: context.l10n.version,
          trailing: Text(
            '1.0.0',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
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
        SnackbarHelper.showError(context, context.l10n.couldNotOpenLink);
      }
    } catch (e) {
      if (!context.mounted) return;
      SnackbarHelper.showError(
        context,
        context.l10n.errorOpeningLink(e.toString()),
      );
    }
  }
}
