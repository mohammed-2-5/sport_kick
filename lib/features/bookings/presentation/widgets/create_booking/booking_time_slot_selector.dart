import 'package:flutter/material.dart';
import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/time_slot_loading_state.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/time_slots_content.dart';

/// Time slot selector widget for booking flow.
///
/// Displays available time slots organized by period (Morning, Afternoon, Evening)
/// and allows users to select a time slot.
class BookingTimeSlotSelector extends StatelessWidget {
  final Map<String, List<TimeSlotEntity>> slotsByPeriod;
  final TimeSlotEntity? selectedTimeSlot;
  final ValueChanged<TimeSlotEntity> onTimeSlotSelected;
  final bool isLoading;

  const BookingTimeSlotSelector({
    super.key,
    required this.slotsByPeriod,
    required this.selectedTimeSlot,
    required this.onTimeSlotSelected,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const TimeSlotLoadingState();
    }

    return TimeSlotsContent(
      slotsByPeriod: slotsByPeriod,
      selectedTimeSlot: selectedTimeSlot,
      onTimeSlotSelected: onTimeSlotSelected,
    );
  }
}
