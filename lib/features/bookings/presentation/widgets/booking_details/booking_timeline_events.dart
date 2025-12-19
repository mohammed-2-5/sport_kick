import 'package:flutter/material.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/bookings/presentation/utils/booking_status_utils.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_details/booking_timeline_item.dart';

/// Widget that builds timeline events for a booking.
class BookingTimelineEvents extends StatelessWidget {
  final BookingEntity booking;

  const BookingTimelineEvents({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final hasConfirmed = booking.confirmedAt != null;
    final hasCanceled = booking.canceledAt != null;
    final l10n = context.l10n;

    return Column(
      children: [
        // Created event
        BookingTimelineItem(
          icon: Icons.add_circle_outline,
          title: l10n.bookingCreated,
          time: BookingStatusUtils.formatDateTime(booking.createdAt),
          showConnector: hasConfirmed || hasCanceled,
        ),

        // Confirmed event
        if (hasConfirmed)
          BookingTimelineItem(
            icon: Icons.check_circle_outline,
            title: l10n.statusConfirmed,
            time: BookingStatusUtils.formatDateTime(booking.confirmedAt!),
            showConnector: hasCanceled,
          ),

        // Canceled event
        if (hasCanceled)
          BookingTimelineItem(
            icon: Icons.cancel_outlined,
            title: l10n.statusCancelled,
            time: BookingStatusUtils.formatDateTime(booking.canceledAt!),
            isError: true,
            showConnector: false,
          ),
      ],
    );
  }
}
