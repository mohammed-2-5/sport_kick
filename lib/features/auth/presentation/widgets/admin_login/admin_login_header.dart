import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/auth/presentation/constants/auth_constants.dart';

/// Admin login header widget.
///
/// Displays admin icon, title, and subtitle for the admin login page.
class AdminLoginHeader extends StatelessWidget {
  const AdminLoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.admin_panel_settings,
            size: AuthConstants.logoSize,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: AuthConstants.formFieldSpacing),
        Text(
          AuthConstants.adminLoginTitle,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          AuthConstants.adminLoginSubtitle,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
