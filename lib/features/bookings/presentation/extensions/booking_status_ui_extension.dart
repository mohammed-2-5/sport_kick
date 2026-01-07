import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_gradients.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';

/// UI properties extension for BookingStatus
///
/// Provides theme-aware colors, gradients, and icons for booking status display.
/// This extension is in the presentation layer to keep domain layer pure.
extension BookingStatusUIExtension on BookingStatus {
  /// Theme-aware chip color. Pass [isDark] for dark theme support.
  Color getColor({bool isDark = false}) {
    switch (this) {
      case BookingStatus.pending:
        return isDark ? AppColors.darkBookingPending : AppColors.bookingPending;
      case BookingStatus.confirmed:
        return isDark
            ? AppColors.darkBookingConfirmed
            : AppColors.bookingConfirmed;
      case BookingStatus.canceled:
        return isDark
            ? AppColors.darkBookingCancelled
            : AppColors.bookingCancelled;
      case BookingStatus.completed:
        return isDark
            ? AppColors.darkBookingCompleted
            : AppColors.bookingCompleted;
    }
  }

  /// Theme-aware gradient for status badge. Pass [isDark] for dark theme.
  LinearGradient getGradient({bool isDark = false}) {
    switch (this) {
      case BookingStatus.pending:
        return isDark ? AppGradients.darkWarning : AppGradients.warning;
      case BookingStatus.confirmed:
        return isDark ? AppGradients.darkSuccess : AppGradients.success;
      case BookingStatus.canceled:
        return isDark ? AppGradients.darkError : AppGradients.error;
      case BookingStatus.completed:
        final color = isDark
            ? AppColors.darkBookingCompleted
            : AppColors.bookingCompleted;
        return LinearGradient(colors: [color, color.withValues(alpha: 0.8)]);
    }
  }

  /// Icon for status display in UI
  IconData get icon {
    switch (this) {
      case BookingStatus.pending:
        return Icons.pending_actions_rounded;
      case BookingStatus.confirmed:
        return Icons.check_circle_rounded;
      case BookingStatus.canceled:
        return Icons.cancel_rounded;
      case BookingStatus.completed:
        return Icons.done_all_rounded;
    }
  }
}
