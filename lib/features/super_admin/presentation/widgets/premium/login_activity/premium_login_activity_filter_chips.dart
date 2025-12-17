import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/auth/domain/entities/login_activity_entity.dart';

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
            label: 'All',
            count: allCount,
            isSelected: selectedFilter == 'all',
            onTap: () => onFilterChanged('all'),
          ),
          const SizedBox(width: 10),
          _FilterChip(
            label: LoginStatus.success.displayName,
            count: successCount,
            isSelected: selectedFilter == 'success',
            color: const Color(0xFF10B981),
            onTap: () => onFilterChanged('success'),
          ),
          const SizedBox(width: 10),
          _FilterChip(
            label: LoginStatus.failed.displayName,
            count: failedCount,
            isSelected: selectedFilter == 'failed',
            color: const Color(0xFFEF4444),
            onTap: () => onFilterChanged('failed'),
          ),
          const SizedBox(width: 10),
          _FilterChip(
            label: LoginStatus.blocked.displayName,
            count: blockedCount,
            isSelected: selectedFilter == 'blocked',
            color: const Color(0xFFF59E0B),
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
    final chipColor = color ?? AppColors.navyDeep;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? chipColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? chipColor : AppColors.divider,
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
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.2)
                    : chipColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : chipColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
