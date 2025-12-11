import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_animations.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/widgets/premium/premium_button_style.dart';

export 'premium_button_style.dart';

/// Premium button component with multiple styles and states.
///
/// Features:
/// - Multiple styles (primary, secondary, outline, text)
/// - Loading state with spinner
/// - Icon support (left/right)
/// - Full-width variant
/// - Disabled state
/// - Scale animation on press
/// - Haptic feedback
///
/// Usage:
/// ```dart
/// PremiumButton(
///   label: 'Book Now',
///   onPressed: () => book(),
///   style: PremiumButtonStyle.primary,
///   icon: Icons.calendar_today,
///   loading: isLoading,
/// )
/// ```
class PremiumButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final PremiumButtonStyle style;
  final IconData? icon;
  final IconData? rightIcon;
  final bool loading;
  final bool fullWidth;
  final double? width;
  final double height;
  final double borderRadius;

  const PremiumButton({
    super.key,
    required this.label,
    this.onPressed,
    this.style = PremiumButtonStyle.primary,
    this.icon,
    this.rightIcon,
    this.loading = false,
    this.fullWidth = false,
    this.width,
    this.height = 56,
    this.borderRadius = 12,
  });

  @override
  State<PremiumButton> createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<PremiumButton>
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

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.loading) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onPressed != null && !widget.loading) {
      _controller.reverse();
    }
  }

  void _onTapCancel() {
    if (widget.onPressed != null && !widget.loading) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.loading;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: isDisabled
          ? null
          : () {
              HapticFeedback.lightImpact();
              widget.onPressed?.call();
            },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: widget.fullWidth ? double.infinity : widget.width,
          height: widget.height,
          decoration: _getDecoration(isDisabled),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _buildContent(isDisabled),
        ),
      ),
    );
  }

  Widget _buildContent(bool isDisabled) {
    if (widget.loading) {
      return Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(_getLoadingColor()),
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null) ...[
          Icon(widget.icon, color: _getTextColor(isDisabled), size: 20),
          const SizedBox(width: 8),
        ],
        Text(
          widget.label,
          style: TextStyle(
            color: _getTextColor(isDisabled),
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        if (widget.rightIcon != null) ...[
          const SizedBox(width: 8),
          Icon(widget.rightIcon, color: _getTextColor(isDisabled), size: 20),
        ],
      ],
    );
  }

  BoxDecoration _getDecoration(bool isDisabled) {
    if (isDisabled) {
      return BoxDecoration(
        color: AppColors.disabled,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      );
    }

    switch (widget.style) {
      case PremiumButtonStyle.primary:
        return BoxDecoration(
          gradient: AppColors.cyanGradient,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentCyan.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        );

      case PremiumButtonStyle.secondary:
        return BoxDecoration(
          color: AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(color: AppColors.accentCyan, width: 2),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        );

      case PremiumButtonStyle.outline:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(color: AppColors.lightTextSecondary, width: 1.5),
        );

      case PremiumButtonStyle.text:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        );
    }
  }

  Color _getTextColor(bool isDisabled) {
    if (isDisabled) {
      return AppColors.buttonDisabledText;
    }

    switch (widget.style) {
      case PremiumButtonStyle.primary:
        return AppColors.textOnNavy;
      case PremiumButtonStyle.secondary:
        return AppColors.accentCyan;
      case PremiumButtonStyle.outline:
        return AppColors.lightTextPrimary;
      case PremiumButtonStyle.text:
        return AppColors.accentCyan;
    }
  }

  Color _getLoadingColor() {
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
