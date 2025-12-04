/// Utility class for validating business hours data.
///
/// Contains all validation logic for time ranges and constraints.
/// No UI code - pure logic only.
class BusinessHoursValidators {
  BusinessHoursValidators._();

  /// Validates that opening time is before closing time.
  ///
  /// Returns true if the time range is valid, false otherwise.
  /// Time strings should be in HH:MM:SS or HH:MM format.
  static bool isTimeRangeValid(String openingTime, String closingTime) {
    final openingParts = openingTime.split(':');
    final closingParts = closingTime.split(':');

    if (openingParts.length < 2 || closingParts.length < 2) {
      return false;
    }

    final openingHour = int.tryParse(openingParts[0]) ?? 0;
    final openingMinute = int.tryParse(openingParts[1]) ?? 0;
    final closingHour = int.tryParse(closingParts[0]) ?? 0;
    final closingMinute = int.tryParse(closingParts[1]) ?? 0;

    final openingTotal = openingHour * 60 + openingMinute;
    final closingTotal = closingHour * 60 + closingMinute;

    return openingTotal < closingTotal;
  }
}
