import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_animations.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Premium card component with elevation shadow and optional interactions.
///
/// Features:
/// - Clean white background
/// - Subtle elevation shadow
/// - 16px border radius
/// - Optional tap animation (scale effect)
/// - Optional left border accent
/// - Haptic feedback on tap
///
/// Usage:
/// ```dart
/// PremiumCard(
///   onTap: () => print('Card tapped'),
///   accentColor: AppColors.accentCyan,
///   child: Padding(
///     padding: EdgeInsets.all(16),
///     child: Text(context.l10n.cardContent),
///   ),
/// )
/// ```
class PremiumCard extends StatefulWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final Color? accentColor;
  final bool showAccentBorder;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final Color? borderColor;
  final double borderWidth;

  const PremiumCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.accentColor,
    this.showAccentBorder = false,
    this.borderRadius,
    this.boxShadow,
    this.borderColor,
    this.borderWidth = 1.0,
  });

  @override
  State<PremiumCard> createState() => _PremiumCardState();
}

class _PremiumCardState extends State<PremiumCard>
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
    _scaleAnimation =
        Tween<double>(
          begin: AppAnimations.scaleNormal,
          end: AppAnimations.cardTapScale,
        ).animate(
          CurvedAnimation(parent: _controller, curve: AppAnimations.easeInOut),
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onTap != null) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onTap != null) {
      _controller.reverse();
    }
  }

  void _onTapCancel() {
    if (widget.onTap != null) {
      _controller.reverse();
    }
  }

  void _handleTap() {
    HapticFeedback.lightImpact();
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = widget.borderRadius ?? BorderRadius.circular(16);

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap != null ? _handleTap : null,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceWhite,
            borderRadius: borderRadius,
            boxShadow:
                widget.boxShadow ??
                [
                  const BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                  BoxShadow(
                    color: AppColors.shadow.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
            border: widget.borderColor != null
                ? Border.all(
                    color: widget.borderColor!,
                    width: widget.borderWidth,
                  )
                : widget.showAccentBorder && widget.accentColor != null
                ? Border(left: BorderSide(color: widget.accentColor!, width: 4))
                : null,
          ),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: Padding(
              padding: widget.padding ?? const EdgeInsets.all(12),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
