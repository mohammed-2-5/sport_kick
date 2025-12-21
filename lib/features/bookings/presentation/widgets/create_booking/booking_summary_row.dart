import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Individual summary row widget displaying label and value.
class BookingSummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const BookingSummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style:
              (isTotal ? AppTextStyles.titleMedium : AppTextStyles.bodyMedium)
                  .copyWith(
                    fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
        ),
        Text(
          value,
          style:
              (isTotal
                      ? AppTextStyles.headlineSmall
                      : AppTextStyles.titleMedium)
                  .copyWith(
                    fontSize: isTotal ? 18 : 16,
                    fontWeight: FontWeight.w700,
                    color: isTotal ? AppColors.primary : AppColors.textPrimary,
                  ),
        ),
      ],
    );
  }
}
