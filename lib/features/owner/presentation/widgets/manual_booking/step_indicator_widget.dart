import 'package:flutter/material.dart';
import 'package:spo_kick/features/owner/presentation/constants/owner_ui_constants.dart';

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
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: OwnerUIConstants.spacingLarge,
        horizontal: OwnerUIConstants.spacingMedium,
      ),
      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
      child: Row(
        children: [
          _buildStepCircle(context, 1, 'Booking Details', currentStep >= 0),
          Expanded(
            child: Container(
              height: 2,
              color: currentStep >= 1
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey[300],
            ),
          ),
          _buildStepCircle(context, 2, 'Customer Info', currentStep >= 1),
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
    final color = isActive
        ? Theme.of(context).colorScheme.primary
        : Colors.grey[300]!;

    return Column(
      children: [
        Container(
          width: OwnerUIConstants.stepCircleSize,
          height: OwnerUIConstants.stepCircleSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? color : Colors.white,
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(
              step.toString(),
              style: TextStyle(
                color: isActive ? Colors.white : color,
                fontWeight: FontWeight.bold,
                fontSize: OwnerUIConstants.fontSizeLarge,
              ),
            ),
          ),
        ),
        const SizedBox(height: OwnerUIConstants.spacingXSmall),
        Text(
          label,
          style: TextStyle(
            fontSize: OwnerUIConstants.fontSizeSmall,
            color: isActive ? color : Colors.grey[600],
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
