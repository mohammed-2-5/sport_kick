import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/settings/domain/entities/user_preferences_entity.dart';
import 'package:spo_kick/features/settings/presentation/constants/settings_constants.dart';
import 'package:spo_kick/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:spo_kick/features/settings/presentation/widgets/shared/settings_section.dart';
import 'package:spo_kick/features/settings/presentation/widgets/shared/settings_switch_tile.dart';

/// Privacy settings section for user settings page.
/// Controls visibility of profile picture, phone number, and email.
class PrivacySettingsSection extends StatelessWidget {
  final UserPreferencesEntity preferences;

  const PrivacySettingsSection({super.key, required this.preferences});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: context.l10n.privacy,
      icon: Icons.privacy_tip_outlined,
      children: [
        SettingsSwitchTile(
          icon: Icons.account_circle,
          iconColor: AppColors.primary,
          title: context.l10n.showProfilePicture,
          subtitle: context.l10n.showProfilePictureDesc,
          value: preferences.showProfilePicture,
          onChanged: (_) => context
              .read<SettingsCubit>()
              .toggleShowProfilePicture(preferences),
        ),
        const SizedBox(height: SettingsConstants.itemSpacing),
        SettingsSwitchTile(
          icon: Icons.phone,
          iconColor: AppColors.info,
          title: context.l10n.showPhoneNumber,
          subtitle: context.l10n.showPhoneNumberDesc,
          value: preferences.showPhoneNumber,
          onChanged: (_) =>
              context.read<SettingsCubit>().toggleShowPhoneNumber(preferences),
        ),
        const SizedBox(height: SettingsConstants.itemSpacing),
        SettingsSwitchTile(
          icon: Icons.email,
          iconColor: AppColors.secondary,
          title: context.l10n.showEmail,
          subtitle: context.l10n.showEmailDesc,
          value: preferences.showEmail,
          onChanged: (_) =>
              context.read<SettingsCubit>().toggleShowEmail(preferences),
        ),
      ],
    );
  }
}
