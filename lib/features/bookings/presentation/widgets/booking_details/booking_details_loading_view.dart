import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/shimmer_loading.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';

class BookingDetailsLoadingView extends StatelessWidget {
  const BookingDetailsLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShimmerLoading(
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: BookingConstants.standardPadding,
              ),
              height: 400,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(
                  BookingConstants.borderRadius,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
