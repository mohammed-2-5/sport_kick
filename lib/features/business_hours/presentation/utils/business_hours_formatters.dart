import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/features/business_hours/presentation/constants/business_hours_constants.dart';

/// Utility class for formatting business hours data.
///
/// Contains all formatting logic for times, days, and hour ranges.
/// No UI code - pure logic only.
class BusinessHoursFormatters {
  BusinessHoursFormatters._();

  static final _baseSunday = DateTime(2023, 1, 1);

  static String _normalizeTime(String? time, String fallback) {
    final value = time ?? fallback;
    final parts = value.split(':');
    if (parts.length < 2) {
      return fallback.substring(0, 5);
    }

    final hourPart = parts[0].padLeft(2, '0');
    final minutePart = parts[1].padLeft(2, '0');
    return '$hourPart:$minutePart';
  }

  /// Formats a time string (HH:MM[:SS]) using the current locale.
  static String formatTime(BuildContext context, {String? time}) {
    final cleaned = _normalizeTime(
      time,
      BusinessHoursConstants.defaultOpeningTime,
    );
    return LocaleFormatters.formatTime(context, cleaned);
  }

  /// Formats a time range for display with locale-aware digits/periods.
  static String formatTimeRange(
    BuildContext context, {
    String? openingTime,
    String? closingTime,
    bool isEndNextDay = false,
  }) {
    final opening = _normalizeTime(
      openingTime,
      BusinessHoursConstants.defaultOpeningTime,
    );
    final closing = _normalizeTime(
      closingTime,
      BusinessHoursConstants.defaultClosingTime,
    );

    return LocaleFormatters.formatTimeRange(
      context,
      startTime: opening,
      endTime: closing,
      isEndNextDay: isEndNextDay,
    );
  }

  /// Gets the full day name for a day of week (0-6)
  static String getDayName(BuildContext context, int dayOfWeek) {
    if (dayOfWeek < 0 || dayOfWeek >= BusinessHoursConstants.daysInWeek) {
      return '';
    }
    final locale = Localizations.localeOf(context).toString();
    final date = _baseSunday.add(Duration(days: dayOfWeek));
    return DateFormat.EEEE(locale).format(date);
  }

  /// Gets the short day name for a day of week (0-6)
  static String getDayNameShort(BuildContext context, int dayOfWeek) {
    if (dayOfWeek < 0 || dayOfWeek >= BusinessHoursConstants.daysInWeek) {
      return '';
    }
    final locale = Localizations.localeOf(context).toString();
    final date = _baseSunday.add(Duration(days: dayOfWeek));
    return DateFormat.E(locale).format(date);
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
