import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/city/domain/entities/city_entity.dart';

/// Premium city selection card.
///
/// Features:
/// - Gradient border when selected
/// - City icon/image placeholder
/// - Tap animation
/// - Checkmark indicator
/// - Haptic feedback
/// - Theme-aware: adapts to light/dark mode
class PremiumCityCard extends StatefulWidget {
  final CityEntity city;
  final bool isSelected;
  final VoidCallback onTap;

  const PremiumCityCard({
    super.key,
    required this.city,
    required this.isSelected,
    required this.onTap,
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
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Use accent cyan for selected state, adapts border/shadow for dark mode
    const selectedColor = AppColors.accentCyan;
    const selectedColorDark = AppColors.accentCyanDark;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        HapticFeedback.selectionClick();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              width: 2,
              color: widget.isSelected ? selectedColor : colorScheme.outline,
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: selectedColor.withValues(alpha: 0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.3)
                          : Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // City icon
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: widget.isSelected
                              ? [selectedColor, selectedColorDark]
                              : [
                                  colorScheme.onSurfaceVariant.withValues(
                                    alpha: 0.1,
                                  ),
                                  colorScheme.onSurfaceVariant.withValues(
                                    alpha: 0.05,
                                  ),
                                ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.location_city,
                        size: 32,
                        color: widget.isSelected
                            ? Colors.white
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // City name
                    Text(
                      widget.city.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: widget.isSelected
                            ? selectedColor
                            : colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.city.fieldsCount != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        context.l10n.fieldsCount(widget.city.fieldsCount!),
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.7,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
              // Check indicator
              if (widget.isSelected)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [selectedColor, selectedColorDark],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: selectedColor.withValues(alpha: 0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
