import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_animations.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/widgets/premium/premium_button_style.dart';

/// Small premium button variant with tap animation.
///
/// Compact button for less prominent actions with scale animation feedback.
/// Supports multiple style variants (primary, secondary, outline, text) and
/// optional icon display.
///
/// Example:
/// ```dart
/// SmallPremiumButton(
///   label: 'Cancel',
///   icon: Icons.cancel,
///   style: PremiumButtonStyle.secondary,
///   onPressed: () { ... },
/// )
/// ```
class SmallPremiumButton extends StatefulWidget {
  /// Text label displayed on the button.
  final String label;

  /// Callback triggered when the button is pressed.
  /// If null, the button is disabled.
  final VoidCallback? onPressed;

  /// Visual style variant for the button.
  final PremiumButtonStyle style;

  /// Optional icon displayed before the label.
  final IconData? icon;

  /// Creates a small premium button.
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
