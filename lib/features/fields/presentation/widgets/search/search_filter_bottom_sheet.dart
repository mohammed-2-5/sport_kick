import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/fields/domain/entities/search_filters_entity.dart';
import 'package:spo_kick/features/fields/presentation/constants/search_constants.dart';
import 'package:spo_kick/features/fields/presentation/widgets/search/amenities_filter.dart';
import 'package:spo_kick/features/fields/presentation/widgets/search/price_range_filter.dart';
import 'package:spo_kick/features/fields/presentation/widgets/search/sort_selector.dart';

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
    return Container(
      padding: const EdgeInsets.all(SearchConstants.filterPadding),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
    return Row(
      children: [
        const Icon(Icons.filter_list, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          'Filters',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        if (_filters.hasActiveFilters)
          TextButton(
            onPressed: () {
              setState(() {
                _filters = _filters.clearAll();
              });
            },
            child: const Text(SearchConstants.resetFilters),
          ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        // Active filters count
        if (_filters.hasActiveFilters)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  '${_filters.activeFilterCount} active',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
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
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            SearchConstants.applyFilters,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
