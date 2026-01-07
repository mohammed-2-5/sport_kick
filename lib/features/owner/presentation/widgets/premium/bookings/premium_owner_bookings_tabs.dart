import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Premium tab bar for owner bookings filtering.
///
/// Features:
/// - Glass effect tabs
/// - Status-based colors
/// - Smooth animations
/// - Badge counts
class PremiumOwnerBookingsTabs extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChanged;
  final Map<String, int> stats;

  const PremiumOwnerBookingsTabs({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
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
          _TabItem(
            label: context.l10n.all,
            count: stats[context.l10n.total2] ?? 0,
            isSelected: selectedIndex == 0,
            onTap: () => onTabChanged(0),
          ),
          _TabItem(
            label: context.l10n.pending,
            count: stats[context.l10n.pendingStatus] ?? 0,
            isSelected: selectedIndex == 1,
            onTap: () => onTabChanged(1),
            color: Colors.orange,
          ),
          _TabItem(
            label: context.l10n.statusConfirmed,
            count: stats[context.l10n.confirmed] ?? 0,
            isSelected: selectedIndex == 2,
            onTap: () => onTabChanged(2),
            color: Colors.green,
          ),
          _TabItem(
            label: context.l10n.statusCanceled,
            count: stats[context.l10n.canceled] ?? 0,
            isSelected: selectedIndex == 3,
            onTap: () => onTabChanged(3),
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}

/// Individual tab item with glass effect.
class _TabItem extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const _TabItem({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tabColor = color ?? colorScheme.secondary;
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
                    colors: [tabColor, tabColor.withValues(alpha: 0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: tabColor.withValues(alpha: 0.3),
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
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : colorScheme.onSurfaceVariant,
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
                        : tabColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    count.toString(),
                    style: AppTextStyles.labelSmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : tabColor,
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
