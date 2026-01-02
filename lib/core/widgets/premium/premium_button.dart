import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_animations.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/theme/theme_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_button_style.dart';

export 'premium_button_style.dart';

/// Premium button component with multiple styles and states.
///
/// Features:
/// - Multiple styles (primary, secondary, outline, text)
/// - Theme-aware colors (adapts to light/dark mode)
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
///   label: context.l10n.bookNow,
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
          decoration: _getDecoration(context, isDisabled),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _buildContent(context, isDisabled),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isDisabled) {
    if (widget.loading) {
      return Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(
              _getLoadingColor(context),
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null) ...[
          Icon(
            widget.icon,
            color: _getTextColor(context, isDisabled),
            size: 20,
          ),
          const SizedBox(width: 8),
        ],
        Text(
          widget.label,
          style: TextStyle(
            color: _getTextColor(context, isDisabled),
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        if (widget.rightIcon != null) ...[
          const SizedBox(width: 8),
          Icon(
            widget.rightIcon,
            color: _getTextColor(context, isDisabled),
            size: 20,
          ),
        ],
      ],
    );
  }

  BoxDecoration _getDecoration(BuildContext context, bool isDisabled) {
    final colorScheme = context.colors;
    final isDark = context.isDarkMode;

    if (isDisabled) {
      return BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
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
              color: AppColors.accentCyan.withValues(alpha: isDark ? 0.4 : 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        );

      case PremiumButtonStyle.secondary:
        return BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(color: AppColors.accentCyan, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        );

      case PremiumButtonStyle.outline:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(color: colorScheme.outline, width: 1.5),
        );

      case PremiumButtonStyle.text:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        );
    }
  }

  Color _getTextColor(BuildContext context, bool isDisabled) {
    final colorScheme = context.colors;

    if (isDisabled) {
      return colorScheme.onSurfaceVariant;
    }

    switch (widget.style) {
      case PremiumButtonStyle.primary:
        return AppColors.textOnNavy;
      case PremiumButtonStyle.secondary:
        return AppColors.accentCyan;
      case PremiumButtonStyle.outline:
        return colorScheme.onSurface;
      case PremiumButtonStyle.text:
        return AppColors.accentCyan;
    }
  }

  Color _getLoadingColor(BuildContext context) {
    final colorScheme = context.colors;

    switch (widget.style) {
      case PremiumButtonStyle.primary:
        return AppColors.textOnNavy;
      case PremiumButtonStyle.secondary:
      case PremiumButtonStyle.text:
        return AppColors.accentCyan;
      case PremiumButtonStyle.outline:
        return colorScheme.onSurface;
    }
  }
}
