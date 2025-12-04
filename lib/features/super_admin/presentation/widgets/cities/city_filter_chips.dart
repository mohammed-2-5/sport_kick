import 'package:flutter/material.dart';

class CityFilterChips extends StatelessWidget {
  final String selectedFilter;
  final int allCount;
  final int activeCount;
  final int inactiveCount;
  final ValueChanged<String> onFilterChanged;

  const CityFilterChips({
    required this.selectedFilter,
    required this.allCount,
    required this.activeCount,
    required this.inactiveCount,
    required this.onFilterChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildFilterChip(
            context,
            'All',
            'all',
            allCount,
            Icons.location_city,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            context,
            'Active',
            'active',
            activeCount,
            Icons.check_circle,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            context,
            'Inactive',
            'inactive',
            inactiveCount,
            Icons.cancel,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    String label,
    String value,
    int count,
    IconData icon,
  ) {
    final isSelected = selectedFilter == value;
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text('$label ($count)'),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) => onFilterChanged(value),
      selectedColor: Theme.of(
        context,
      ).colorScheme.primary.withValues(alpha: 0.2),
      checkmarkColor: Theme.of(context).colorScheme.primary,
    );
  }
}
