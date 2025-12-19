import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Premium step indicator for multi-step forms.
///
/// Features:
/// - Numbered steps
/// - Gradient active step
/// - Check mark for completed steps
/// - Connecting lines
class PremiumStepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> stepLabels;

  const PremiumStepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepLabels,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        final stepNumber = index + 1;
        final isActive = stepNumber == currentStep;
        final isCompleted = stepNumber < currentStep;
        final isLast = index == totalSteps - 1;

        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    // Step circle
                    _StepCircle(
                      stepNumber: stepNumber,
                      isActive: isActive,
                      isCompleted: isCompleted,
                    ),
                    const SizedBox(height: 8),
                    // Label
                    Text(
                      stepLabels[index],
                      style: AppTextStyles.labelSmall.copyWith(
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: isActive || isCompleted
                            ? AppColors.accentCyan
                            : AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              // Connecting line
              if (!isLast)
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.only(bottom: 28),
                    color: isCompleted
                        ? AppColors.accentCyan
                        : AppColors.border,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}

/// Step circle widget.
class _StepCircle extends StatelessWidget {
  final int stepNumber;
  final bool isActive;
  final bool isCompleted;

  const _StepCircle({
    required this.stepNumber,
    required this.isActive,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: isActive || isCompleted
            ? const LinearGradient(
                colors: [AppColors.accentCyan, AppColors.accentCyanDark],
              )
            : null,
        color: isActive || isCompleted ? null : AppColors.border,
        shape: BoxShape.circle,
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.accentCyan.withValues(alpha: 0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Center(
        child: isCompleted
            ? const Icon(Icons.check, size: 20, color: Colors.white)
            : Text(
                '$stepNumber',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isActive || isCompleted
                      ? Colors.white
                      : AppColors.textSecondary,
                ),
              ),
      ),
    );
  }
}
