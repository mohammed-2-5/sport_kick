import 'package:flutter/material.dart';
import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_state.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/shared/booking_empty_state.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/booking_time_slot_selector.dart';

class CreateBookingTimeSlotsSection extends StatelessWidget {
  final BookingState state;
  final TimeSlotEntity? selectedTimeSlot;
  final DateTime selectedDate;
  final ValueChanged<TimeSlotEntity> onTimeSlotSelected;
  final ValueChanged<DateTime> onSelectDate;

  const CreateBookingTimeSlotsSection({
    required this.state,
    required this.selectedTimeSlot,
    required this.selectedDate,
    required this.onTimeSlotSelected,
    required this.onSelectDate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bookingState = state;

    if (bookingState is BookingLoading) {
      return BookingTimeSlotSelector(
        slotsByPeriod: const {},
        selectedTimeSlot: selectedTimeSlot,
        onTimeSlotSelected: onTimeSlotSelected,
        isLoading: true,
      );
    } else if (bookingState is TimeSlotsLoaded) {
      if (!bookingState.hasAvailableSlots) {
        return BookingEmptyState(
          message: BookingConstants.noAvailableSlotsMessage,
          onSelectDatePressed: () => onSelectDate(selectedDate),
        );
      }
      return BookingTimeSlotSelector(
        slotsByPeriod: bookingState.slotsByPeriod,
        selectedTimeSlot: selectedTimeSlot,
        onTimeSlotSelected: onTimeSlotSelected,
      );
    } else if (bookingState is BookingsEmpty) {
      return BookingEmptyState(
        message:
            bookingState.message ?? BookingConstants.noAvailableSlotsMessage,
        onSelectDatePressed: () => onSelectDate(selectedDate),
      );
    }
    return const SizedBox.shrink();
  }
}
