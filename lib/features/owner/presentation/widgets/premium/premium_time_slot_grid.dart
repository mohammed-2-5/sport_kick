import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Premium time slot grid selector.
///
/// Features:
/// - Grid of time slots
/// - Gradient selected state
/// - Available/Booked/Selected states
/// - Tap animation
class PremiumTimeSlotGrid extends StatelessWidget {
  final List<TimeSlot> timeSlots;
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
        return _TimeSlotChip(
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

/// Time slot data model.
class TimeSlot {
  final String id;
  final String startTime;
  final String endTime;
  final bool isAvailable;

  const TimeSlot({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
  });

  String get displayTime => '$startTime-$endTime';
}

/// Individual time slot chip.
class _TimeSlotChip extends StatefulWidget {
  final TimeSlot slot;
  final bool isSelected;
  final VoidCallback? onTap;

  const _TimeSlotChip({
    required this.slot,
    required this.isSelected,
    this.onTap,
  });

  @override
  State<_TimeSlotChip> createState() => _TimeSlotChipState();
}

class _TimeSlotChipState extends State<_TimeSlotChip>
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
                ? const LinearGradient(
                    colors: [AppColors.accentCyan, AppColors.accentCyanDark],
                  )
                : null,
            color: widget.isSelected
                ? null
                : isEnabled
                ? Colors.white
                : AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isSelected
                  ? Colors.transparent
                  : isEnabled
                  ? AppColors.border
                  : AppColors.border.withValues(alpha: 0.3),
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: AppColors.accentCyan.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              widget.slot.displayTime,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: widget.isSelected
                    ? Colors.white
                    : isEnabled
                    ? AppColors.textPrimary
                    : AppColors.textSecondary.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
