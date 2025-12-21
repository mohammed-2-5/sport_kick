import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_shadows.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Indoor/Outdoor field toggle switch.
///
/// Allows user to specify whether the field is indoor or outdoor.
class FieldIndoorSwitch extends StatelessWidget {
  /// Current indoor value
  final bool value;

  /// Callback when value changes
  final ValueChanged<bool> onChanged;

  const FieldIndoorSwitch({
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: AppShadows.small,
      ),
      child: Row(
        children: [
          const Icon(Icons.roofing_rounded, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              context.l10n.indoorField,
              style: AppTextStyles.labelLarge.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            trackColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.primary;
              }
              return null;
            }),
            thumbColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.white;
              }
              return null;
            }),
          ),
        ],
      ),
    );
  }
}
