import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_animations.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';

/// Premium time slot card with selection animation.
///
/// Features:
/// - Tap animation with scale effect
/// - Selected state with gradient and glow
/// - Unavailable state with visual indication
/// - Price display
class PremiumTimeSlotCard extends StatefulWidget {
  final TimeSlotEntity slot;
  final bool isSelected;
  final VoidCallback? onTap;

  const PremiumTimeSlotCard({
    super.key,
    required this.slot,
    required this.isSelected,
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

  @override
  Widget build(BuildContext context) {
    final isAvailable = widget.slot.isAvailable;

    return GestureDetector(
      onTapDown: isAvailable ? (_) => _controller.forward() : null,
      onTapUp: isAvailable ? (_) => _controller.reverse() : null,
      onTapCancel: isAvailable ? () => _controller.reverse() : null,
      onTap: () {
        if (isAvailable) {
          HapticFeedback.selectionClick();
          widget.onTap?.call();
        }
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: AnimatedContainer(
          duration: AppAnimations.fast,
          width: 110,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            gradient: widget.isSelected
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.accentCyan, AppColors.accentCyanDark],
                  )
                : null,
            color: widget.isSelected
                ? null
                : isAvailable
                ? Colors.white
                : AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(14),
            border: widget.isSelected
                ? null
                : Border.all(
                    color: isAvailable ? AppColors.border : AppColors.lightGrey,
                    width: 1,
                  ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: AppColors.accentCyan.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : isAvailable
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Time Range
              Text(
                widget.slot.formattedTimeRange,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: widget.isSelected
                      ? Colors.white
                      : isAvailable
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              // Price or Status
              if (isAvailable)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: widget.isSelected
                        ? Colors.white.withValues(alpha: 0.2)
                        : AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.slot.formattedPrice,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: widget.isSelected
                          ? Colors.white
                          : AppColors.success,
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.block, size: 12, color: AppColors.error),
                      SizedBox(width: 4),
                      Text(
                        'Booked',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ),
              // Selected checkmark
              if (widget.isSelected) ...[
                const SizedBox(height: 6),
                const Icon(Icons.check_circle, color: Colors.white, size: 18),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
