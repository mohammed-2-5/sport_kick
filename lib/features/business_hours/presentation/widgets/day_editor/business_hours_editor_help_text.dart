import 'package:flutter/material.dart';
import 'package:spo_kick/features/business_hours/presentation/constants/business_hours_constants.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Help text widget for business hours editor.
///
/// Displays informational text about time selection.
class BusinessHoursEditorHelpText extends StatelessWidget {
  const BusinessHoursEditorHelpText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(Icons.info_outline, size: 16, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: BusinessHoursConstants.tinySpacing),
        Expanded(
          child: Text(
            context.l10n.businessHoursHelpTimeSelection,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}
