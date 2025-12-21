import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Premium rating filter chips for reviews.
///
/// Features:
/// - Animated chip selection
/// - Star icons
/// - Gradient selected state
/// - Horizontal scroll
class PremiumRatingFilterChips extends StatelessWidget {
  final int? selectedRating;
  final ValueChanged<int?> onRatingSelected;
  final Map<int, int>? ratingCounts;

  const PremiumRatingFilterChips({
    super.key,
    this.selectedRating,
    required this.onRatingSelected,
    this.ratingCounts,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: AnimationLimiter(
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            AnimationConfiguration.staggeredList(
              position: 0,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(
                  child: _FilterChip(
                    label: context.l10n.all,
                    count:
                        ratingCounts?.values.fold<int>(0, (a, b) => a + b) ?? 0,
                    isSelected: selectedRating == null,
                    onTap: () => onRatingSelected(null),
                  ),
                ),
              ),
            ),
            ...List.generate(5, (index) {
              final rating = 5 - index;
              return AnimationConfiguration.staggeredList(
                position: index + 1,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  horizontalOffset: 50.0,
                  child: FadeInAnimation(
                    child: _FilterChip(
                      rating: rating,
                      count: ratingCounts?[rating],
                      isSelected: selectedRating == rating,
                      onTap: () => onRatingSelected(rating),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

/// Individual filter chip.
class _FilterChip extends StatefulWidget {
  final String? label;
  final int? rating;
  final int? count;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    this.label,
    this.rating,
    this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_FilterChip> createState() => _FilterChipState();
}

class _FilterChipState extends State<_FilterChip>
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
          margin: const EdgeInsets.only(right: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            gradient: widget.isSelected
                ? const LinearGradient(
                    colors: [AppColors.accentCyan, AppColors.accentCyanDark],
                  )
                : null,
            color: widget.isSelected ? null : AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: widget.isSelected ? Colors.transparent : AppColors.border,
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: AppColors.accentCyan.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.rating != null) ...[
                Icon(
                  Icons.star_rounded,
                  size: 16,
                  color: widget.isSelected ? Colors.white : Colors.amber,
                ),
                const SizedBox(width: 4),
                Text(
                  '${widget.rating}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: widget.isSelected
                        ? Colors.white
                        : AppColors.textPrimary,
                  ),
                ),
              ] else
                Text(
                  widget.label ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: widget.isSelected
                        ? Colors.white
                        : AppColors.textPrimary,
                  ),
                ),
              if (widget.count != null) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: widget.isSelected
                        ? Colors.white.withValues(alpha: 0.2)
                        : AppColors.textSecondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${widget.count}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: widget.isSelected
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
