import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_animations.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/l10n/app_localizations.dart';

/// Individual duration option card with premium styling.
///
/// Shows duration, total price, and selection state with animations.
/// Used by [BookingDurationSelector] to display duration options.
class DurationOptionCard extends StatefulWidget {
  /// Duration in hours (1 or 2).
  final int duration;

  /// Price per hour for the field.
  final double pricePerHour;

  /// Whether this option is currently selected.
  final bool isSelected;

  /// Whether this option is available for selection.
  final bool isAvailable;

  /// Callback when this option is tapped.
  final VoidCallback? onTap;

  /// Optional badge text (e.g., "Recommended", "Best Value").
  final String? badgeText;

  /// Message shown when option is unavailable.
  final String? unavailableMessage;

  /// Whether to use compact layout for small screens.
  final bool isCompact;

  const DurationOptionCard({
    super.key,
    required this.duration,
    required this.pricePerHour,
    required this.isSelected,
    required this.isAvailable,
    this.onTap,
    this.badgeText,
    this.unavailableMessage,
    this.isCompact = false,
  });

  @override
  State<DurationOptionCard> createState() => _DurationOptionCardState();
}

class _DurationOptionCardState extends State<DurationOptionCard>
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

  double get _totalPrice => widget.pricePerHour * widget.duration;
  String get _formattedPrice => '${_totalPrice.toStringAsFixed(0)} EGP';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return GestureDetector(
      onTapDown: widget.isAvailable ? (_) => _controller.forward() : null,
      onTapUp: widget.isAvailable ? (_) => _controller.reverse() : null,
      onTapCancel: widget.isAvailable ? () => _controller.reverse() : null,
      onTap: widget.isAvailable
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
          height: widget.isCompact
              ? BookingConstants.durationChipHeight - 10
              : BookingConstants.durationChipHeight,
          decoration: _buildDecoration(),
          child: Stack(
            children: [
              _buildContent(l10n),
              if (widget.badgeText != null && widget.isAvailable) _buildBadge(),
              if (widget.isSelected) _buildSelectedIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration() {
    if (!widget.isAvailable) {
      return BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(
          BookingConstants.durationChipBorderRadius,
        ),
        border: Border.all(color: AppColors.lightGrey),
      );
    }

    if (widget.isSelected) {
      return BoxDecoration(
        gradient: AppColors.cyanGradient,
        borderRadius: BorderRadius.circular(
          BookingConstants.durationChipBorderRadius,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentCyan.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      );
    }

    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(
        BookingConstants.durationChipBorderRadius,
      ),
      border: Border.all(color: AppColors.border, width: 1.5),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  Widget _buildContent(AppLocalizations l10n) {
    final textColor = widget.isSelected
        ? Colors.white
        : widget.isAvailable
        ? AppColors.textPrimary
        : AppColors.textSecondary;

    final priceColor = widget.isSelected
        ? Colors.white.withValues(alpha: 0.9)
        : widget.isAvailable
        ? AppColors.accentCyan
        : AppColors.textSecondary;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.schedule_rounded, size: 18, color: textColor),
              const SizedBox(width: 6),
              Text(
                l10n.durationHours(widget.duration),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _formattedPrice,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: priceColor,
            ),
          ),
          if (!widget.isAvailable && widget.unavailableMessage != null) ...[
            const SizedBox(height: 4),
            Text(
              widget.unavailableMessage!,
              style: const TextStyle(fontSize: 10, color: AppColors.error),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBadge() {
    final bgColor = widget.isSelected
        ? Colors.white.withValues(alpha: 0.25)
        : AppColors.statusSuccess.withValues(alpha: 0.1);

    final textColor = widget.isSelected
        ? Colors.white
        : AppColors.statusSuccess;

    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          widget.badgeText!,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedIndicator() {
    return const Positioned(
      top: 8,
      left: 8,
      child: Icon(Icons.check_circle_rounded, size: 20, color: Colors.white),
    );
  }
}
