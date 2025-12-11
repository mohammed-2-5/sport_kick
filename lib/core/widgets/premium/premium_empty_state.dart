import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_animations.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';

/// Premium empty state widget with icon, message, and optional action.
///
/// Features:
/// - Large icon with cyan accent
/// - Bold title
/// - Descriptive message
/// - Optional action button
/// - Subtle floating animation
///
/// Usage:
/// ```dart
/// PremiumEmptyState(
///   icon: Icons.bookmark_border,
///   title: 'No Favorites Yet',
///   message: 'Start adding fields to your favorites',
///   actionLabel: 'Browse Fields',
///   onAction: () => navigate(),
/// )
/// ```
class PremiumEmptyState extends StatefulWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? iconColor;
  final double iconSize;

  const PremiumEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.iconColor,
    this.iconSize = 120,
  });

  @override
  State<PremiumEmptyState> createState() => _PremiumEmptyStateState();
}

class _PremiumEmptyStateState extends State<PremiumEmptyState>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.floatDuration,
      vsync: this,
    )..repeat(reverse: true);

    _floatAnimation =
        Tween<double>(
          begin: AppAnimations.floatUp,
          end: AppAnimations.floatDown,
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
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated Icon
            AnimatedBuilder(
              animation: _floatAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _floatAnimation.value),
                  child: child,
                );
              },
              child: Container(
                width: widget.iconSize,
                height: widget.iconSize,
                decoration: BoxDecoration(
                  color: (widget.iconColor ?? AppColors.accentCyan).withValues(
                    alpha: 0.1,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.icon,
                  size: widget.iconSize * 0.5,
                  color: widget.iconColor ?? AppColors.accentCyan,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Title
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.lightTextPrimary,
                height: 1.3,
              ),
            ),

            const SizedBox(height: 12),

            // Message
            Text(
              widget.message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.lightTextSecondary,
                height: 1.5,
              ),
            ),

            // Action Button
            if (widget.actionLabel != null && widget.onAction != null) ...[
              const SizedBox(height: 32),
              PremiumButton(
                label: widget.actionLabel!,
                onPressed: widget.onAction,
                style: PremiumButtonStyle.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
