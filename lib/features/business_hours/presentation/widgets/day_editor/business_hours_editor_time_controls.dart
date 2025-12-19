import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/business_hours/presentation/constants/business_hours_constants.dart';
import 'package:spo_kick/features/business_hours/presentation/widgets/business_hours_time_picker.dart';
import 'package:spo_kick/features/business_hours/presentation/widgets/day_editor/business_hours_editor_help_text.dart';

/// Time controls widget for business hours editor.
///
/// Displays opening and closing time pickers with help text.
class BusinessHoursEditorTimeControls extends StatelessWidget {
  /// Current opening time (HH:MM:SS format)
  final String openingTime;

  /// Current closing time (HH:MM:SS format)
  final String closingTime;

  /// Callback when opening time changes
  final ValueChanged<String> onOpeningTimeChanged;

  /// Callback when closing time changes
  final ValueChanged<String> onClosingTimeChanged;

  /// Whether the controls are enabled
  final bool enabled;

  const BusinessHoursEditorTimeControls({
    super.key,
    required this.openingTime,
    required this.closingTime,
    required this.onOpeningTimeChanged,
    required this.onClosingTimeChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Opening time picker
        BusinessHoursTimePicker(
          label: context.l10n.businessHoursOpeningTime,
          selectedTime: openingTime,
          onTimeChanged: onOpeningTimeChanged,
          isOpeningTime: true,
          enabled: enabled,
        ),

        const SizedBox(height: BusinessHoursConstants.itemSpacing),

        // Closing time picker
        BusinessHoursTimePicker(
          label: context.l10n.businessHoursClosingTime,
          selectedTime: closingTime,
          onTimeChanged: onClosingTimeChanged,
          isOpeningTime: false,
          minTime: openingTime,
          enabled: enabled,
        ),

        const SizedBox(height: BusinessHoursConstants.smallSpacing),

        // Help text
        const BusinessHoursEditorHelpText(),
      ],
    );
  }
}
