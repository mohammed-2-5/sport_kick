import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/widgets/profile/edit_profile_dialog.dart';
import 'package:spo_kick/features/settings/presentation/constants/settings_constants.dart';
import 'package:spo_kick/features/settings/presentation/widgets/shared/settings_section.dart';
import 'package:spo_kick/features/settings/presentation/widgets/shared/settings_tile.dart';

/// Account settings section for user settings page.
/// Includes edit profile and change password options.
class AccountSettingsSection extends StatelessWidget {
  const AccountSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: context.l10n.account,
      icon: Icons.person_outline,
      children: [
        SettingsTile(
          leading: const Icon(
            Icons.account_circle_outlined,
            color: AppColors.accentCyan,
          ),
          title: context.l10n.profile,
          subtitle: context.l10n.viewYourProfileDetails,
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.pushNamed('profile'),
        ),
        const SizedBox(height: SettingsConstants.itemSpacing),
        SettingsTile(
          leading: const Icon(Icons.edit, color: AppColors.info),
          title: context.l10n.editProfile,
          subtitle: context.l10n.editProfileDesc,
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showEditProfileDialog(context),
        ),
        const SizedBox(height: SettingsConstants.itemSpacing),
        SettingsTile(
          leading: const Icon(Icons.lock_reset, color: AppColors.primary),
          title: context.l10n.changePassword,
          subtitle: context.l10n.changePasswordDesc,
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            context.pushNamed('changePassword');
          },
        ),
      ],
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<AuthCubit>(),
        child: const EditProfileDialog(),
      ),
    );
  }
}
