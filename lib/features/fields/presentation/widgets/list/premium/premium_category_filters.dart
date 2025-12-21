import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/fields/domain/entities/sport_category_entity.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Premium animated category filter chips.
///
/// Features:
/// - Staggered entrance animations
/// - Tap scale animations
/// - Gradient selected state
/// - Icon support
class PremiumCategoryFilters extends StatelessWidget {
  final List<SportCategoryEntity> categories;
  final String? selectedCategoryId;
  final ValueChanged<String?> onCategorySelected;

  const PremiumCategoryFilters({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AnimationLimiter(
        child: Row(
          children: [
            // All Categories Chip
            AnimationConfiguration.staggeredList(
              position: 0,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(
                  child: _CategoryChip(
                    label: context.l10n.all,
                    icon: Icons.apps,
                    isSelected: selectedCategoryId == null,
                    onTap: () => onCategorySelected(null),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Category Chips
            ...List.generate(
              categories.length,
              (index) => Padding(
                padding: const EdgeInsets.only(right: 12),
                child: AnimationConfiguration.staggeredList(
                  position: index + 1,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(
                      child: _CategoryChip(
                        label: categories[index].name,
                        icon: _getCategoryIcon(categories[index].name),
                        isSelected: selectedCategoryId == categories[index].id,
                        onTap: () => onCategorySelected(categories[index].id),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    final lower = categoryName.toLowerCase();
    if (lower.contains('football') || lower.contains('soccer')) {
      return Icons.sports_soccer;
    }
    if (lower.contains('tennis')) return Icons.sports_tennis;
    if (lower.contains('basketball')) return Icons.sports_basketball;
    if (lower.contains('volleyball')) return Icons.sports_volleyball;
    if (lower.contains('paddle')) return Icons.sports_tennis;
    return Icons.sports;
  }
}

/// Individual category chip with animation.
class _CategoryChip extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends State<_CategoryChip> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _isPressed ? 0.95 : 1.0,
      duration: const Duration(milliseconds: 100),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            gradient: widget.isSelected
                ? const LinearGradient(
                    colors: [AppColors.accentCyan, AppColors.accentCyanDark],
                  )
                : null,
            color: widget.isSelected ? null : Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: widget.isSelected
                  ? Colors.transparent
                  : AppColors.accentCyan.withValues(alpha: 0.3),
              width: 2,
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: AppColors.accentCyan.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 18,
                color: widget.isSelected ? Colors.white : AppColors.accentCyan,
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: AppTextStyles.labelLarge.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: widget.isSelected
                      ? Colors.white
                      : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
