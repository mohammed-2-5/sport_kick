import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
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
            label: context.l10n.bookingDate,
            value: LocaleFormatters.formatDate(context, selectedDate),
          ),
          const Divider(height: BookingConstants.standardPadding),
          BookingSummaryRow(
            label: context.l10n.bookingTime,
            value: LocaleFormatters.formatTimeRange(
              context,
              startTime: selectedTimeSlot.startTime,
              endTime: selectedTimeSlot.endTime,
              isEndNextDay: selectedTimeSlot.isNextDay,
              baseDate: selectedDate,
            ),
          ),
          const Divider(height: BookingConstants.standardPadding),
          BookingSummaryRow(
            label: context.l10n.totalPrice,
            value: LocaleFormatters.formatPrice(
              context,
              amount: selectedTimeSlot.price,
              currency: selectedTimeSlot.currency,
              decimalDigits: 0,
            ),
            isTotal: true,
          ),
        ],
      ),
    );
  }
}
