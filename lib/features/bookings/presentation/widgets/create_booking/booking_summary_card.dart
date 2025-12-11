import 'package:flutter/material.dart';
import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/booking_confirm_button.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/booking_summary_details.dart';

/// Booking summary card shown at the bottom of create booking page.
///
/// Displays:
/// - Selected date
/// - Selected time slot
/// - Total price
/// - Confirm booking button
class BookingSummaryCard extends StatelessWidget {
  final DateTime selectedDate;
  final TimeSlotEntity selectedTimeSlot;
  final VoidCallback onConfirm;

  const BookingSummaryCard({
    super.key,
    required this.selectedDate,
    required this.selectedTimeSlot,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(BookingConstants.standardPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BookingSummaryDetails(
                selectedDate: selectedDate,
                selectedTimeSlot: selectedTimeSlot,
              ),
              const SizedBox(height: BookingConstants.standardPadding),
              BookingConfirmButton(onConfirm: onConfirm),
            ],
          ),
        ),
      ),
    );
  }
}
