import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Premium city card with glassmorphism design.
///
/// Features:
/// - Gradient accent bar based on active status
/// - Animated hover/tap effects
/// - Field count badge
/// - Status indicator with glow effect
/// - Haptic feedback on tap
class PremiumCityCard extends StatefulWidget {
  /// City name to display.
  final String name;

  /// Number of fields in this city.
  final int fieldsCount;

  /// Whether the city is currently active.
  final bool isActive;

  /// Callback when the card is tapped.
  final VoidCallback? onTap;

  /// Callback for edit action.
  final VoidCallback? onEdit;

  /// Callback for toggle status action.
  final VoidCallback? onToggleStatus;

  const PremiumCityCard({
    super.key,
    required this.name,
    required this.fieldsCount,
    required this.isActive,
    this.onTap,
    this.onEdit,
    this.onToggleStatus,
  });

  @override
  State<PremiumCityCard> createState() => _PremiumCityCardState();
}

class _PremiumCityCardState extends State<PremiumCityCard>
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
    final accentColor = widget.isActive
        ? const Color(0xFF10B981) // Green for active
        : const Color(0xFFEF4444); // Red for inactive

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap?.call();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: accentColor.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Row(
              children: [
                // Accent bar
                Container(
                  width: 5,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [accentColor, accentColor.withValues(alpha: 0.7)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),

                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // City icon with status
                        _CityIcon(
                          isActive: widget.isActive,
                          accentColor: accentColor,
                        ),
                        const SizedBox(width: 14),

                        // City info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.name,
                                style: AppTextStyles.titleSmall.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  _FieldsBadge(count: widget.fieldsCount),
                                  const SizedBox(width: 8),
                                  _StatusBadge(isActive: widget.isActive),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Actions
                        _ActionButtons(
                          onEdit: widget.onEdit,
                          onToggleStatus: widget.onToggleStatus,
                          isActive: widget.isActive,
                        ),
                      ],
                    ),
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

/// City icon with status glow.
class _CityIcon extends StatelessWidget {
  final bool isActive;
  final Color accentColor;

  const _CityIcon({required this.isActive, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accentColor.withValues(alpha: 0.15),
            accentColor.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(Icons.location_city_rounded, color: accentColor, size: 24),
    );
  }
}

/// Badge showing field count.
class _FieldsBadge extends StatelessWidget {
  final int count;

  const _FieldsBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.accentCyan.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.sports_soccer,
            size: 12,
            color: AppColors.accentCyan.withValues(alpha: 0.8),
          ),
          const SizedBox(width: 4),
          Text(
            context.l10n.fieldsCount(count),
            style: AppTextStyles.withColor(
              AppTextStyles.labelSmallBold,
              AppColors.accentCyan,
            ),
          ),
        ],
      ),
    );
  }
}

/// Status badge (Active/Inactive).
class _StatusBadge extends StatelessWidget {
  final bool isActive;

  const _StatusBadge({required this.isActive});

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color(0xFF10B981) : const Color(0xFFEF4444);
    final label = isActive ? context.l10n.active : context.l10n.inactive;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 4),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Action buttons (edit, toggle status).
class _ActionButtons extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onToggleStatus;
  final bool isActive;

  const _ActionButtons({
    this.onEdit,
    this.onToggleStatus,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onEdit != null)
          _ActionButton(
            icon: Icons.edit_rounded,
            color: AppColors.accentCyan,
            onTap: onEdit!,
          ),
        if (onToggleStatus != null) ...[
          const SizedBox(width: 8),
          _ActionButton(
            icon: isActive ? Icons.pause_rounded : Icons.play_arrow_rounded,
            color: isActive ? const Color(0xFFEF4444) : const Color(0xFF10B981),
            onTap: onToggleStatus!,
          ),
        ],
      ],
    );
  }
}

/// Individual action button.
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}
