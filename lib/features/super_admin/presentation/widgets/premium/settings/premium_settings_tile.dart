import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Premium settings tile with tap action.
///
/// Features:
/// - Icon with colored background
/// - Label and optional value
/// - Arrow indicator
/// - Tap animation
/// - Haptic feedback
class PremiumSettingsTile extends StatefulWidget {
  final String label;
  final String? value;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;
  final bool showArrow;
  final Widget? trailing;

  const PremiumSettingsTile({
    super.key,
    required this.label,
    this.value,
    required this.icon,
    this.iconColor = AppColors.premiumGold,
    this.onTap,
    this.showArrow = true,
    this.trailing,
  });

  @override
  State<PremiumSettingsTile> createState() => _PremiumSettingsTileState();
}

class _PremiumSettingsTileState extends State<PremiumSettingsTile>
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
      end: 0.98,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: () {
        if (widget.onTap != null) {
          HapticFeedback.lightImpact();
          widget.onTap!();
        }
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: widget.iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(widget.icon, size: 20, color: widget.iconColor),
              ),
              const SizedBox(width: 14),
              // Label
              Expanded(
                child: Text(
                  widget.label,
                  style: AppTextStyles.bold(
                    AppTextStyles.titleMedium,
                  ).copyWith(color: colorScheme.onSurface),
                ),
              ),
              // Value or trailing
              if (widget.trailing != null)
                widget.trailing!
              else if (widget.value != null) ...[
                Text(
                  widget.value!,
                  style: AppTextStyles.bodyMediumSecondary.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                if (widget.showArrow) const SizedBox(width: 8),
              ],
              // Arrow
              if (widget.showArrow && widget.onTap != null)
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
