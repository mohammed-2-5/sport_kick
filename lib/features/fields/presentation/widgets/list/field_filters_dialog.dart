import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_state.dart';
import 'package:spo_kick/features/fields/presentation/widgets/list/filter_widgets.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Advanced filters dialog for field search.
///
/// Allows users to filter fields by:
/// - Sport category
/// - Price range
/// - Rating
/// - Indoor/Outdoor
/// - Verified status
class FieldFiltersDialog extends StatefulWidget {
  final FieldFilterOptions? currentFilters;
  final List<String> categories;
  final Function(FieldFilterOptions) onApplyFilters;

  const FieldFiltersDialog({
    super.key,
    this.currentFilters,
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
  String? _indoorOutdoor;
  bool _verifiedOnly = false;

  @override
  void initState() {
    super.initState();
    _initializeFromCurrentFilters();
  }

  void _initializeFromCurrentFilters() {
    if (widget.currentFilters != null) {
      _selectedCategory = widget.currentFilters!.categoryId;
      _priceRange = RangeValues(
        widget.currentFilters!.minPrice ?? 0,
        widget.currentFilters!.maxPrice ?? 500,
      );
      _minRating = widget.currentFilters!.minRating ?? 0;
      if (widget.currentFilters!.isIndoor != null) {
        _indoorOutdoor = widget.currentFilters!.isIndoor!
            ? 'indoor'
            : 'outdoor';
      }
      _verifiedOnly = widget.currentFilters!.verifiedOnly;
    }
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
    final options = FieldFilterOptions(
      categoryId: _selectedCategory,
      minPrice: _priceRange.start > 0 ? _priceRange.start : null,
      maxPrice: _priceRange.end < 500 ? _priceRange.end : null,
      minRating: _minRating > 0 ? _minRating : null,
      isIndoor: _indoorOutdoor == 'indoor'
          ? true
          : _indoorOutdoor == 'outdoor'
          ? false
          : null,
      verifiedOnly: _verifiedOnly,
    );

    widget.onApplyFilters(options);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            Expanded(child: _buildFiltersContent()),
            const SizedBox(height: 20),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          context.l10n.filtersTitle,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  Widget _buildFiltersContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PriceRangeFilter(
            priceRange: _priceRange,
            onChanged: (values) => setState(() => _priceRange = values),
          ),
          const SizedBox(height: 24),
          RatingFilter(
            minRating: _minRating,
            onChanged: (value) => setState(() => _minRating = value),
          ),
          const SizedBox(height: 24),
          LocationTypeFilter(
            selectedType: _indoorOutdoor,
            onChanged: (type) => setState(() => _indoorOutdoor = type),
          ),
          const SizedBox(height: 24),
          VerificationFilter(
            verifiedOnly: _verifiedOnly,
            onChanged: (value) => setState(() => _verifiedOnly = value),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
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
            child: Text(context.l10n.reset),
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
            child: Text(context.l10n.applyFilters),
          ),
        ),
      ],
    );
  }
}
