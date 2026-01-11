import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/owner/presentation/models/time_slot_ui_model.dart';

/// Premium time slot grid selector.
///
/// Features:
/// - Grid of time slots
/// - Gradient selected state
/// - Available/Booked/Selected states
/// - Tap animation
class PremiumTimeSlotGrid extends StatelessWidget {
  final List<TimeSlotUiModel> timeSlots;
  final String? selectedSlotId;
  final ValueChanged<String> onSlotSelected;

  const PremiumTimeSlotGrid({
    super.key,
    required this.timeSlots,
    this.selectedSlotId,
    required this.onSlotSelected,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 4 : 3;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.2,
      ),
      itemCount: timeSlots.length,
      itemBuilder: (context, index) {
        final slot = timeSlots[index];
        return _TimeSlotUiModelChip(
          slot: slot,
          isSelected: slot.id == selectedSlotId,
          onTap: slot.isAvailable
              ? () {
                  HapticFeedback.selectionClick();
                  onSlotSelected(slot.id);
                }
              : null,
        );
      },
    );
  }
}

/// Individual time slot chip.
class _TimeSlotUiModelChip extends StatefulWidget {
  final TimeSlotUiModel slot;
  final bool isSelected;
  final VoidCallback? onTap;

  const _TimeSlotUiModelChip({
    required this.slot,
    required this.isSelected,
    this.onTap,
  });

  @override
  State<_TimeSlotUiModelChip> createState() => _TimeSlotUiModelChipState();
}

class _TimeSlotUiModelChipState extends State<_TimeSlotUiModelChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.slot.isAvailable;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTapDown: isEnabled ? (_) => _controller.forward() : null,
      onTapUp: isEnabled
          ? (_) {
              _controller.reverse();
              widget.onTap?.call();
            }
          : null,
      onTapCancel: isEnabled ? () => _controller.reverse() : null,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            gradient: widget.isSelected
                ? LinearGradient(
                    colors: [
                      colorScheme.secondary,
                      colorScheme.secondaryContainer,
                    ],
                  )
                : null,
            color: widget.isSelected
                ? null
                : isEnabled
                ? colorScheme.surface
                : colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isSelected
                  ? Colors.transparent
                  : isEnabled
                  ? colorScheme.outlineVariant
                  : colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: colorScheme.secondary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              widget.slot.displayTime,
              style: AppTextStyles.labelSmall.copyWith(
                fontWeight: FontWeight.w600,
                color: widget.isSelected
                    ? colorScheme.onSecondary
                    : isEnabled
                    ? colorScheme.onSurface
                    : colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
