import 'dart:ui';

import 'package:flutter/material.dart';

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
              color: (color ?? Colors.white).withValues(alpha: opacity),
              borderRadius: borderRadius ?? BorderRadius.circular(16),
              border:
                  border ??
                  Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Floating action button with glassmorphism effect.
///
/// Perfect for "Book Now" buttons, chat buttons, etc.
class GlassFloatingButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? accentColor;

  const GlassFloatingButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final accent = accentColor ?? const Color(0xFF00D9FF);

    return GlassContainer(
      blur: 20,
      opacity: 0.15,
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: accent.withValues(alpha: 0.3), width: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    color: accent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Glass card for content overlays.
///
/// Use for floating cards over images or gradients.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  const GlassCard({super.key, required this.child, this.padding, this.margin});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      blur: 15,
      opacity: 0.12,
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin,
      child: child,
    );
  }
}

/// Glass tab bar for navigation.
///
/// Modern glassmorphism tab bar with blur effect.
class GlassTabBar extends StatelessWidget {
  final List<String> tabs;
  final int currentIndex;
  final ValueChanged<int> onTabChanged;

  const GlassTabBar({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      blur: 20,
      opacity: 0.1,
      borderRadius: BorderRadius.circular(12),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: List.generate(
          tabs.length,
          (index) => Expanded(
            child: _GlassTab(
              label: tabs[index],
              isSelected: index == currentIndex,
              onTap: () => onTabChanged(index),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GlassTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withValues(alpha: 0.3)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : Colors.white.withValues(alpha: 0.6),
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

/// Glass bottom sheet for modals.
///
/// Draggable bottom sheet with glassmorphism effect.
class GlassBottomSheet extends StatelessWidget {
  final Widget child;
  final String? title;

  const GlassBottomSheet({super.key, required this.child, this.title});

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => GlassBottomSheet(title: title, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      blur: 30,
      opacity: 0.15,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
      child: Container(
        padding: EdgeInsets.only(
          top: 16,
          left: 24,
          right: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            if (title != null) ...[
              const SizedBox(height: 20),
              Text(
                title!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
            ] else
              const SizedBox(height: 16),

            child,
          ],
        ),
      ),
    );
  }
}
