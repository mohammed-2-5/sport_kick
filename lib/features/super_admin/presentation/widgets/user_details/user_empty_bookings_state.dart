import 'package:flutter/material.dart';
import 'package:spo_kick/features/super_admin/presentation/constants/admin_ui_constants.dart';

/// Empty state widget for when no bookings are found
class UserEmptyBookingsState extends StatelessWidget {
  const UserEmptyBookingsState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AdminUIConstants.emptyStatePadding),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: AdminUIConstants.borderRadiusMedium,
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Icon(
            Icons.event_busy,
            size: AdminUIConstants.emptyStateIconSize,
            color: Colors.grey[400],
          ),
          const SizedBox(height: AdminUIConstants.listItemSpacing),
          const Text(
            'No Bookings Yet',
            style: TextStyle(
              fontSize: AdminUIConstants.fontSizeLarge,
              fontWeight: AdminUIConstants.fontWeightBold,
            ),
          ),
          const SizedBox(height: AdminUIConstants.spacingSmall),
          Text(
            'This user hasn\'t made any bookings yet',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AdminUIConstants.fontSizeMedium,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
