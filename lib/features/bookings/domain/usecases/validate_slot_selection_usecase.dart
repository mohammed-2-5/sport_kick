import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';
import 'package:spo_kick/features/bookings/domain/usecases/find_consecutive_slot_usecase.dart';

/// Use case for validating if a time slot can be selected.
///
/// Validates based on:
/// - Slot availability
/// - Duration requirements (1 or 2 hours)
/// - Consecutive slot availability for 2-hour bookings
class ValidateSlotSelectionUseCase {
  final FindConsecutiveSlotUseCase findConsecutiveSlotUseCase;

  ValidateSlotSelectionUseCase({required this.findConsecutiveSlotUseCase});

  /// Check if a slot can be selected for the given duration.
  ///
  /// For 1-hour bookings, only checks if the slot is available.
  /// For 2-hour bookings, also checks if the consecutive slot is available.
  bool call({
    required TimeSlotEntity slot,
    required int durationHours,
    required Map<String, List<TimeSlotEntity>> slotsByPeriod,
  }) {
    if (durationHours == 1) {
      return slot.isAvailable;
    }

    // For 2-hour booking, check if consecutive slot is also available
    final secondSlot = findConsecutiveSlotUseCase(
      slot: slot,
      slotsByPeriod: slotsByPeriod,
    );
    return slot.isAvailable && secondSlot != null && secondSlot.isAvailable;
  }
}
