import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Hint banner for booking table.
///
/// Shows either:
/// - Scroll hint when bookings exist
/// - Empty state message when no bookings
class BookingTableHintBanner extends StatelessWidget {
  final bool hasBookings;

  const BookingTableHintBanner({required this.hasBookings, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          if (!hasBookings) const _EmptyStateHint() else const _ScrollHint(),
        ],
      ),
    );
  }
}

/// Empty state hint when no bookings.
class _EmptyStateHint extends StatelessWidget {
  const _EmptyStateHint();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.textSecondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.textSecondary.withValues(alpha: 0.3),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 16,
            color: AppColors.textSecondary,
          ),
          SizedBox(width: 6),
          Text(
            'No bookings for this field in this week',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Scroll hint when bookings exist.
class _ScrollHint extends StatelessWidget {
  const _ScrollHint();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.goldAccent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.goldAccent.withValues(alpha: 0.3)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.swipe_right_rounded,
            size: 16,
            color: AppColors.goldAccent,
          ),
          SizedBox(width: 6),
          Text(
            'Scroll right to see all days (Sat-Fri)',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.goldAccent,
            ),
          ),
        ],
      ),
    );
  }
}
