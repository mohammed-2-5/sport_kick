import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_gradients.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Price display widget for field card.
///
/// Shows the formatted price with gradient background and shadow effect.
class FieldCardPrice extends StatelessWidget {
  /// The formatted price string (e.g., "$50/hour")
  final String formattedPrice;

  const FieldCardPrice({super.key, required this.formattedPrice});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: AppGradients.primary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        formattedPrice,
        style: AppTextStyles.titleMedium.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
