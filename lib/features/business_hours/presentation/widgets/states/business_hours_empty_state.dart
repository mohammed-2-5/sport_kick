import 'package:flutter/material.dart';
import 'package:spo_kick/features/business_hours/presentation/constants/business_hours_constants.dart';
import 'package:spo_kick/features/business_hours/presentation/constants/business_hours_strings.dart';

/// Empty state widget for business hours feature.
///
/// Displayed when no business hours have been set for a field yet.
/// Shows an icon, message, and a button to initialize default hours.
class BusinessHoursEmptyState extends StatelessWidget {
  /// Callback when initialize default hours button is pressed
  final VoidCallback onInitializeDefaultHours;

  const BusinessHoursEmptyState({
    super.key,
    required this.onInitializeDefaultHours,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(BusinessHoursConstants.cardPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.schedule, size: 64, color: Colors.grey[400]),
            const SizedBox(height: BusinessHoursConstants.itemSpacing),
            const Text(
              BusinessHoursStrings.noHoursSet,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: BusinessHoursConstants.smallSpacing),
            const Text(
              BusinessHoursStrings.noHoursSetDescription,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: BusinessHoursConstants.sectionSpacing),
            FilledButton.icon(
              onPressed: onInitializeDefaultHours,
              icon: const Icon(Icons.add),
              label: const Text(BusinessHoursStrings.setDefaultHours),
            ),
          ],
        ),
      ),
    );
  }
}
