import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Duration badge widget displaying hours with gradient styling.
class BookingDurationBadge extends StatelessWidget {
  final int durationInHours;

  const BookingDurationBadge({super.key, required this.durationInHours});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final successColor = isDark ? AppColors.darkSuccess : AppColors.success;
    final successColorEnd = isDark
        ? const Color(0xFF4ADE80)
        : const Color(0xFF2ECC71);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: BookingConstants.itemSpacing,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [successColor, successColorEnd]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: successColor.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        context.l10n.durationHours(durationInHours),
        style: AppTextStyles.labelLarge.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.onSuccess,
        ),
      ),
    );
  }
}
