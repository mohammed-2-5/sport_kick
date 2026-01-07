import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Cancellation reason display widget.
class BookingListItemCancellationReason extends StatelessWidget {
  final String reason;

  const BookingListItemCancellationReason({super.key, required this.reason});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final errorColor = isDark ? AppColors.darkError : AppColors.error;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: errorColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: errorColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(Icons.info_outline, size: 16, color: errorColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              reason,
              style: AppTextStyles.bodySmall.copyWith(
                color: errorColor,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
