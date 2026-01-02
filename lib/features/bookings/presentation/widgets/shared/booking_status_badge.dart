import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/bookings/presentation/utils/booking_status_utils.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Premium status badge with glow effect for bookings.
///
/// Displays booking status with appropriate color and optional glow.
class BookingStatusBadge extends StatelessWidget {
  final BookingStatus status;
  final bool showGlow;

  const BookingStatusBadge({
    super.key,
    required this.status,
    this.showGlow = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final foregroundColor = _getForegroundColor(isDark);
    final backgroundColor = foregroundColor.withValues(alpha: 0.15);
    final glowColor = foregroundColor.withValues(alpha: 0.3);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: showGlow
            ? [BoxShadow(color: glowColor, blurRadius: 12, spreadRadius: 2)]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, color: foregroundColor, size: 16),
          const SizedBox(width: 6),
          Text(
            BookingStatusUtils.getStatusLabel(context, status),
            style: AppTextStyles.labelSmall.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getForegroundColor(bool isDark) {
    switch (status) {
      case BookingStatus.pending:
        return isDark ? AppColors.darkWarning : AppColors.warning;
      case BookingStatus.confirmed:
        return isDark ? AppColors.darkSuccess : AppColors.success;
      case BookingStatus.completed:
        return isDark ? AppColors.darkInfo : AppColors.info;
      case BookingStatus.canceled:
        return isDark ? AppColors.darkError : AppColors.error;
    }
  }

  IconData get _icon {
    switch (status) {
      case BookingStatus.pending:
        return Icons.schedule;
      case BookingStatus.confirmed:
        return Icons.check_circle_outline;
      case BookingStatus.completed:
        return Icons.verified;
      case BookingStatus.canceled:
        return Icons.cancel_outlined;
    }
  }
}
