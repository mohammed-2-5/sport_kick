import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_animations.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/l10n/app_localizations.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Individual duration option card with premium styling.
///
/// Shows duration, total price, and selection state with animations.
/// Uses Column layout for proper badge positioning.
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
          decoration: _buildDecoration(),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top row: Badge and Selected indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Selected indicator (start side in RTL)
                  if (widget.isSelected)
                    Icon(
                      Icons.check_circle_rounded,
                      size: 20,
                      color: Theme.of(context).colorScheme.onPrimary,
                    )
                  else
                    const SizedBox(width: 20),

                  // Badge (end side in RTL)
                  if (widget.badgeText != null && widget.isAvailable)
                    _buildBadge()
                  else
                    const SizedBox(width: 20),
                ],
              ),

              const SizedBox(height: 8),

              // Main content
              _buildMainContent(l10n),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration() {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!widget.isAvailable) {
      return BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(
          BookingConstants.durationChipBorderRadius,
        ),
        border: Border.all(color: colorScheme.outlineVariant),
      );
    }

    if (widget.isSelected) {
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colorScheme.primary, colorScheme.primaryContainer],
        ),
        borderRadius: BorderRadius.circular(
          BookingConstants.durationChipBorderRadius,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      );
    }

    return BoxDecoration(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(
        BookingConstants.durationChipBorderRadius,
      ),
      border: Border.all(color: colorScheme.outline, width: 1.5),
      boxShadow: [
        BoxShadow(
          color: isDark
              ? Colors.black.withValues(alpha: 0.2)
              : Colors.black.withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  Widget _buildMainContent(AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final errorColor = isDark ? AppColors.darkError : AppColors.error;

    final textColor = widget.isSelected
        ? colorScheme.onPrimary
        : widget.isAvailable
        ? colorScheme.onSurface
        : colorScheme.onSurfaceVariant;

    final priceColor = widget.isSelected
        ? colorScheme.onPrimary.withValues(alpha: 0.9)
        : widget.isAvailable
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.schedule_rounded, size: 18, color: textColor),
            const SizedBox(width: 6),
            Text(
              l10n.durationHours(widget.duration),
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          _formattedPrice,
          style: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: priceColor,
          ),
        ),
        if (!widget.isAvailable && widget.unavailableMessage != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.unavailableMessage!,
            style: AppTextStyles.labelSmall.copyWith(
              fontSize: 10,
              color: errorColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildBadge() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final successColor = isDark ? AppColors.darkSuccess : AppColors.success;

    final colorScheme = Theme.of(context).colorScheme;
    final bgColor = widget.isSelected
        ? colorScheme.onPrimary.withValues(alpha: 0.25)
        : successColor.withValues(alpha: 0.1);

    final textColor = widget.isSelected ? colorScheme.onPrimary : successColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        widget.badgeText!,
        style: AppTextStyles.labelSmall.copyWith(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
