import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.roleSuperAdmin,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.premiumTextPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  context.l10n.platformOverview,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.premiumTextSecondary,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                // Settings Icon
                IconButton(
                  onPressed: () {
                    context.pushNamed('superAdminSettings');
                  },
                  icon: const Icon(
                    Icons.settings,
                    color: AppColors.premiumTextSecondary,
                  ),
                  tooltip: context.l10n.settings,
                ),
                const SizedBox(width: 8),
                // Profile Icon
                InkWell(
                  onTap: () {
                    context.pushNamed('profile');
                  },
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.premiumGold,
                        width: 2,
                      ),
                    ),
                    child: const CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.premiumSurface,
                      child: Icon(Icons.person, color: AppColors.premiumGold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
