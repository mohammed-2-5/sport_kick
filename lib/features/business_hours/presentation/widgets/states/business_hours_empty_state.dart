import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/business_hours/presentation/constants/business_hours_constants.dart';

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
            Text(
              context.l10n.businessHoursNoHoursSet,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: BusinessHoursConstants.smallSpacing),
            Text(
              context.l10n.businessHoursNoHoursSetDescription,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: BusinessHoursConstants.sectionSpacing),
            FilledButton.icon(
              onPressed: onInitializeDefaultHours,
              icon: const Icon(Icons.add),
              label: Text(context.l10n.businessHoursSetDefaultHours),
            ),
          ],
        ),
      ),
    );
  }
}
