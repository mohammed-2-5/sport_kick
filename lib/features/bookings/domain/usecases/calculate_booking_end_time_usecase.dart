/// Use case for calculating booking end time based on start time and duration.
///
/// Calculates the end time by adding the duration hours to the start time.
/// Returns null if the end time would be >= 24:00 (next day).
class CalculateBookingEndTimeUseCase {
  /// Calculate end time based on start time and duration.
  ///
  /// [startTime] - Start time in HH:mm format (e.g., "14:30")
  /// [durationHours] - Duration in hours (1 or 2)
  ///
  /// Returns the end time in HH:mm format, or null if end time >= 24:00.
  String? call({required String startTime, required int durationHours}) {
    try {
      final parts = startTime.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      // Calculate end time based on duration
      final endHour = hour + durationHours;

      // Return null if end time would be on next day (>= 24:00)
      if (endHour >= 24) {
        return null;
      }

      return '${endHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return null;
    }
  }
}
