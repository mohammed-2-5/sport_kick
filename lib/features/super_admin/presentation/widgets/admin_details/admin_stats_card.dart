import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/super_admin/presentation/constants/admin_ui_constants.dart';

/// Statistics card widget for admin details page
class AdminStatsCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const AdminStatsCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AdminUIConstants.paddingAll,
      decoration: BoxDecoration(
        color: color.withValues(alpha: AdminUIConstants.opacityLight),
        borderRadius: AdminUIConstants.borderRadiusMedium,
        border: Border.all(
          color: color.withValues(alpha: AdminUIConstants.opacityMedium),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: AdminUIConstants.statCardIconSize),
          const SizedBox(height: AdminUIConstants.spacingSmall),
          Text(
            value,
            style: AppTextStyles.bold(
              AppTextStyles.withColor(AppTextStyles.headlineSmall, color),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
