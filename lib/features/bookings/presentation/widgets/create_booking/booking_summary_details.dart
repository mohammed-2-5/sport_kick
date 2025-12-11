import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/booking_summary_row.dart';

/// Summary details container widget.
class BookingSummaryDetails extends StatelessWidget {
  final DateTime selectedDate;
  final TimeSlotEntity selectedTimeSlot;

  const BookingSummaryDetails({
    super.key,
    required this.selectedDate,
    required this.selectedTimeSlot,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(BookingConstants.standardPadding),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(BookingConstants.borderRadius),
      ),
      child: Column(
        children: [
          BookingSummaryRow(
            label: BookingConstants.dateLabel,
            value: DateFormat('MMM d, yyyy').format(selectedDate),
          ),
          const Divider(height: BookingConstants.standardPadding),
          BookingSummaryRow(
            label: BookingConstants.timeLabel,
            value: selectedTimeSlot.formattedTimeRange,
          ),
          const Divider(height: BookingConstants.standardPadding),
          BookingSummaryRow(
            label: BookingConstants.totalLabel,
            value: selectedTimeSlot.formattedPrice,
            isTotal: true,
          ),
        ],
      ),
    );
  }
}
