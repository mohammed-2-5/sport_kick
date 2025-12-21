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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: showGlow
            ? [BoxShadow(color: _glowColor, blurRadius: 12, spreadRadius: 2)]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, color: _foregroundColor, size: 16),
          const SizedBox(width: 6),
          Text(
            BookingStatusUtils.getStatusLabel(context, status),
            style: AppTextStyles.labelSmall.copyWith(
              color: _foregroundColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color get _backgroundColor {
    switch (status) {
      case BookingStatus.pending:
        return AppColors.warning.withValues(alpha: 0.15);
      case BookingStatus.confirmed:
        return AppColors.success.withValues(alpha: 0.15);
      case BookingStatus.completed:
        return AppColors.info.withValues(alpha: 0.15);
      case BookingStatus.canceled:
        return AppColors.error.withValues(alpha: 0.15);
    }
  }

  Color get _foregroundColor {
    switch (status) {
      case BookingStatus.pending:
        return AppColors.warning;
      case BookingStatus.confirmed:
        return AppColors.success;
      case BookingStatus.completed:
        return AppColors.info;
      case BookingStatus.canceled:
        return AppColors.error;
    }
  }

  Color get _glowColor {
    switch (status) {
      case BookingStatus.pending:
        return AppColors.warning.withValues(alpha: 0.3);
      case BookingStatus.confirmed:
        return AppColors.success.withValues(alpha: 0.3);
      case BookingStatus.completed:
        return AppColors.info.withValues(alpha: 0.3);
      case BookingStatus.canceled:
        return AppColors.error.withValues(alpha: 0.3);
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
