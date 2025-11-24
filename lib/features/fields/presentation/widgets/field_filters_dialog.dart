import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Advanced filters dialog for field search.
///
/// Allows users to filter fields by:
/// - Sport category
/// - Price range
/// - Rating
/// - Indoor/Outdoor
/// - Verified status
class FieldFiltersDialog extends StatefulWidget {
  final String? selectedCategoryId;
  final List<String> categories;
  final Function(Map<String, dynamic>) onApplyFilters;

  const FieldFiltersDialog({
    super.key,
    this.selectedCategoryId,
    required this.categories,
    required this.onApplyFilters,
  });

  @override
  State<FieldFiltersDialog> createState() => _FieldFiltersDialogState();
}

class _FieldFiltersDialogState extends State<FieldFiltersDialog> {
  String? _selectedCategory;
  RangeValues _priceRange = const RangeValues(0, 500);
  double _minRating = 0;
  String? _indoorOutdoor; // null, 'indoor', 'outdoor'
  bool _verifiedOnly = false;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.selectedCategoryId;
  }

  void _resetFilters() {
    setState(() {
      _selectedCategory = null;
      _priceRange = const RangeValues(0, 500);
      _minRating = 0;
      _indoorOutdoor = null;
      _verifiedOnly = false;
    });
  }

  void _applyFilters() {
    final filters = <String, dynamic>{
      'categoryId': _selectedCategory,
      'minPrice': _priceRange.start,
      'maxPrice': _priceRange.end,
      'minRating': _minRating,
      'isIndoor': _indoorOutdoor == 'indoor'
          ? true
          : _indoorOutdoor == 'outdoor'
              ? false
              : null,
      'verifiedOnly': _verifiedOnly,
    };

    widget.onApplyFilters(filters);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filters',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Filters content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Price Range
                    _buildSectionTitle('Price Range (per hour)'),
                    const SizedBox(height: 8),
                    RangeSlider(
                      values: _priceRange,
                      min: 0,
                      max: 500,
                      divisions: 10,
                      labels: RangeLabels(
                        '${_priceRange.start.round()} EGP',
                        '${_priceRange.end.round()} EGP',
                      ),
                      activeColor: AppColors.primary,
                      onChanged: (values) {
                        setState(() => _priceRange = values);
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_priceRange.start.round()} EGP',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          '${_priceRange.end.round()} EGP',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Minimum Rating
                    _buildSectionTitle('Minimum Rating'),
                    const SizedBox(height: 8),
                    Slider(
                      value: _minRating,
                      min: 0,
                      max: 5,
                      divisions: 10,
                      label: _minRating == 0
                          ? 'Any'
                          : '${_minRating.toStringAsFixed(1)} ⭐',
                      activeColor: AppColors.warning,
                      onChanged: (value) {
                        setState(() => _minRating = value);
                      },
                    ),
                    Center(
                      child: Text(
                        _minRating == 0
                            ? 'Any rating'
                            : '${_minRating.toStringAsFixed(1)} stars and above',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Indoor/Outdoor
                    _buildSectionTitle('Location Type'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildChoiceChip(
                            label: 'Any',
                            isSelected: _indoorOutdoor == null,
                            onSelected: () {
                              setState(() => _indoorOutdoor = null);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildChoiceChip(
                            label: 'Indoor',
                            icon: Icons.home,
                            isSelected: _indoorOutdoor == 'indoor',
                            onSelected: () {
                              setState(() => _indoorOutdoor = 'indoor');
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildChoiceChip(
                            label: 'Outdoor',
                            icon: Icons.wb_sunny,
                            isSelected: _indoorOutdoor == 'outdoor',
                            onSelected: () {
                              setState(() => _indoorOutdoor = 'outdoor');
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Verified Only
                    _buildSectionTitle('Verification'),
                    const SizedBox(height: 8),
                    CheckboxListTile(
                      value: _verifiedOnly,
                      onChanged: (value) {
                        setState(() => _verifiedOnly = value ?? false);
                      },
                      title: const Text('Show verified fields only'),
                      subtitle: const Text(
                        'Verified fields are confirmed by our team',
                        style: TextStyle(fontSize: 12),
                      ),
                      activeColor: AppColors.success,
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _resetFilters,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: const BorderSide(color: AppColors.primary),
                    ),
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildChoiceChip({
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
    IconData? icon,
  }) {
    return InkWell(
      onTap: onSelected,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : AppColors.primaryLight.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.primaryLight.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : AppColors.primary,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
