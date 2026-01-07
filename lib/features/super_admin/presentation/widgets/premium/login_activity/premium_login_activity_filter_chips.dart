import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/auth/domain/entities/login_activity_entity.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/theme/theme_extensions.dart';

/// Filter chips for login activity status.
///
/// Allows filtering by:
/// - All
/// - Success
/// - Failed
/// - Blocked
class PremiumLoginActivityFilterChips extends StatelessWidget {
  final String selectedFilter;
  final int allCount;
  final int successCount;
  final int failedCount;
  final int blockedCount;
  final ValueChanged<String> onFilterChanged;

  const PremiumLoginActivityFilterChips({
    required this.selectedFilter,
    required this.allCount,
    required this.successCount,
    required this.failedCount,
    required this.blockedCount,
    required this.onFilterChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _FilterChip(
            label: context.l10n.all,
            count: allCount,
            isSelected: selectedFilter == context.l10n.all2,
            onTap: () => onFilterChanged('all'),
          ),
          const SizedBox(width: 10),
          _FilterChip(
            label: LoginStatus.success.displayName,
            count: successCount,
            isSelected: selectedFilter == context.l10n.successStatus,
            color: Theme.of(context).colorScheme.success,
            onTap: () => onFilterChanged('success'),
          ),
          const SizedBox(width: 10),
          _FilterChip(
            label: LoginStatus.failed.displayName,
            count: failedCount,
            isSelected: selectedFilter == context.l10n.failed,
            color: Theme.of(context).colorScheme.error,
            onTap: () => onFilterChanged('failed'),
          ),
          const SizedBox(width: 10),
          _FilterChip(
            label: LoginStatus.blocked.displayName,
            count: blockedCount,
            isSelected: selectedFilter == context.l10n.blocked,
            color: Theme.of(context).colorScheme.warning,
            onTap: () => onFilterChanged('blocked'),
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
  final Color? color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? chipColor : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? chipColor
                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: chipColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(
                        context,
                      ).colorScheme.onPrimary.withValues(alpha: 0.2)
                    : chipColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count.toString(),
                style: AppTextStyles.labelSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : chipColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
