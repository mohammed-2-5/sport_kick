import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Empty state widget shown when user has no bookings at all.
///
/// Displays an icon, message, and action button to browse fields.
class MyBookingsEmptyState extends StatelessWidget {
  final String message;
  final VoidCallback onBrowseFields;

  const MyBookingsEmptyState({
    super.key,
    required this.message,
    required this.onBrowseFields,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_note,
            size: 80,
            color: AppColors.textSecondary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onBrowseFields,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Browse Fields'),
          ),
        ],
      ),
    );
  }
}
