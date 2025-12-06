import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/core/widgets/custom_button.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/auth/presentation/utils/logout_dialog.dart';
import 'package:spo_kick/features/auth/presentation/widgets/edit_profile_dialog.dart';
import 'package:spo_kick/features/auth/presentation/widgets/profile/profile_header.dart';
import 'package:spo_kick/features/auth/presentation/widgets/profile/profile_info_card.dart';

/// Profile page with premium curved design and overlapping avatar.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            context.goNamed('login');
          } else if (state is AuthError) {
            SnackbarHelper.showError(context, state.message);
          } else if (state is ProfileUpdated) {
            SnackbarHelper.showSuccess(context, 'Profile updated successfully');
          }
        },
        builder: (context, state) {
          if (state is! Authenticated) {
            return const Center(
              child: Text('Please login to view your profile'),
            );
          }

          final user = state.user;

          return SingleChildScrollView(
            child: Column(
              children: [
                ProfileHeader(
                  avatarUrl: user.avatarUrl,
                  initials: user.initials,
                  onBackPressed: () => Navigator.pop(context),
                ),

                const SizedBox(height: 60),
                // User Name & Role
                Text(
                  user.displayName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    user.role.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Info Cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      ProfileInfoCard(
                        icon: Icons.email_outlined,
                        label: 'Email',
                        value: user.email,
                        iconColor: Colors.blue,
                      ),
                      const SizedBox(height: 16),
                      if (user.phone != null && user.phone!.isNotEmpty) ...[
                        ProfileInfoCard(
                          icon: Icons.phone_outlined,
                          label: 'Phone',
                          value: user.phone!,
                          iconColor: AppColors.success,
                        ),
                        const SizedBox(height: 16),
                      ],
                      ProfileInfoCard(
                        icon: Icons.calendar_today_outlined,
                        label: 'Member Since',
                        value: _formatDate(user.createdAt),
                        iconColor: Colors.purple,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Actions
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomButton(
                        text: 'Edit Profile',
                        onPressed: () => showDialog(
                          context: context,
                          builder: (_) => const EditProfileDialog(),
                        ),
                        variant: ButtonVariant.outline,
                        icon: Icons.edit_outlined,
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: 'Logout',
                        onPressed: () => showLogoutConfirmation(context),
                        variant: ButtonVariant.text,
                        icon: Icons.logout,
                        textColor: AppColors.error,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
