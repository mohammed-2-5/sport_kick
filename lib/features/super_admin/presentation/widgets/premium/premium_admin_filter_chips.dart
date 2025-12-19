import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Premium filter chips for admin lists.
///
/// Features:
/// - Horizontal scrollable chips
/// - Gold gradient for selected state
/// - Count display
/// - Tap animation
class PremiumAdminFilterChips extends StatelessWidget {
  final String? selectedFilter;
  final Map<String, int> filterCounts;
  final ValueChanged<String?> onFilterSelected;

  const PremiumAdminFilterChips({
    super.key,
    this.selectedFilter,
    required this.filterCounts,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // All chip
          _FilterChip(
            label: 'All',
            count: filterCounts.values.fold(0, (a, b) => a + b),
            isSelected: selectedFilter == null,
            onTap: () {
              HapticFeedback.selectionClick();
              onFilterSelected(null);
            },
          ),
          const SizedBox(width: 8),
          // Dynamic chips from filterCounts
          ...filterCounts.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _FilterChip(
                label: entry.key,
                count: entry.value,
                isSelected: selectedFilter == entry.key,
                onTap: () {
                  HapticFeedback.selectionClick();
                  onFilterSelected(entry.key);
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// Individual filter chip.
class _FilterChip extends StatefulWidget {
  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.count,
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
      duration: const Duration(milliseconds: 100),
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
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            gradient: widget.isSelected
                ? const LinearGradient(
                    colors: [AppColors.premiumGold, AppColors.premiumGoldDark],
                  )
                : null,
            color: widget.isSelected ? null : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isSelected ? Colors.transparent : AppColors.border,
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: AppColors.premiumGold.withValues(alpha: 0.3),
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
                widget.label,
                style: AppTextStyles.labelMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: widget.isSelected
                      ? Colors.white
                      : AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: widget.isSelected
                      ? Colors.white.withValues(alpha: 0.2)
                      : AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${widget.count}',
                  style: AppTextStyles.labelSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: widget.isSelected
                        ? Colors.white
                        : AppColors.textSecondary,
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

/// Status filter chips specifically for user/admin status.
class PremiumStatusFilterChips extends StatelessWidget {
  final String? selectedStatus;
  final int allCount;
  final int activeCount;
  final int inactiveCount;
  final ValueChanged<String?> onStatusSelected;

  const PremiumStatusFilterChips({
    super.key,
    this.selectedStatus,
    required this.allCount,
    required this.activeCount,
    required this.inactiveCount,
    required this.onStatusSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumAdminFilterChips(
      selectedFilter: selectedStatus,
      filterCounts: {'Active': activeCount, 'Inactive': inactiveCount},
      onFilterSelected: onStatusSelected,
    );
  }
}
