import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_details/booking_details_body.dart';

/// Page displaying detailed information about a specific booking.
///
/// Uses [PremiumCurvedHeader] and [EmptyStates] for premium styling.
class BookingDetailsPage extends StatelessWidget {
  final String bookingId;

  const BookingDetailsPage({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const PremiumCurvedHeader(
            title: BookingConstants.bookingDetailsTitle,
            showBackButton: true,
            height: 160,
          ),
          Expanded(child: BookingDetailsBody(bookingId: bookingId)),
        ],
      ),
    );
  }
}
