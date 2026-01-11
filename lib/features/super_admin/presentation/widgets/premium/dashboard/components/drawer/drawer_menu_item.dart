import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Drawer menu item with animation and gold accent when selected.
///
/// Features:
/// - Animated tap feedback
/// - Gold gradient for selected state
/// - Icon and label with arrow indicator
class DrawerMenuItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const DrawerMenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<DrawerMenuItem> createState() => _DrawerMenuItemState();
}

class _DrawerMenuItemState extends State<DrawerMenuItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            gradient: widget.isSelected
                ? LinearGradient(
                    colors: [
                      AppColors.goldAccent.withValues(alpha: 0.15),
                      AppColors.goldAccent.withValues(alpha: 0.05),
                    ],
                  )
                : null,
            borderRadius: BorderRadius.circular(12),
            border: widget.isSelected
                ? Border.all(color: AppColors.goldAccent.withValues(alpha: 0.3))
                : null,
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  gradient: widget.isSelected
                      ? const LinearGradient(
                          colors: [AppColors.goldAccent, Color(0xFFD4A574)],
                        )
                      : null,
                  color: widget.isSelected
                      ? null
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: widget.isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.goldAccent.withValues(alpha: 0.3),
                            blurRadius: 8,
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  widget.icon,
                  size: 18,
                  color: widget.isSelected
                      ? Colors.white
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 12),

              // Label
              Expanded(
                child: Text(
                  widget.label,
                  style: AppTextStyles.withColor(
                    widget.isSelected
                        ? AppTextStyles.bold(AppTextStyles.bodyMedium)
                        : AppTextStyles.bodyMedium,
                    widget.isSelected
                        ? AppColors.goldAccent
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),

              // Arrow for selected
              if (widget.isSelected)
                const Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: AppColors.goldAccent,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
