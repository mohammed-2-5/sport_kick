import 'package:spo_kick/features/business_hours/presentation/constants/business_hours_constants.dart';
import 'package:spo_kick/features/business_hours/presentation/constants/business_hours_strings.dart';

/// Utility class for formatting business hours data.
///
/// Contains all formatting logic for times, days, and hour ranges.
/// No UI code - pure logic only.
class BusinessHoursFormatters {
  BusinessHoursFormatters._();

  /// Formats a time string (HH:MM:SS) to display format (HH:MM AM/PM)
  static String formatTime(String time) {
    final parts = time.split(':');
    if (parts.length < 2) return time;

    int hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts[1];

    final period = hour >= 12 ? 'PM' : 'AM';
    if (hour > 12) {
      hour -= 12;
    } else if (hour == 0) {
      hour = 12;
    }

    return '$hour:$minute $period';
  }

  /// Formats a time range for display
  static String formatTimeRange(String? openingTime, String? closingTime) {
    final opening = formatTime(
      openingTime ?? BusinessHoursConstants.defaultOpeningTime,
    );
    final closing = formatTime(
      closingTime ?? BusinessHoursConstants.defaultClosingTime,
    );

    return '$opening${BusinessHoursStrings.timeSeparator}$closing';
  }

  /// Gets the full day name for a day of week (0-6)
  static String getDayName(int dayOfWeek) {
    if (dayOfWeek < 0 || dayOfWeek >= BusinessHoursStrings.dayNames.length) {
      return '';
    }
    return BusinessHoursStrings.dayNames[dayOfWeek];
  }

  /// Gets the short day name for a day of week (0-6)
  static String getDayNameShort(int dayOfWeek) {
    if (dayOfWeek < 0 ||
        dayOfWeek >= BusinessHoursStrings.dayNamesShort.length) {
      return '';
    }
    return BusinessHoursStrings.dayNamesShort[dayOfWeek];
  }

  /// Checks if the hours represent 24/7 operation
  static bool is24Hours(bool isOpen, String? openingTime, String? closingTime) {
    if (!isOpen) return false;

    final opening = openingTime;
    final closing = closingTime;

    return opening == BusinessHoursConstants.defaultOpeningTime &&
        (closing == BusinessHoursConstants.defaultClosingTime ||
            closing == '23:59:00');
  }
}
