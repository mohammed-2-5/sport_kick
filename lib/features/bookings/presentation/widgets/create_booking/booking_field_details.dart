import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Field details widget for booking header.
class BookingFieldDetails extends StatelessWidget {
  final String name;
  final String city;
  final String formattedPrice;

  const BookingFieldDetails({
    super.key,
    required this.name,
    required this.city,
    required this.formattedPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          city,
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 4),
        Text(
          '${context.l10n.pricePerHour}: $formattedPrice',
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
