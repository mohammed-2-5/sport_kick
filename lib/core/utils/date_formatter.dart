import 'package:spo_kick/features/settings/domain/entities/user_preferences_entity.dart';

/// Date formatting utility.
///
/// Provides static methods for formatting dates in consistent formats
/// across the application.
class DateFormatter {
  DateFormatter._();

  /// Month abbreviations.
  static const List<String> _monthAbbreviations = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  /// Full month names.
  static const List<String> _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  /// Formats date as "Jan 1, 2025".
  static String formatMonthDayYear(DateTime date) {
    return '${_monthAbbreviations[date.month - 1]} ${date.day}, ${date.year}';
  }

  /// Formats date as "January 1, 2025".
  static String formatFullMonthDayYear(DateTime date) {
    return '${_monthNames[date.month - 1]} ${date.day}, ${date.year}';
  }

  /// Formats date as "01/15/2025".
  static String formatSlashDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$month/$day/${date.year}';
  }

  /// Formats date as "2025-01-15".
  static String formatISODate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  /// Formats time as "2:30 PM".
  static String formatTime(DateTime time) {
    final hour = time.hour > 12
        ? time.hour - 12
        : (time.hour == 0 ? 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  /// Formats datetime as "Jan 1, 2025 at 2:30 PM".
  static String formatDateTime(DateTime dateTime) {
    return '${formatMonthDayYear(dateTime)} at ${formatTime(dateTime)}';
  }

  /// Returns relative time like "2 hours ago", "yesterday", etc.
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return years == 1 ? '1 year ago' : '$years years ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return months == 1 ? '1 month ago' : '$months months ago';
    } else if (difference.inDays > 0) {
      if (difference.inDays == 1) return 'Yesterday';
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return difference.inHours == 1
          ? '1 hour ago'
          : '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return difference.inMinutes == 1
          ? '1 minute ago'
          : '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  /// Formats date according to user's preferred format.
  ///
  /// Supports:
  /// - DD/MM/YYYY (e.g., 25/12/2025)
  /// - MM/DD/YYYY (e.g., 12/25/2025)
  /// - YYYY-MM-DD (e.g., 2025-12-25)
  static String formatWithPreference(DateTime date, DateFormatOption format) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    switch (format) {
      case DateFormatOption.ddMMyyyy:
        return '$day/$month/$year';
      case DateFormatOption.mmDdYyyy:
        return '$month/$day/$year';
      case DateFormatOption.yyyyMmDd:
        return '$year-$month-$day';
    }
  }

  /// Returns display label for date format option.
  static String getDateFormatLabel(DateFormatOption format) {
    switch (format) {
      case DateFormatOption.ddMMyyyy:
        return 'DD/MM/YYYY';
      case DateFormatOption.mmDdYyyy:
        return 'MM/DD/YYYY';
      case DateFormatOption.yyyyMmDd:
        return 'YYYY-MM-DD';
    }
  }
}
