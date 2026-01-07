import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/theme/theme_extensions.dart';

/// Premium filter chips for super admin users list.
///
/// Features:
/// - Active/Inactive/All filters
/// - Glass effect design
/// - Smooth animations
class PremiumUsersListFilters extends StatelessWidget {
  final String? selectedFilter; // null = all, 'Active', 'Inactive'
  final Function(String?) onFilterChanged;
  final Map<String, int> stats;

  const PremiumUsersListFilters({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: context.cardShadow,
      ),
      child: Row(
        children: [
          _FilterChip(
            label: context.l10n.all,
            count: stats[context.l10n.total2] ?? 0,
            isSelected: selectedFilter == null,
            onTap: () => onFilterChanged(null),
          ),
          _FilterChip(
            label: context.l10n.active,
            count: stats[context.l10n.active2] ?? 0,
            isSelected: selectedFilter == context.l10n.active,
            onTap: () => onFilterChanged('Active'),
            color: colorScheme.success,
          ),
          _FilterChip(
            label: context.l10n.inactive,
            count: stats[context.l10n.inactive2] ?? 0,
            isSelected: selectedFilter == context.l10n.inactive,
            onTap: () => onFilterChanged('Inactive'),
            color: colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}

/// Individual filter chip.
class _FilterChip extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const _FilterChip({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      color ?? AppColors.premiumGold,
                      (color ?? AppColors.premiumGold).withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: (color ?? AppColors.premiumGold).withValues(
                        alpha: 0.3,
                      ),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppTextStyles.withColor(
                  isSelected
                      ? AppTextStyles.bold(AppTextStyles.labelMedium)
                      : AppTextStyles.labelMedium,
                  isSelected ? Colors.white : colorScheme.onSurfaceVariant,
                ),
              ),
              if (count > 0) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.3)
                        : (color ?? AppColors.premiumGold).withValues(
                            alpha: 0.1,
                          ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    count.toString(),
                    style: AppTextStyles.withColor(
                      AppTextStyles.bold(AppTextStyles.labelSmall),
                      isSelected
                          ? Colors.white
                          : (color ?? AppColors.premiumGold),
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
