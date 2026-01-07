import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_animations.dart';
import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/premium/time_slot_status_display.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/premium/time_slot_time_display.dart';

/// Premium time slot card with selection animation.
///
/// Features:
/// - Tap animation with scale effect
/// - Selected state with gradient and glow
/// - Second slot highlight for 2-hour bookings
/// - Disabled state for slots that can't accommodate duration
/// - Next day badge for after-midnight slots
class PremiumTimeSlotCard extends StatefulWidget {
  final TimeSlotEntity slot;
  final bool isSelected;
  final bool isSecondSlot;
  final bool isDisabledForDuration;
  final VoidCallback? onTap;

  const PremiumTimeSlotCard({
    super.key,
    required this.slot,
    required this.isSelected,
    this.isSecondSlot = false,
    this.isDisabledForDuration = false,
    this.onTap,
  });

  @override
  State<PremiumTimeSlotCard> createState() => _PremiumTimeSlotCardState();
}

class _PremiumTimeSlotCardState extends State<PremiumTimeSlotCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.fast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: AppAnimations.buttonPressScale,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isAvailable =>
      widget.slot.isAvailable && !widget.isDisabledForDuration;
  bool get _showAsSelected => widget.isSelected || widget.isSecondSlot;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _isAvailable ? (_) => _controller.forward() : null,
      onTapUp: _isAvailable ? (_) => _controller.reverse() : null,
      onTapCancel: _isAvailable ? () => _controller.reverse() : null,
      onTap: _isAvailable
          ? () {
              HapticFeedback.selectionClick();
              widget.onTap?.call();
            }
          : null,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: AnimatedContainer(
          duration: AppAnimations.fast,
          width: 110,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: _buildDecoration(context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TimeSlotTimeDisplay(
                slot: widget.slot,
                isSelected: _showAsSelected,
                isAvailable: _isAvailable,
              ),
              const SizedBox(height: 6),
              TimeSlotStatusDisplay(
                slot: widget.slot,
                isSelected: _showAsSelected,
                isAvailable: _isAvailable,
                isDisabledForDuration: widget.isDisabledForDuration,
              ),
              if (_showAsSelected) ...[
                const SizedBox(height: 6),
                Icon(
                  widget.isSecondSlot ? Icons.link : Icons.check_circle,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 18,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_showAsSelected) {
      return BoxDecoration(
        gradient: widget.isSecondSlot
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorScheme.primary.withValues(alpha: 0.8),
                  colorScheme.primaryContainer.withValues(alpha: 0.8),
                ],
              )
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [colorScheme.primary, colorScheme.primaryContainer],
              ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      );
    }

    if (!_isAvailable) {
      return BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outlineVariant),
      );
    }

    return BoxDecoration(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: colorScheme.outline),
      boxShadow: [
        BoxShadow(
          color: colorScheme.shadow.withValues(alpha: isDark ? 0.2 : 0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}
