import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_animations.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Icon-only premium button with circular shape.
///
/// Displays a circular button containing only an icon. Provides scale animation
/// feedback on tap and optional custom colors for background and icon.
///
/// Example:
/// ```dart
/// PremiumIconButton(
///   icon: Icons.add,
///   backgroundColor: AppColors.accentCyan,
///   iconColor: Colors.white,
///   size: 56,
///   onPressed: () { ... },
/// )
/// ```
class PremiumIconButton extends StatefulWidget {
  /// The icon data to display in the button.
  final IconData icon;

  /// Callback triggered when the button is pressed.
  /// If null, the button is disabled.
  final VoidCallback? onPressed;

  /// Background color of the button circle.
  /// Defaults to [AppColors.accentCyan].
  final Color? backgroundColor;

  /// Icon color. Defaults to [AppColors.textOnNavy].
  final Color? iconColor;

  /// Diameter of the circular button in logical pixels.
  /// Defaults to 48.
  final double size;

  /// Creates an icon-only premium button.
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
