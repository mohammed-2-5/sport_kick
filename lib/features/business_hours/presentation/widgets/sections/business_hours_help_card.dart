import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/business_hours/presentation/constants/business_hours_constants.dart';
import 'package:spo_kick/features/business_hours/presentation/constants/business_hours_strings.dart';

/// Help card widget providing information about business hours feature.
///
/// Displays an informational message explaining how to use the
/// business hours management feature.
class BusinessHoursHelpCard extends StatelessWidget {
  const BusinessHoursHelpCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primary.withValues(alpha: 0.05),
      child: const Padding(
        padding: EdgeInsets.all(BusinessHoursConstants.cardPadding),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: AppColors.primary),
            SizedBox(width: BusinessHoursConstants.itemSpacing),
            Expanded(
              child: Text(
                BusinessHoursStrings.helpText,
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
