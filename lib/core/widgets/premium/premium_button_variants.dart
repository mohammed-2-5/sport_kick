import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_animations.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/widgets/premium/premium_button_style.dart';

/// Small premium button variant with tap animation.
///
/// Compact button for less prominent actions.
class SmallPremiumButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final PremiumButtonStyle style;
  final IconData? icon;

  const SmallPremiumButton({
    super.key,
    required this.label,
    this.onPressed,
    this.style = PremiumButtonStyle.secondary,
    this.icon,
  });

  @override
  State<SmallPremiumButton> createState() => _SmallPremiumButtonState();
}

class _SmallPremiumButtonState extends State<SmallPremiumButton>
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
          end: AppAnimations.buttonPressScale,
        ).animate(
          CurvedAnimation(parent: _controller, curve: AppAnimations.easeInOut),
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null;

    return GestureDetector(
      onTapDown: isDisabled ? null : (_) => _controller.forward(),
      onTapUp: isDisabled ? null : (_) => _controller.reverse(),
      onTapCancel: isDisabled ? null : () => _controller.reverse(),
      onTap: isDisabled
          ? null
          : () {
              HapticFeedback.lightImpact();
              widget.onPressed?.call();
            },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: _getDecoration(isDisabled),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, color: _getTextColor(isDisabled), size: 16),
                const SizedBox(width: 6),
              ],
              Text(
                widget.label,
                style: TextStyle(
                  color: _getTextColor(isDisabled),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _getDecoration(bool isDisabled) {
    if (isDisabled) {
      return BoxDecoration(
        color: AppColors.disabled,
        borderRadius: BorderRadius.circular(10),
      );
    }

    switch (widget.style) {
      case PremiumButtonStyle.primary:
        return BoxDecoration(
          gradient: AppColors.cyanGradient,
          borderRadius: BorderRadius.circular(10),
        );
      case PremiumButtonStyle.secondary:
        return BoxDecoration(
          color: AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.accentCyan, width: 1.5),
        );
      case PremiumButtonStyle.outline:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.lightTextSecondary, width: 1),
        );
      case PremiumButtonStyle.text:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        );
    }
  }

  Color _getTextColor(bool isDisabled) {
    if (isDisabled) return AppColors.buttonDisabledText;

    switch (widget.style) {
      case PremiumButtonStyle.primary:
        return AppColors.textOnNavy;
      case PremiumButtonStyle.secondary:
      case PremiumButtonStyle.text:
        return AppColors.accentCyan;
      case PremiumButtonStyle.outline:
        return AppColors.lightTextPrimary;
    }
  }
}

/// Icon-only premium button.
///
/// Circular button with just an icon.
class PremiumIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;

  const PremiumIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = 48,
  });

  @override
  State<PremiumIconButton> createState() => _PremiumIconButtonState();
}

class _PremiumIconButtonState extends State<PremiumIconButton>
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
    _scaleAnimation = Tween<double>(begin: AppAnimations.scaleNormal, end: 0.92)
        .animate(
          CurvedAnimation(parent: _controller, curve: AppAnimations.easeInOut),
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onPressed != null
          ? () {
              HapticFeedback.lightImpact();
              widget.onPressed?.call();
            }
          : null,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? AppColors.accentCyan,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: (widget.backgroundColor ?? AppColors.accentCyan)
                    .withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            widget.icon,
            color: widget.iconColor ?? AppColors.textOnNavy,
            size: widget.size * 0.5,
          ),
        ),
      ),
    );
  }
}
