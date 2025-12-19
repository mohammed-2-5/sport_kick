import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Utility helpers for locale-aware formatting of dates, times, and numbers.
class LocaleFormatters {
  const LocaleFormatters._();

  /// Formats a date using the current locale.
  static String formatDate(
    BuildContext context,
    DateTime date, {
    String pattern = 'yMMMd',
  }) {
    final locale = Localizations.localeOf(context).toString();
    return DateFormat(pattern, locale).format(date);
  }

  /// Formats a time range like "09:00 - 10:00" with locale digits/AM-PM.
  ///
  /// [startTime] and [endTime] are in "HH:mm" format.
  /// If [isEndNextDay] is true, the end time is shifted to the next day.
  static String formatTimeRange(
    BuildContext context, {
    required String startTime,
    required String endTime,
    DateTime? baseDate,
    bool isEndNextDay = false,
  }) {
    final locale = Localizations.localeOf(context).toString();
    final base = baseDate ?? DateTime.now();

    DateTime combine(String time, {int addDays = 0}) {
      final parts = time.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      return DateTime(base.year, base.month, base.day + addDays, hour, minute);
    }

    final start = combine(startTime);
    final end = combine(endTime, addDays: isEndNextDay ? 1 : 0);
    final formatter = DateFormat.jm(locale);
    return '${formatter.format(start)} - ${formatter.format(end)}';
  }

  /// Formats a single time string (HH:mm or HH:mm:ss) using the current locale.
  static String formatTime(BuildContext context, String time) {
    final locale = Localizations.localeOf(context).toString();
    final parts = time.split(':');
    if (parts.length < 2) return time;

    final base = DateTime.now();
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;
    final date = DateTime(base.year, base.month, base.day, hour, minute);
    return DateFormat.jm(locale).format(date);
  }

  /// Formats a plain number with locale digits.
  static String formatNumber(
    BuildContext context,
    num value, {
    int? decimalDigits,
  }) {
    final locale = Localizations.localeOf(context).toString();
    final format = NumberFormat.decimalPattern(locale);
    if (decimalDigits != null) {
      format.minimumFractionDigits = decimalDigits;
      format.maximumFractionDigits = decimalDigits;
    }
    return format.format(value);
  }

  /// Formats a price with locale digits and provided currency code/symbol.
  static String formatPrice(
    BuildContext context, {
    required num amount,
    required String currency,
    int? decimalDigits,
  }) {
    final number = formatNumber(context, amount, decimalDigits: decimalDigits);
    return '$number $currency';
  }

  /// Returns localized weekday name for an index where 0 = Saturday.
  static String weekdayName(
    BuildContext context,
    int dayOfWeek, {
    bool short = false,
  }) {
    final locale = Localizations.localeOf(context).toString();
    // January 7, 2023 is a Saturday. Add the index to get the target weekday.
    final date = DateTime.utc(2023, 1, 7 + dayOfWeek);
    final formatter = DateFormat(short ? 'EEE' : 'EEEE', locale);
    return formatter.format(date);
  }
}
