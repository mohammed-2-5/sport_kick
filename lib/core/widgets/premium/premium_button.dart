import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Premium button component with multiple styles and states.
///
/// Features:
/// - Multiple styles (primary, secondary, outline, text)
/// - Loading state with spinner
/// - Icon support (left/right)
/// - Full-width variant
/// - Disabled state
/// - Scale animation on press
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
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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
      onTap: isDisabled ? null : widget.onPressed,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: widget.fullWidth ? double.infinity : widget.width,
          height: widget.height,
          decoration: _getDecoration(isDisabled),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isDisabled ? null : widget.onPressed,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _buildContent(isDisabled),
              ),
            ),
          ),
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
          gradient: const LinearGradient(
            colors: [
              Color(0xFF00D9FF), // Cyan
              Color(0xFF00A7CC), // Darker Cyan
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00D9FF).withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        );

      case PremiumButtonStyle.secondary:
        return BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(color: const Color(0xFF00D9FF), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
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
        return Colors.white;
      case PremiumButtonStyle.secondary:
        return const Color(0xFF00D9FF);
      case PremiumButtonStyle.outline:
        return AppColors.lightTextPrimary;
      case PremiumButtonStyle.text:
        return const Color(0xFF00D9FF);
    }
  }

  Color _getLoadingColor() {
    switch (widget.style) {
      case PremiumButtonStyle.primary:
        return Colors.white;
      case PremiumButtonStyle.secondary:
      case PremiumButtonStyle.text:
        return const Color(0xFF00D9FF);
      case PremiumButtonStyle.outline:
        return AppColors.lightTextPrimary;
    }
  }
}

/// Button style variants.
enum PremiumButtonStyle {
  /// Cyan gradient with white text and shadow
  primary,

  /// White background with cyan border
  secondary,

  /// Transparent with grey border
  outline,

  /// Text only with cyan color
  text,
}

/// Small premium button variant.
///
/// Compact button for less prominent actions.
class SmallPremiumButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return PremiumButton(
      label: label,
      onPressed: onPressed,
      style: style,
      icon: icon,
      height: 40,
      borderRadius: 10,
    );
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
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.92,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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
      onTap: widget.onPressed,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? const Color(0xFF00D9FF),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: (widget.backgroundColor ?? const Color(0xFF00D9FF))
                    .withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            widget.icon,
            color: widget.iconColor ?? Colors.white,
            size: widget.size * 0.5,
          ),
        ),
      ),
    );
  }
}
