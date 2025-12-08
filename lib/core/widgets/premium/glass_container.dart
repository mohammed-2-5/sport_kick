import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Glassmorphism container with blur effect and semi-transparent background.
///
/// Creates a modern glass-like effect perfect for floating action buttons,
/// overlays, and premium UI elements.
///
/// Features:
/// - Backdrop blur filter
/// - Semi-transparent background
/// - Optional colored border
/// - Customizable blur intensity
///
/// Usage:
/// ```dart
/// GlassContainer(
///   blur: 10,
///   opacity: 0.2,
///   borderRadius: BorderRadius.circular(16),
///   child: Padding(
///     padding: EdgeInsets.all(16),
///     child: Text('Glass effect'),
///   ),
/// )
/// ```
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final BorderRadius? borderRadius;
  final Color? color;
  final Border? border;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  const GlassContainer({
    super.key,
    required this.child,
    this.blur = 10,
    this.opacity = 0.2,
    this.borderRadius,
    this.color,
    this.border,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: (color ?? AppColors.surfaceWhite).withValues(
                alpha: opacity,
              ),
              borderRadius: borderRadius ?? BorderRadius.circular(16),
              border:
                  border ??
                  Border.all(color: AppColors.glassBorder, width: 1.5),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
