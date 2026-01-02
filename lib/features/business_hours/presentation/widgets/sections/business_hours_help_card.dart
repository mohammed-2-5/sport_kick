import 'package:flutter/material.dart';
import 'package:spo_kick/features/business_hours/presentation/constants/business_hours_constants.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Help card widget providing information about business hours feature.
///
/// Displays an informational message explaining how to use the
/// business hours management feature.
class BusinessHoursHelpCard extends StatelessWidget {
  const BusinessHoursHelpCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.primaryContainer.withValues(alpha: 0.3),
      child: Padding(
        padding: const EdgeInsets.all(BusinessHoursConstants.cardPadding),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: colorScheme.primary),
            const SizedBox(width: BusinessHoursConstants.itemSpacing),
            Expanded(
              child: Text(
                context.l10n.businessHoursHelpText,
                style: TextStyle(fontSize: 14, color: colorScheme.onSurface),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
