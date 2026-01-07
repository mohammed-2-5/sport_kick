import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';

/// Use case for grouping time slots by period of day.
///
/// Groups time slots into periods:
/// - Morning: 00:00 - 11:59
/// - Afternoon: 12:00 - 16:59
/// - Evening: 17:00 - 22:59
/// - Late Night: Cross-midnight slots (next day)
///
/// Empty periods are automatically removed from the result.
class GroupTimeSlotsByPeriodUseCase {
  /// Group time slots by period (Morning, Afternoon, Evening, Late Night).
  Map<String, List<TimeSlotEntity>> call(List<TimeSlotEntity> slots) {
    final Map<String, List<TimeSlotEntity>> grouped = {
      'Morning': [],
      'Afternoon': [],
      'Evening': [],
      'Late Night': [],
    };

    for (final slot in slots) {
      // Late night slots are those on the next day (cross-midnight)
      if (slot.isNextDay) {
        grouped['Late Night']!.add(slot);
      } else {
        final hour = int.tryParse(slot.startTime.split(':')[0]) ?? 0;
        if (hour < 12) {
          grouped['Morning']!.add(slot);
        } else if (hour < 17) {
          grouped['Afternoon']!.add(slot);
        } else {
          grouped['Evening']!.add(slot);
        }
      }
    }

    // Remove empty periods
    grouped.removeWhere((key, value) => value.isEmpty);

    return grouped;
  }
}
