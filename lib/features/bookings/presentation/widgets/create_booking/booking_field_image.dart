import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';

/// Field image widget for booking header.
class BookingFieldImage extends StatelessWidget {
  final List<String> images;

  const BookingFieldImage({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(BookingConstants.smallPadding),
      child: images.isNotEmpty
          ? Image.network(
              images.first,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const _BookingFieldPlaceholder(),
            )
          : const _BookingFieldPlaceholder(),
    );
  }
}

/// Placeholder widget for field image.
class _BookingFieldPlaceholder extends StatelessWidget {
  const _BookingFieldPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      color: AppColors.border,
      child: const Icon(Icons.sports_soccer),
    );
  }
}
