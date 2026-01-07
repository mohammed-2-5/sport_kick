import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';

/// Use case for finding consecutive time slots for 2-hour bookings.
///
/// Given a time slot, finds the next consecutive hour slot.
/// Handles cross-midnight bookings (e.g., 23:00-00:00).
class FindConsecutiveSlotUseCase {
  /// Find the consecutive time slot for 2-hour bookings.
  ///
  /// Returns the next hour slot after [slot], or null if not found.
  /// Handles special case of 23:00 → 00:00 (next day).
  TimeSlotEntity? call({
    required TimeSlotEntity slot,
    required Map<String, List<TimeSlotEntity>> slotsByPeriod,
  }) {
    final startHour = int.parse(slot.startTime.split(':')[0]);
    final nextHour = (startHour + 1) % 24;
    final nextStartTime = '${nextHour.toString().padLeft(2, '0')}:00';

    // Flatten all slots
    final allSlots = slotsByPeriod.values.expand((s) => s).toList();

    // Handle cross-midnight: if current slot is 23:00, next slot is 00:00 (next day)
    final bool isNextSlotOnNextDay = slot.isNextDay || startHour == 23;

    for (final s in allSlots) {
      if (s.startTime == nextStartTime && s.isNextDay == isNextSlotOnNextDay) {
        return s;
      }
      // Special case: 23:00 slot, look for 00:00 on next day
      if (startHour == 23 &&
          !slot.isNextDay &&
          s.startTime == '00:00' &&
          s.isNextDay) {
        return s;
      }
    }

    return null;
  }
}
