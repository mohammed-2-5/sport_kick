import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_animations.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_flow_state.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Premium step indicator for the booking wizard.
///
/// Displays a horizontal progress indicator with step labels,
/// animated transitions, and tap-to-navigate functionality.
class BookingStepIndicator extends StatelessWidget {
  final BookingFlowStep currentStep;
  final ValueChanged<BookingFlowStep>? onStepTapped;

  const BookingStepIndicator({
    super.key,
    required this.currentStep,
    this.onStepTapped,
  });

  static const _steps = [
    BookingFlowStep.selectDate,
    BookingFlowStep.selectTime,
    BookingFlowStep.confirm,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: List.generate(_steps.length * 2 - 1, (index) {
          if (index.isOdd) {
            // Connector line
            final stepIndex = index ~/ 2;
            final isCompleted = currentStep.index > stepIndex;
            return Expanded(child: _StepConnector(isCompleted: isCompleted));
          } else {
            // Step circle
            final stepIndex = index ~/ 2;
            final step = _steps[stepIndex];
            final isActive = currentStep == step;
            final isCompleted = currentStep.index > stepIndex;

            return _StepCircle(
              step: step,
              stepNumber: stepIndex + 1,
              isActive: isActive,
              isCompleted: isCompleted,
              onTap: isCompleted ? () => onStepTapped?.call(step) : null,
            );
          }
        }),
      ),
    );
  }
}

/// Individual step circle with number and animation.
class _StepCircle extends StatefulWidget {
  final BookingFlowStep step;
  final int stepNumber;
  final bool isActive;
  final bool isCompleted;
  final VoidCallback? onTap;

  const _StepCircle({
    required this.step,
    required this.stepNumber,
    required this.isActive,
    required this.isCompleted,
    this.onTap,
  });

  @override
  State<_StepCircle> createState() => _StepCircleState();
}

class _StepCircleState extends State<_StepCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.slow,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.isActive) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(_StepCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _controller.repeat(reverse: true);
    } else if (!widget.isActive && oldWidget.isActive) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: widget.isActive ? _scaleAnimation.value : 1.0,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getBackgroundColor(),
                    border: Border.all(
                      color: _getBorderColor(),
                      width: widget.isActive ? 2.5 : 2,
                    ),
                    boxShadow: widget.isActive
                        ? [
                            BoxShadow(
                              color: AppColors.accentCyan.withValues(
                                alpha: 0.4 * _glowAnimation.value,
                              ),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: Center(child: _buildContent()),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          Text(
            widget.step.title(context.l10n),
            style: AppTextStyles.labelSmall.copyWith(
              fontSize: 11,
              fontWeight: widget.isActive ? FontWeight.w700 : FontWeight.w500,
              color: widget.isActive || widget.isCompleted
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (widget.isCompleted) {
      return const Icon(Icons.check, color: Colors.white, size: 20);
    }

    return Text(
      '${widget.stepNumber}',
      style: AppTextStyles.titleMedium.copyWith(
        fontWeight: FontWeight.w700,
        color: widget.isActive ? Colors.white : AppColors.textSecondary,
      ),
    );
  }

  Color _getBackgroundColor() {
    if (widget.isCompleted) return AppColors.success;
    if (widget.isActive) return AppColors.accentCyan;
    return Colors.white;
  }

  Color _getBorderColor() {
    if (widget.isCompleted) return AppColors.success;
    if (widget.isActive) return AppColors.accentCyan;
    return AppColors.border;
  }
}

/// Connector line between step circles.
class _StepConnector extends StatelessWidget {
  final bool isCompleted;

  const _StepConnector({required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1.5),
        gradient: isCompleted
            ? const LinearGradient(
                colors: [AppColors.success, AppColors.accentCyan],
              )
            : null,
        color: isCompleted ? null : AppColors.border,
      ),
    );
  }
}
