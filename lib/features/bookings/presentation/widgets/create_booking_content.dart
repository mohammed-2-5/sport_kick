import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_state.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_date_picker.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_field_header.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_summary_card.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking_time_slots_section.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';

class CreateBookingContent extends StatelessWidget {
  final FieldEntity field;
  final BookingState state;
  final DateTime selectedDate;
  final TimeSlotEntity? selectedTimeSlot;
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<TimeSlotEntity> onTimeSlotSelected;
  final VoidCallback onConfirm;

  const CreateBookingContent({
    required this.field,
    required this.state,
    required this.selectedDate,
    required this.selectedTimeSlot,
    required this.onDateSelected,
    required this.onTimeSlotSelected,
    required this.onConfirm,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BookingFieldHeader(field: field),
        const Divider(height: 1),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(BookingConstants.standardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BookingDatePicker(
                  selectedDate: selectedDate,
                  onDateSelected: onDateSelected,
                ),
                const SizedBox(height: BookingConstants.sectionSpacing),
                CreateBookingTimeSlotsSection(
                  state: state,
                  selectedTimeSlot: selectedTimeSlot,
                  selectedDate: selectedDate,
                  onTimeSlotSelected: onTimeSlotSelected,
                  onSelectDate: onDateSelected,
                ),
              ],
            ),
          ),
        ),
        if (selectedTimeSlot != null)
          BookingSummaryCard(
            selectedDate: selectedDate,
            selectedTimeSlot: selectedTimeSlot!,
            onConfirm: onConfirm,
          ),
      ],
    );
  }
}
