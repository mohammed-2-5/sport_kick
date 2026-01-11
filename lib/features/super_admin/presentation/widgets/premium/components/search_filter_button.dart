import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Filter button for search bars with active filter indicator.
///
/// Features:
/// - Gold accent when filters are active
/// - Badge indicator for active filters
/// - Rounded corner on right side
class SearchFilterButton extends StatelessWidget {
  final bool hasActiveFilters;
  final VoidCallback onTap;

  const SearchFilterButton({
    super.key,
    required this.hasActiveFilters,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.horizontal(right: Radius.circular(14)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              Icons.tune,
              size: 20,
              color: hasActiveFilters
                  ? AppColors.premiumGold
                  : colorScheme.onSurfaceVariant,
            ),
            if (hasActiveFilters)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.premiumGold,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.premiumGold.withValues(alpha: 0.4),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
