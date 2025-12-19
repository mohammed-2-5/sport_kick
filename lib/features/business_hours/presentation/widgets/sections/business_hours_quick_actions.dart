import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/business_hours/presentation/constants/business_hours_constants.dart';

/// Quick actions widget for business hours management.
///
/// Provides buttons for bulk operations like setting default hours
/// and applying hours to all days.
class BusinessHoursQuickActions extends StatelessWidget {
  /// Callback when "Set Default Hours" is pressed
  final VoidCallback onSetDefaultHours;

  /// Callback when "Apply to All Days" is pressed
  final VoidCallback onApplyToAllDays;

  const BusinessHoursQuickActions({
    super.key,
    required this.onSetDefaultHours,
    required this.onApplyToAllDays,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: BusinessHoursConstants.itemSpacing,
      runSpacing: BusinessHoursConstants.smallSpacing,
      children: [
        OutlinedButton.icon(
          onPressed: onSetDefaultHours,
          icon: const Icon(Icons.restore),
          label: Text(context.l10n.businessHoursSetDefaultHours),
        ),
        OutlinedButton.icon(
          onPressed: onApplyToAllDays,
          icon: const Icon(Icons.copy_all),
          label: Text(context.l10n.businessHoursApplyToAllDays),
        ),
      ],
    );
  }
}
