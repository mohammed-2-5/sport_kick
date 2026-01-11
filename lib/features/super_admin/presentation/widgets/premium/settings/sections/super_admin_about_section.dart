import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/settings/super_admin_settings_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/settings/premium_settings_section.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/settings/premium_settings_tile.dart';

/// About section for super admin settings.
///
/// Displays app version, build number, privacy policy, and terms of service.
class SuperAdminAboutSection extends StatelessWidget {
  final SuperAdminSettingsCubit cubit;

  const SuperAdminAboutSection({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return PremiumSettingsSection(
      title: context.l10n.about,
      icon: Icons.info_outline,
      children: [
        PremiumSettingsTile(
          label: context.l10n.appVersion,
          value: cubit.appVersion,
          icon: Icons.apps,
          iconColor: AppColors.accentCyan,
          showArrow: false,
          onTap: null,
        ),
        PremiumSettingsTile(
          label: context.l10n.buildNumber,
          value: cubit.buildNumber,
          icon: Icons.build,
          iconColor: Theme.of(context).colorScheme.onSurfaceVariant,
          showArrow: false,
          onTap: null,
        ),
        PremiumSettingsTile(
          label: context.l10n.privacyPolicy,
          icon: Icons.privacy_tip,
          iconColor: Colors.blue,
          onTap: () => context.pushNamed('privacyPolicy'),
        ),
        PremiumSettingsTile(
          label: context.l10n.termsOfService,
          icon: Icons.description,
          iconColor: Colors.green,
          onTap: () => context.pushNamed('termsOfService'),
        ),
      ],
    );
  }
}
