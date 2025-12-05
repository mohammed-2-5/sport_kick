import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/fields/presentation/cubit/map_state.dart';

/// Filter dialog for the map page.
///
/// Allows filtering fields by:
/// - Verified only
/// - Minimum rating
/// - Maximum price
/// - Surface type
class MapFilterDialog extends StatefulWidget {
  final MapFilters initialFilters;
  final ValueChanged<MapFilters> onApply;

  const MapFilterDialog({
    super.key,
    required this.initialFilters,
    required this.onApply,
  });

  @override
  State<MapFilterDialog> createState() => _MapFilterDialogState();
}

class _MapFilterDialogState extends State<MapFilterDialog> {
  late bool _verifiedOnly;
  late double? _minRating;
  late double? _maxPrice;
  late String? _surfaceType;
  late bool _sortByDistance;

  @override
  void initState() {
    super.initState();
    _verifiedOnly = widget.initialFilters.verifiedOnly;
    _minRating = widget.initialFilters.minRating;
    _maxPrice = widget.initialFilters.maxPrice;
    _surfaceType = widget.initialFilters.surfaceType;
    _sortByDistance = widget.initialFilters.sortByDistance;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter Fields',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Verified Only
            SwitchListTile(
              title: const Text('Verified Fields Only'),
              subtitle: const Text('Show only verified fields'),
              value: _verifiedOnly,
              activeColor: AppColors.primary,
              contentPadding: EdgeInsets.zero,
              onChanged: (value) {
                setState(() => _verifiedOnly = value);
              },
            ),
            const Divider(),

            // Sort by Distance
            SwitchListTile(
              title: const Text('Sort by Distance'),
              subtitle: const Text('Show nearest fields first'),
              value: _sortByDistance,
              activeColor: AppColors.primary,
              contentPadding: EdgeInsets.zero,
              onChanged: (value) {
                setState(() => _sortByDistance = value);
              },
            ),
            const Divider(),

            // Minimum Rating
            const Text(
              'Minimum Rating',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [null, 3.0, 3.5, 4.0, 4.5].map((rating) {
                final isSelected = _minRating == rating;
                return FilterChip(
                  label: Text(rating == null ? 'Any' : '$rating+'),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() => _minRating = rating);
                  },
                  selectedColor: AppColors.primary.withValues(alpha: 0.2),
                  checkmarkColor: AppColors.primary,
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Maximum Price
            const Text(
              'Maximum Price (per hour)',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [null, 100.0, 200.0, 300.0, 500.0].map((price) {
                final isSelected = _maxPrice == price;
                return FilterChip(
                  label: Text(price == null ? 'Any' : '${price.toInt()} EGP'),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() => _maxPrice = price);
                  },
                  selectedColor: AppColors.primary.withValues(alpha: 0.2),
                  checkmarkColor: AppColors.primary,
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Surface Type
            const Text(
              'Surface Type',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [null, 'Grass', 'Turf', 'Indoor'].map((surface) {
                final isSelected = _surfaceType == surface;
                return FilterChip(
                  label: Text(surface ?? 'Any'),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() => _surfaceType = surface);
                  },
                  selectedColor: AppColors.primary.withValues(alpha: 0.2),
                  checkmarkColor: AppColors.primary,
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _verifiedOnly = false;
                        _minRating = null;
                        _maxPrice = null;
                        _surfaceType = null;
                        _sortByDistance = false;
                      });
                    },
                    child: const Text('Clear All'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onApply(
                        MapFilters(
                          verifiedOnly: _verifiedOnly,
                          minRating: _minRating,
                          maxPrice: _maxPrice,
                          surfaceType: _surfaceType,
                          sortByDistance: _sortByDistance,
                        ),
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
