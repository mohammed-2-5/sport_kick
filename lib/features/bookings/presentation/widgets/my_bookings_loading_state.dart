import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/shimmer_loading.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';

/// Loading state widget for bookings list.
///
/// Displays shimmer loading effect with multiple placeholder cards.
class MyBookingsLoadingState extends StatelessWidget {
  final int itemCount;

  const MyBookingsLoadingState({
    super.key,
    this.itemCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(BookingConstants.standardPadding),
      itemCount: itemCount,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: BookingConstants.standardPadding),
        child: ShimmerLoading(
          child: Container(
            height: 140,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(BookingConstants.borderRadius),
            ),
          ),
        ),
      ),
    );
  }
}
