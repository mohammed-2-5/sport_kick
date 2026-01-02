import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/owner/presentation/constants/owner_ui_constants.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';

/// Step indicator widget for the manual booking flow.
///
/// Shows current step (1 or 2) with visual indicators.
/// Highlights the active step and dims completed/upcoming steps.
class StepIndicatorWidget extends StatelessWidget {
  /// Current active step (0 for Step 1, 1 for Step 2)
  final int currentStep;

  const StepIndicatorWidget({required this.currentStep, super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: OwnerUIConstants.spacingLarge,
        horizontal: OwnerUIConstants.spacingMedium,
      ),
      color: colorScheme.primary.withValues(alpha: 0.05),
      child: Row(
        children: [
          _buildStepCircle(
            context,
            1,
            context.l10n.bookingDetailsTitle,
            currentStep >= 0,
          ),
          Expanded(
            child: Container(
              height: 2,
              color: currentStep >= 1
                  ? colorScheme.primary
                  : colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          _buildStepCircle(
            context,
            2,
            context.l10n.customerInformation,
            currentStep >= 1,
          ),
        ],
      ),
    );
  }

  Widget _buildStepCircle(
    BuildContext context,
    int step,
    String label,
    bool isActive,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final activeColor = colorScheme.primary;
    final inactiveColor = colorScheme.outline.withValues(alpha: 0.3);
    final color = isActive ? activeColor : inactiveColor;

    return Column(
      children: [
        Container(
          width: OwnerUIConstants.stepCircleSize,
          height: OwnerUIConstants.stepCircleSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? color : colorScheme.surface,
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(
              LocaleFormatters.formatNumber(context, step),
              style: AppTextStyles.bodyLarge.copyWith(
                color: isActive ? colorScheme.onPrimary : color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: OwnerUIConstants.spacingXSmall),
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: isActive ? activeColor : colorScheme.onSurfaceVariant,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
