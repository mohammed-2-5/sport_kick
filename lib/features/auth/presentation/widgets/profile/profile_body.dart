import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/utils/profile_utils.dart';
import 'package:spo_kick/features/auth/presentation/widgets/profile/edit_profile_dialog.dart';
import 'package:spo_kick/features/auth/presentation/widgets/profile/profile_info_card.dart';

/// Body content for Profile Page.
///
/// Displays user details and action buttons.
class ProfileBody extends StatelessWidget {
  final UserEntity user;

  const ProfileBody({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 60),
        _UserInfo(user: user),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _InfoCards(user: user),
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _ActionButtons(user: user),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

class _UserInfo extends StatelessWidget {
  final UserEntity user;

  const _UserInfo({required this.user});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Text(user.displayName, style: AppTextStyles.headlineMediumBold),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _getRoleLabel(context, user.role),
            style: AppTextStyles.labelSmallBold.copyWith(
              color: colorScheme.primary,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ],
    );
  }

  String _getRoleLabel(BuildContext context, String? role) {
    switch (role) {
      case 'admin':
        return context.l10n.roleAdmin;
      case 'super_admin':
        return context.l10n.roleSuperAdmin;
      default:
        return context.l10n.roleUser;
    }
  }
}

class _InfoCards extends StatelessWidget {
  final UserEntity user;

  const _InfoCards({required this.user});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final successColor = isDark ? AppColors.darkSuccess : AppColors.success;

    return Column(
      children: [
        ProfileInfoCard(
          icon: Icons.email_outlined,
          label: context.l10n.email,
          value: user.email,
          iconColor: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 16),
        if (user.phone != null && user.phone!.isNotEmpty) ...[
          ProfileInfoCard(
            icon: Icons.phone_outlined,
            label: context.l10n.phone,
            value: user.phone!,
            iconColor: successColor,
          ),
          const SizedBox(height: 16),
        ],
        ProfileInfoCard(
          icon: Icons.calendar_today_outlined,
          label: context.l10n.memberSince,
          value: formatMemberSince(context, user.createdAt),
          iconColor: Theme.of(context).colorScheme.secondary,
        ),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final UserEntity user;

  const _ActionButtons({required this.user});

  @override
  Widget build(BuildContext context) {
    return PremiumButton(
      label: context.l10n.editProfile,
      onPressed: () => _showEditDialog(context),
      style: PremiumButtonStyle.outline,
      icon: Icons.edit_outlined,
      fullWidth: true,
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<AuthCubit>(),
        child: const EditProfileDialog(),
      ),
    );
  }
}
