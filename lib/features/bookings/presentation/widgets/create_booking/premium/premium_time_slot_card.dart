import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_animations.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/next_day_badge.dart';

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
          decoration: _buildDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _TimeDisplay(
                slot: widget.slot,
                isSelected: _showAsSelected,
                isAvailable: _isAvailable,
              ),
              const SizedBox(height: 6),
              _StatusDisplay(
                slot: widget.slot,
                isSelected: _showAsSelected,
                isAvailable: _isAvailable,
                isDisabledForDuration: widget.isDisabledForDuration,
              ),
              if (_showAsSelected) ...[
                const SizedBox(height: 6),
                Icon(
                  widget.isSecondSlot ? Icons.link : Icons.check_circle,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration() {
    if (_showAsSelected) {
      return BoxDecoration(
        gradient: widget.isSecondSlot
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.accentCyan.withValues(alpha: 0.8),
                  AppColors.accentCyanDark.withValues(alpha: 0.8),
                ],
              )
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.accentCyan, AppColors.accentCyanDark],
              ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentCyan.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      );
    }

    if (!_isAvailable) {
      return BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.lightGrey),
      );
    }

    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}

class _TimeDisplay extends StatelessWidget {
  final TimeSlotEntity slot;
  final bool isSelected;
  final bool isAvailable;

  const _TimeDisplay({
    required this.slot,
    required this.isSelected,
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          LocaleFormatters.formatTimeRange(
            context,
            startTime: slot.startTime,
            endTime: slot.endTime,
            isEndNextDay: slot.isNextDay,
          ),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isSelected
                ? Colors.white
                : isAvailable
                ? AppColors.textPrimary
                : AppColors.textSecondary,
          ),
        ),
        if (slot.isNextDay) ...[const SizedBox(width: 4), const NextDayBadge()],
      ],
    );
  }
}

class _StatusDisplay extends StatelessWidget {
  final TimeSlotEntity slot;
  final bool isSelected;
  final bool isAvailable;
  final bool isDisabledForDuration;

  const _StatusDisplay({
    required this.slot,
    required this.isSelected,
    required this.isAvailable,
    required this.isDisabledForDuration,
  });

  @override
  Widget build(BuildContext context) {
    if (!slot.isAvailable) {
      return _BookedBadge();
    }

    if (isDisabledForDuration) {
      return _DurationUnavailableBadge();
    }

    return _PriceBadge(slot: slot, isSelected: isSelected);
  }
}

class _PriceBadge extends StatelessWidget {
  final TimeSlotEntity slot;
  final bool isSelected;

  const _PriceBadge({required this.slot, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.white.withValues(alpha: 0.2)
            : AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        LocaleFormatters.formatPrice(
          context,
          amount: slot.price,
          currency: slot.currency,
          decimalDigits: 0,
        ),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isSelected ? Colors.white : AppColors.success,
        ),
      ),
    );
  }
}

class _BookedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.block, size: 12, color: AppColors.error),
          const SizedBox(width: 4),
          Text(
            context.l10n.bookedLabel,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }
}

class _DurationUnavailableBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.timer_off_outlined,
            size: 12,
            color: AppColors.warning,
          ),
          const SizedBox(width: 4),
          Text(
            context.l10n.durationUnavailable,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }
}
