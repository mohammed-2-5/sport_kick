import 'package:flutter/material.dart';
import 'package:spo_kick/features/super_admin/presentation/constants/admin_ui_constants.dart';

/// Statistics card widget for user details page
class UserStatsCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const UserStatsCard({
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
            style: TextStyle(
              fontSize: AdminUIConstants.statCardValueSize,
              fontWeight: AdminUIConstants.fontWeightBold,
              color: color,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: AdminUIConstants.statCardLabelSize,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
