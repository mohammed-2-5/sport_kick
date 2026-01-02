import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_gradients.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';

/// Utility class for booking status-related UI helpers.
///
/// Provides centralized methods for:
/// - Status colors
/// - Status gradients
/// - Status icons
/// - Date/time formatting
class BookingStatusUtils {
  BookingStatusUtils._();

  /// Returns the primary color for a booking status.
  /// Pass [isDark] to get theme-aware colors.
  static Color getStatusColor(BookingStatus status, {bool isDark = false}) {
    switch (status) {
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

  /// Returns the gradient for a booking status.
  /// Pass [isDark] to get theme-aware gradients.
  static LinearGradient getStatusGradient(
    BookingStatus status, {
    bool isDark = false,
  }) {
    switch (status) {
      case BookingStatus.pending:
        return isDark ? AppGradients.darkWarning : AppGradients.warning;
      case BookingStatus.confirmed:
        return isDark ? AppGradients.darkSuccess : AppGradients.success;
      case BookingStatus.canceled:
        return isDark ? AppGradients.darkError : AppGradients.error;
      case BookingStatus.completed:
        final completedColor = isDark
            ? AppColors.darkBookingCompleted
            : AppColors.bookingCompleted;
        return LinearGradient(
          colors: [completedColor, completedColor.withValues(alpha: 0.8)],
        );
    }
  }

  /// Returns the icon for a booking status.
  static IconData getStatusIcon(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Icons.schedule;
      case BookingStatus.confirmed:
        return Icons.check_circle;
      case BookingStatus.canceled:
        return Icons.cancel;
      case BookingStatus.completed:
        return Icons.done_all;
    }
  }

  /// Returns localized status label.
  static String getStatusLabel(BuildContext context, BookingStatus status) {
    final l10n = context.l10n;
    switch (status) {
      case BookingStatus.pending:
        return l10n.statusPending;
      case BookingStatus.confirmed:
        return l10n.statusConfirmed;
      case BookingStatus.canceled:
        return l10n.statusCancelled;
      case BookingStatus.completed:
        return l10n.statusCompleted;
    }
  }

  /// Formats a DateTime to a readable string.
  static String formatDateTime(DateTime dateTime) {
    final locale = Intl.getCurrentLocale();
    final date = DateFormat.yMMMd(locale).format(dateTime);
    final time = DateFormat.Hm(locale).format(dateTime);
    return '$date $time';
  }
}
