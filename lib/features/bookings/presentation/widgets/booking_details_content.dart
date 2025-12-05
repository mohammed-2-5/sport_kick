import 'package:flutter/material.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_details_actions.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_details_header.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_details_info_section.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_details_timeline.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_notes_card.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_price_breakdown.dart';

class BookingDetailsContent extends StatelessWidget {
  final BookingEntity booking;

  const BookingDetailsContent({required this.booking, super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BookingDetailsHeader(booking: booking),
          Padding(
            padding: const EdgeInsets.all(BookingConstants.standardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BookingDetailsInfoSection(booking: booking),
                const SizedBox(height: BookingConstants.standardPadding),
                BookingPriceBreakdown(booking: booking),
                const SizedBox(height: BookingConstants.standardPadding),
                BookingDetailsTimeline(booking: booking),
                if ((booking.notes != null && booking.notes!.isNotEmpty) ||
                    (booking.status == BookingStatus.canceled &&
                        booking.cancellationReason != null)) ...[
                  const SizedBox(height: BookingConstants.standardPadding),
                  BookingNotesCard(
                    notes: booking.notes,
                    cancellationReason: booking.status == BookingStatus.canceled
                        ? booking.cancellationReason
                        : null,
                  ),
                ],
                const SizedBox(height: BookingConstants.largePadding),
                BookingDetailsActions(booking: booking),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
