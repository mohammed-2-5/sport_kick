import 'package:flutter/material.dart';
import 'package:spo_kick/features/fields/domain/entities/search_filters_entity.dart';
import 'package:spo_kick/features/fields/presentation/constants/search_constants.dart';
import 'package:spo_kick/features/fields/presentation/widgets/search/amenities_filter.dart';
import 'package:spo_kick/features/fields/presentation/widgets/search/price_range_filter.dart';
import 'package:spo_kick/features/fields/presentation/widgets/search/sort_selector.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Search Filter Bottom Sheet
///
/// Comprehensive filter UI for advanced search.
class SearchFilterBottomSheet extends StatefulWidget {
  final SearchFiltersEntity initialFilters;
  final ValueChanged<SearchFiltersEntity> onApply;

  const SearchFilterBottomSheet({
    required this.initialFilters,
    required this.onApply,
    super.key,
  });

  @override
  State<SearchFilterBottomSheet> createState() =>
      _SearchFilterBottomSheetState();
}

class _SearchFilterBottomSheetState extends State<SearchFilterBottomSheet> {
  late SearchFiltersEntity _filters;

  @override
  void initState() {
    super.initState();
    _filters = widget.initialFilters;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(SearchConstants.filterPadding),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(context),
          const SizedBox(height: SearchConstants.sectionSpacing),

          // Filters content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price Range
                  PriceRangeFilter(
                    minPrice:
                        _filters.minPrice ?? SearchConstants.minPriceValue,
                    maxPrice:
                        _filters.maxPrice ?? SearchConstants.maxPriceValue,
                    onChanged: (range) {
                      setState(() {
                        _filters = _filters.copyWith(
                          minPrice: range.start,
                          maxPrice: range.end,
                        );
                      });
                    },
                  ),
                  const SizedBox(height: SearchConstants.sectionSpacing),

                  // Amenities
                  AmenitiesFilter(
                    selectedAmenities: _filters.amenities ?? [],
                    onChanged: (amenities) {
                      setState(() {
                        _filters = _filters.copyWith(amenities: amenities);
                      });
                    },
                  ),
                  const SizedBox(height: SearchConstants.sectionSpacing),

                  // Sort Options
                  SortSelector(
                    selectedSort: _filters.sortBy,
                    onChanged: (sortBy) {
                      setState(() {
                        _filters = _filters.copyWith(sortBy: sortBy);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          // Actions
          const SizedBox(height: 16),
          _buildActions(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(Icons.filter_list, color: colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          context.l10n.filtersTitle,
          style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        if (_filters.hasActiveFilters)
          TextButton(
            onPressed: () {
              setState(() {
                _filters = _filters.clearAll();
              });
            },
            child: Text(context.l10n.reset),
          ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        // Active filters count
        if (_filters.hasActiveFilters)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, size: 16, color: colorScheme.primary),
                const SizedBox(width: 4),
                Text(
                  context.l10n.activeFiltersCount(
                    LocaleFormatters.formatNumber(
                      context,
                      _filters.activeFilterCount,
                    ),
                  ),
                  style: AppTextStyles.labelSmall.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        const Spacer(),
        // Apply button
        ElevatedButton(
          onPressed: () {
            widget.onApply(_filters);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            context.l10n.applyFilters,
            style: AppTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
