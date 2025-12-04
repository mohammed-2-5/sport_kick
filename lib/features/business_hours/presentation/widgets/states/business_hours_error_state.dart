import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/business_hours/presentation/constants/business_hours_constants.dart';
import 'package:spo_kick/features/business_hours/presentation/constants/business_hours_strings.dart';

/// Error state widget for business hours feature.
///
/// Displays an error icon, error message, and a retry button.
class BusinessHoursErrorState extends StatelessWidget {
  /// The error message to display
  final String message;

  /// Callback when retry button is pressed
  final VoidCallback onRetry;

  const BusinessHoursErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(BusinessHoursConstants.cardPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: BusinessHoursConstants.itemSpacing),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.error),
            ),
            const SizedBox(height: BusinessHoursConstants.sectionSpacing),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text(BusinessHoursStrings.retry),
            ),
          ],
        ),
      ),
    );
  }
}
