import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Premium filter chips for owner fields.
///
/// Features:
/// - Active/Inactive/All filters
/// - Glass effect design
/// - Smooth animations
class PremiumOwnerFieldsFilters extends StatelessWidget {
  final bool? selectedFilter; // null = all, true = active, false = inactive
  final Function(bool?) onFilterChanged;
  final Map<String, int> stats;

  const PremiumOwnerFieldsFilters({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _FilterChip(
            label: context.l10n.all,
            count: stats['total'] ?? 0,
            isSelected: selectedFilter == null,
            onTap: () => onFilterChanged(null),
          ),
          _FilterChip(
            label: context.l10n.active,
            count: stats['active'] ?? 0,
            isSelected: selectedFilter == true,
            onTap: () => onFilterChanged(true),
            color: Colors.green,
          ),
          _FilterChip(
            label: context.l10n.inactive,
            count: stats['inactive'] ?? 0,
            isSelected: selectedFilter == false,
            onTap: () => onFilterChanged(false),
            color: Colors.grey,
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
                      color ?? AppColors.accentCyan,
                      (color ?? AppColors.accentCyan).withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: (color ?? AppColors.accentCyan).withValues(
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
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
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
                        : (color ?? AppColors.accentCyan).withValues(
                            alpha: 0.1,
                          ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    count.toString(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? Colors.white
                          : (color ?? AppColors.accentCyan),
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
