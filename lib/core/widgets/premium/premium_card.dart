import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Premium card component with elevation shadow and optional interactions.
///
/// Features:
/// - Clean white background
/// - Subtle elevation shadow
/// - 16px border radius
/// - Optional tap animation (scale effect)
/// - Optional left border accent
/// - Optional shimmer loading state
///
/// Usage:
/// ```dart
/// PremiumCard(
///   onTap: () => print('Card tapped'),
///   accentColor: AppColors.accentCyan,
///   child: Padding(
///     padding: EdgeInsets.all(16),
///     child: Text('Card content'),
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

  const PremiumCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.accentColor,
    this.showAccentBorder = false,
    this.borderRadius,
    this.boxShadow,
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
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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

  @override
  Widget build(BuildContext context) {
    final borderRadius = widget.borderRadius ?? BorderRadius.circular(16);

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceWhite,
            borderRadius: borderRadius,
            boxShadow:
                widget.boxShadow ??
                [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
            border: widget.showAccentBorder && widget.accentColor != null
                ? Border(left: BorderSide(color: widget.accentColor!, width: 4))
                : null,
          ),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: widget.padding != null
                ? Padding(padding: widget.padding!, child: widget.child)
                : widget.child,
          ),
        ),
      ),
    );
  }
}

/// Premium card with built-in padding.
///
/// Convenience wrapper around PremiumCard with default padding.
class PremiumCardWithPadding extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? accentColor;
  final bool showAccentBorder;

  const PremiumCardWithPadding({
    super.key,
    required this.child,
    this.onTap,
    this.accentColor,
    this.showAccentBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.all(16),
      onTap: onTap,
      accentColor: accentColor,
      showAccentBorder: showAccentBorder,
      child: child,
    );
  }
}

/// Premium card with shimmer loading effect.
///
/// Shows animated shimmer effect for loading states.
class PremiumLoadingCard extends StatefulWidget {
  final double height;
  final BorderRadius? borderRadius;

  const PremiumLoadingCard({super.key, this.height = 120, this.borderRadius});

  @override
  State<PremiumLoadingCard> createState() => _PremiumLoadingCardState();
}

class _PremiumLoadingCardState extends State<PremiumLoadingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = widget.borderRadius ?? BorderRadius.circular(16);

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Stack(
              children: [
                Container(color: AppColors.shimmerBase),
                Transform.translate(
                  offset: Offset(_animation.value * 300, 0),
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.shimmerBase.withValues(alpha: 0),
                          AppColors.shimmerHighlight,
                          AppColors.shimmerBase.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Elevated premium card with stronger shadow.
///
/// Use for cards that need more prominence.
class ElevatedPremiumCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  const ElevatedPremiumCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: padding,
      onTap: onTap,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
      child: child,
    );
  }
}
