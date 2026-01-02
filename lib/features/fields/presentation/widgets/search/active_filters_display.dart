import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/fields/domain/entities/search_filters_entity.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/features/fields/presentation/utils/facility_localizer.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

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
      chips.add(
        _buildFilterChip(
          context,
          label:
              '${LocaleFormatters.formatNumber(context, min)} - ${LocaleFormatters.formatNumber(context, max)} EGP/${context.l10n.perHour}',
          icon: Icons.attach_money,
          onRemove: () {
            onFilterRemoved(filters.copyWith(clearPriceRange: true));
          },
        ),
      );
    }

    // City chip
    if (filters.city != null) {
      chips.add(
        _buildFilterChip(
          context,
          label: filters.city!,
          icon: Icons.location_city,
          onRemove: () {
            onFilterRemoved(filters.copyWith(clearCity: true));
          },
        ),
      );
    }

    // Category chip
    if (filters.categoryId != null) {
      chips.add(
        _buildFilterChip(
          context,
          label: context.l10n.category,
          icon: Icons.sports_soccer,
          onRemove: () {
            onFilterRemoved(filters.copyWith(clearCategory: true));
          },
        ),
      );
    }

    // Amenities chips
    if (filters.amenities != null && filters.amenities!.isNotEmpty) {
      for (final amenity in filters.amenities!) {
        chips.add(
          _buildFilterChip(
            context,
            label: FacilityLocalizer.localize(context, amenity),
            icon: Icons.star,
            onRemove: () {
              final updated = List<String>.from(filters.amenities!);
              updated.remove(amenity);
              onFilterRemoved(filters.copyWith(amenities: updated));
            },
          ),
        );
      }
    }

    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final errorColor = isDark ? AppColors.darkError : AppColors.error;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: Wrap(spacing: 8, runSpacing: 8, children: chips)),
          const SizedBox(width: 8),
          TextButton.icon(
            onPressed: onClearAll,
            icon: const Icon(Icons.clear_all, size: 16),
            label: Text(context.l10n.clearAll),
            style: TextButton.styleFrom(
              foregroundColor: errorColor,
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
    final colorScheme = Theme.of(context).colorScheme;

    return Chip(
      avatar: Icon(icon, size: 16, color: colorScheme.primary),
      label: Text(label),
      deleteIcon: const Icon(Icons.close, size: 16),
      onDeleted: onRemove,
      backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
      labelStyle: AppTextStyles.labelSmall.copyWith(
        color: colorScheme.primary,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      visualDensity: VisualDensity.compact,
    );
  }
}
