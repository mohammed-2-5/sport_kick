import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/utils/logout_dialog.dart';
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
        _buildUserInfo(context),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _buildInfoCards(context),
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _buildActions(context),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Column(
      children: [
        Text(
          user.displayName,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Builder(
            builder: (context) {
              return Text(
                _roleLabel(context),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  letterSpacing: 1.0,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCards(BuildContext context) {
    return Column(
      children: [
        ProfileInfoCard(
          icon: Icons.email_outlined,
          label: context.l10n.email,
          value: user.email,
          iconColor: Colors.blue,
        ),
        const SizedBox(height: 16),
        if (user.phone != null && user.phone!.isNotEmpty) ...[
          ProfileInfoCard(
            icon: Icons.phone_outlined,
            label: context.l10n.phone,
            value: user.phone!,
            iconColor: AppColors.success,
          ),
          const SizedBox(height: 16),
        ],
        ProfileInfoCard(
          icon: Icons.calendar_today_outlined,
          label: context.l10n.memberSince,
          value: formatMemberSince(context, user.createdAt),
          iconColor: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PremiumButton(
          label: context.l10n.editProfile,
          onPressed: () => _showEditDialog(context),
          style: PremiumButtonStyle.outline,
          icon: Icons.edit_outlined,
        ),
        const SizedBox(height: 16),
        PremiumButton(
          label: context.l10n.logout,
          onPressed: () => showLogoutConfirmation(context),
          style: PremiumButtonStyle.text,
          icon: Icons.logout,
        ),
      ],
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

  String _roleLabel(BuildContext context) {
    switch (user.role) {
      case 'admin':
        return context.l10n.roleAdmin;
      case 'super_admin':
        return context.l10n.roleSuperAdmin;
      default:
        return context.l10n.roleUser;
    }
  }
}
