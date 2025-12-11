import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Row widget displaying price label and value.
class BookingPriceRow extends StatelessWidget {
  final String label;
  final String value;

  const BookingPriceRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
