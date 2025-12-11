import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Premium filter chips for cities filtering.
///
/// Features:
/// - Animated selection with scale effect
/// - Count badges with glow
/// - Horizontal scrollable layout
/// - Haptic feedback on selection
class PremiumCityFilterChips extends StatelessWidget {
  /// Currently selected filter value.
  final String selectedFilter;

  /// Count of all cities.
  final int allCount;

  /// Count of active cities.
  final int activeCount;

  /// Count of inactive cities.
  final int inactiveCount;

  /// Callback when filter changes.
  final ValueChanged<String> onFilterChanged;

  const PremiumCityFilterChips({
    super.key,
    required this.selectedFilter,
    required this.allCount,
    required this.activeCount,
    required this.inactiveCount,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filters = [
      _FilterItem(
        id: 'all',
        label: 'All',
        count: allCount,
        color: AppColors.navyDeep,
      ),
      _FilterItem(
        id: 'active',
        label: 'Active',
        count: activeCount,
        color: const Color(0xFF10B981),
      ),
      _FilterItem(
        id: 'inactive',
        label: 'Inactive',
        count: inactiveCount,
        color: const Color(0xFFEF4444),
      ),
    ];

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter.id;
          return _FilterChip(
            filter: filter,
            isSelected: isSelected,
            onTap: () => onFilterChanged(filter.id),
          );
        },
      ),
    );
  }
}

/// Data class for filter items.
class _FilterItem {
  final String id;
  final String label;
  final int count;
  final Color color;

  const _FilterItem({
    required this.id,
    required this.label,
    required this.count,
    required this.color,
  });
}

/// Individual filter chip widget.
class _FilterChip extends StatefulWidget {
  final _FilterItem filter;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.filter,
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
      vsync: this,
      duration: const Duration(milliseconds: 100),
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
    final color = widget.filter.color;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: () {
        HapticFeedback.selectionClick();
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isSelected ? color : Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: widget.isSelected
                  ? color
                  : AppColors.border.withValues(alpha: 0.5),
              width: widget.isSelected ? 2 : 1,
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.3),
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
                widget.filter.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: widget.isSelected ? Colors.white : color,
                ),
              ),
              const SizedBox(width: 6),
              _CountBadge(
                count: widget.filter.count,
                isSelected: widget.isSelected,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Count badge widget.
class _CountBadge extends StatelessWidget {
  final int count;
  final bool isSelected;
  final Color color;

  const _CountBadge({
    required this.count,
    required this.isSelected,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.white.withValues(alpha: 0.25)
            : color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        count.toString(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: isSelected ? Colors.white : color,
        ),
      ),
    );
  }
}
