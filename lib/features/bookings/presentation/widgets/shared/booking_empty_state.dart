import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Empty state widget shown when no time slots are available.
///
/// Displays an icon, message, and action button to select another date.
class BookingEmptyState extends StatelessWidget {
  final String message;
  final VoidCallback onSelectDatePressed;

  const BookingEmptyState({
    super.key,
    required this.message,
    required this.onSelectDatePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 80,
              color: AppColors.textSecondary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: onSelectDatePressed,
              icon: const Icon(Icons.calendar_today),
              label: const Text('Choose Another Date'),
            ),
          ],
        ),
      ),
    );
  }
}
