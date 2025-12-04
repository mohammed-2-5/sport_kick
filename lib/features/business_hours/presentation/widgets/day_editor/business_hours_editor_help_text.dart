import 'package:flutter/material.dart';
import 'package:spo_kick/features/business_hours/presentation/constants/business_hours_constants.dart';
import 'package:spo_kick/features/business_hours/presentation/constants/business_hours_strings.dart';

/// Help text widget for business hours editor.
///
/// Displays informational text about time selection.
class BusinessHoursEditorHelpText extends StatelessWidget {
  const BusinessHoursEditorHelpText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
        const SizedBox(width: BusinessHoursConstants.tinySpacing),
        Expanded(
          child: Text(
            BusinessHoursStrings.helpTimeSelection,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}
