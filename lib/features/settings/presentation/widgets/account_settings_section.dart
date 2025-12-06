import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/widgets/edit_profile_dialog.dart';
import 'package:spo_kick/features/settings/presentation/constants/settings_constants.dart';
import 'package:spo_kick/features/settings/presentation/widgets/settings_section.dart';
import 'package:spo_kick/features/settings/presentation/widgets/settings_tile.dart';

/// Account settings section for user settings page.
/// Includes edit profile and change password options.
class AccountSettingsSection extends StatelessWidget {
  const AccountSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'Account',
      icon: Icons.person_outline,
      children: [
        SettingsTile(
          leading: const Icon(Icons.edit, color: AppColors.info),
          title: 'Edit Profile',
          subtitle: 'Update your personal information',
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showEditProfileDialog(context),
        ),
        const SizedBox(height: SettingsConstants.itemSpacing),
        SettingsTile(
          leading: const Icon(Icons.lock_reset, color: AppColors.primary),
          title: 'Change Password',
          subtitle: 'Update your account password',
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
