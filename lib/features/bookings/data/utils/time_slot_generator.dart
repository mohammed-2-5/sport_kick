import 'package:spo_kick/features/bookings/data/models/time_slot_model.dart';

/// Utility class for generating time slots based on business hours.
///
/// Handles both regular hours and cross-midnight scenarios.
class TimeSlotGenerator {
  /// Generate time slots for a field based on business hours and bookings.
  ///
  /// Supports cross-midnight business hours (e.g., 12 PM - 2 AM).
  ///
  /// Parameters:
  /// - [openingHour] - Opening hour (0-23)
  /// - [closingHour] - Closing hour (0-23)
  /// - [closesNextDay] - Whether business hours cross midnight
  /// - [pricePerHour] - Price per hour slot
  /// - [currency] - Currency code (e.g., 'EGP')
  /// - [bookedSlotsCurrentDay] - Set of booked start times for current day
  /// - [bookedSlotsNextDay] - Set of booked start times for next day
  ///
  /// Returns list of [TimeSlotModel] with availability status.
  static List<TimeSlotModel> generateTimeSlots({
    required int openingHour,
    required int closingHour,
    required bool closesNextDay,
    required double pricePerHour,
    required String currency,
    required Set<String> bookedSlotsCurrentDay,
    required Set<String> bookedSlotsNextDay,
  }) {
    final slots = <TimeSlotModel>[];

    // Generate same-day slots (from opening to midnight or closing)
    final sameDayEndHour = closesNextDay ? 24 : closingHour;

    for (int hour = openingHour; hour < sameDayEndHour; hour++) {
      final startTime = _formatTime(hour);
      final endTime = _formatTime((hour + 1) % 24);
      final isAvailable = !bookedSlotsCurrentDay.contains(startTime);

      slots.add(
        TimeSlotModel(
          startTime: startTime,
          endTime: endTime,
          isAvailable: isAvailable,
          price: pricePerHour,
          currency: currency,
          isNextDay: false,
        ),
      );
    }

    // Generate next-day slots (from midnight to closing time) if cross-midnight
    if (closesNextDay) {
      for (int hour = 0; hour < closingHour; hour++) {
        final startTime = _formatTime(hour);
        final endTime = _formatTime(hour + 1);
        final isAvailable = !bookedSlotsNextDay.contains(startTime);

        slots.add(
          TimeSlotModel(
            startTime: startTime,
            endTime: endTime,
            isAvailable: isAvailable,
            price: pricePerHour,
            currency: currency,
            isNextDay: true,
          ),
        );
      }
    }

    return slots;
  }

  /// Format hour as HH:00 time string.
  static String _formatTime(int hour) {
    return '${hour.toString().padLeft(2, '0')}:00';
  }

  /// Parse time string (HH:MM:SS or HH:MM) to hour component.
  ///
  /// Returns null if parsing fails.
  static int? parseTimeToHour(String? timeString) {
    if (timeString == null || timeString.isEmpty) return null;
    try {
      final parts = timeString.split(':');
      return int.parse(parts[0]);
    } catch (e) {
      return null;
    }
  }

  /// Extract booked time slots from booking records.
  ///
  /// Normalizes time strings to HH:MM format for comparison.
  static Set<String> extractBookedSlots(List<dynamic> bookings) {
    final bookedSlots = <String>{};
    for (final booking in bookings) {
      if (booking is Map<String, dynamic>) {
        final startTime = booking['start_time'] as String?;
        if (startTime != null) {
          final normalizedTime = startTime.substring(0, 5); // Get HH:MM
          bookedSlots.add(normalizedTime);
        }
      }
    }
    return bookedSlots;
  }
}
