import 'package:spo_kick/features/business_hours/domain/entities/business_hours_entity.dart';

/// Helper utilities for booking table operations.
///
/// Contains pure functions for:
/// - Working hours generation
/// - Business hours validation
/// - Date/time checks
class BookingTableHelpers {
  BookingTableHelpers._();

  /// Generate list of working hours based on business hours.
  ///
  /// Returns hourly slots (e.g., "09:00", "10:00") from earliest opening
  /// to latest closing time across all days.
  static List<String> generateWorkingHours(
    List<BusinessHoursEntity> businessHours,
  ) {
    int minOpen = 9; // Default 09:00
    int maxClose = 22; // Default 22:00

    for (final hours in businessHours) {
      if (!hours.isOpen) continue;

      final openHour =
          int.tryParse(hours.openingTime?.split(':')[0] ?? '9') ?? 9;
      final closeHour =
          int.tryParse(hours.closingTime?.split(':')[0] ?? '22') ?? 22;

      if (openHour < minOpen) minOpen = openHour;
      if (closeHour > maxClose) maxClose = closeHour;
    }

    return List.generate(
      maxClose - minOpen,
      (i) => '${(minOpen + i).toString().padLeft(2, '0')}:00',
    );
  }

  /// Check if a specific hour is within business hours for a day.
  ///
  /// Returns true if the field is open at the given hour.
  static bool isHourOpen(String hour, BusinessHoursEntity? businessHours) {
    if (businessHours == null) return false;
    if (!businessHours.isOpen) return false;

    final hourInt = int.tryParse(hour.split(':')[0]) ?? 0;
    final openHour =
        int.tryParse(businessHours.openingTime?.split(':')[0] ?? '0') ?? 0;
    final closeHour =
        int.tryParse(businessHours.closingTime?.split(':')[0] ?? '24') ?? 24;

    return hourInt >= openHour && hourInt < closeHour;
  }

  /// Check if a date is today.
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
