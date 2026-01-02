import 'package:flutter/material.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_details/booking_cancellation_card.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_details/booking_date_time_info_card.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_details/booking_field_image.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_details/booking_id_card.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_details/booking_price_card.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_details/booking_review_section.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_details/booking_status_banner.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_details/booking_timeline_card.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_details/booking_user_notes_card.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Main content widget for booking details page.
///
/// Displays all booking information using premium styled components.
class BookingDetailsContent extends StatelessWidget {
  final BookingEntity booking;

  const BookingDetailsContent({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Field Image (if available)
          if (booking.fieldImage != null)
            BookingFieldImage(imageUrl: booking.fieldImage!),

          // Status Banner
          BookingStatusBanner(status: booking.status),

          // Content Section
          Padding(
            padding: const EdgeInsets.all(BookingConstants.standardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Field Name
                if (booking.fieldName != null) ...[
                  Text(
                    booking.fieldName!,
                    style: AppTextStyles.headlineSmall.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.onSurface,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: BookingConstants.largePadding),
                ],

                // Booking ID
                BookingIdCard(bookingId: booking.id),
                const SizedBox(height: BookingConstants.standardPadding),

                // Date & Time
                BookingDateTimeInfoCard(booking: booking),
                const SizedBox(height: BookingConstants.standardPadding),

                // Price Breakdown
                BookingPriceCard(booking: booking),
                const SizedBox(height: BookingConstants.standardPadding),

                // Timeline
                BookingTimelineCard(booking: booking),

                // Notes (if any)
                if (booking.notes != null && booking.notes!.isNotEmpty) ...[
                  const SizedBox(height: BookingConstants.standardPadding),
                  BookingUserNotesCard(notes: booking.notes!),
                ],

                // Cancellation Reason (if canceled)
                if (booking.status == BookingStatus.canceled &&
                    booking.cancellationReason != null) ...[
                  const SizedBox(height: BookingConstants.standardPadding),
                  BookingCancellationCard(reason: booking.cancellationReason!),
                ],

                // Review Section (for completed/verified bookings)
                const SizedBox(height: BookingConstants.standardPadding),
                BookingReviewSection(booking: booking),

                // Bottom spacing for floating actions
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
