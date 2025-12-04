import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/fields/domain/entities/search_filters_entity.dart';

/// Active Filters Display
///
/// Shows currently active search filters as removable chips.
class ActiveFiltersDisplay extends StatelessWidget {
  final SearchFiltersEntity filters;
  final ValueChanged<SearchFiltersEntity> onFilterRemoved;
  final VoidCallback onClearAll;

  const ActiveFiltersDisplay({
    required this.filters,
    required this.onFilterRemoved,
    required this.onClearAll,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (!filters.hasActiveFilters) {
      return const SizedBox.shrink();
    }

    final chips = <Widget>[];

    // Price range chip
    if (filters.minPrice != null || filters.maxPrice != null) {
      final min = filters.minPrice?.toInt() ?? 0;
      final max = filters.maxPrice?.toInt() ?? 1000;
      chips.add(_buildFilterChip(
        context,
        label: '$min - $max EGP',
        icon: Icons.attach_money,
        onRemove: () {
          onFilterRemoved(filters.copyWith(clearPriceRange: true));
        },
      ));
    }

    // City chip
    if (filters.city != null) {
      chips.add(_buildFilterChip(
        context,
        label: filters.city!,
        icon: Icons.location_city,
        onRemove: () {
          onFilterRemoved(filters.copyWith(clearCity: true));
        },
      ));
    }

    // Category chip
    if (filters.categoryId != null) {
      chips.add(_buildFilterChip(
        context,
        label: 'Category',
        icon: Icons.sports_soccer,
        onRemove: () {
          onFilterRemoved(filters.copyWith(clearCategory: true));
        },
      ));
    }

    // Amenities chips
    if (filters.amenities != null && filters.amenities!.isNotEmpty) {
      for (final amenity in filters.amenities!) {
        chips.add(_buildFilterChip(
          context,
          label: amenity,
          icon: Icons.star,
          onRemove: () {
            final updated = List<String>.from(filters.amenities!);
            updated.remove(amenity);
            onFilterRemoved(filters.copyWith(amenities: updated));
          },
        ));
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: chips,
            ),
          ),
          const SizedBox(width: 8),
          TextButton.icon(
            onPressed: onClearAll,
            icon: const Icon(Icons.clear_all, size: 16),
            label: const Text('Clear'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onRemove,
  }) {
    return Chip(
      avatar: Icon(icon, size: 16, color: AppColors.primary),
      label: Text(label),
      deleteIcon: const Icon(Icons.close, size: 16),
      onDeleted: onRemove,
      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
      labelStyle: const TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      visualDensity: VisualDensity.compact,
    );
  }
}
