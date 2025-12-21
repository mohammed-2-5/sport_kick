import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/fields/presentation/cubit/map_state.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

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
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header - Close button only
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              // Scrollable content
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Verified Only
                      SwitchListTile(
                        title: Text(context.l10n.verifiedFieldsOnly),
                        subtitle: Text(context.l10n.verifiedFieldsDescription),
                        value: _verifiedOnly,
                        activeThumbColor: AppColors.primary,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (value) {
                          setState(() => _verifiedOnly = value);
                        },
                      ),
                      const Divider(),

                      // Sort by Distance
                      SwitchListTile(
                        title: Text(context.l10n.sortByDistance),
                        subtitle: Text(context.l10n.sortByDistanceDescription),
                        value: _sortByDistance,
                        activeThumbColor: AppColors.primary,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (value) {
                          setState(() => _sortByDistance = value);
                        },
                      ),
                      const Divider(),

                      // Minimum Rating
                      Text(
                        context.l10n.minimumRating,
                        style: AppTextStyles.titleSmall.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [null, 3.0, 3.5, 4.0, 4.5].map((rating) {
                          final isSelected = _minRating == rating;
                          return FilterChip(
                            label: Text(
                              rating == null
                                  ? context.l10n.anyOption
                                  : '${LocaleFormatters.formatNumber(context, rating, decimalDigits: rating % 1 == 0 ? 0 : 1)}+',
                            ),
                            selected: isSelected,
                            onSelected: (_) {
                              setState(() => _minRating = rating);
                            },
                            selectedColor: AppColors.primary.withValues(
                              alpha: 0.2,
                            ),
                            checkmarkColor: AppColors.primary,
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),

                      // Maximum Price
                      Text(
                        context.l10n.maximumPricePerHour,
                        style: AppTextStyles.titleSmall.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [null, 100.0, 200.0, 300.0, 500.0].map((
                          price,
                        ) {
                          final isSelected = _maxPrice == price;
                          return FilterChip(
                            label: Text(
                              price == null
                                  ? context.l10n.anyOption
                                  : '${LocaleFormatters.formatNumber(context, price, decimalDigits: 0)} EGP/${context.l10n.perHour}',
                            ),
                            selected: isSelected,
                            onSelected: (_) {
                              setState(() => _maxPrice = price);
                            },
                            selectedColor: AppColors.primary.withValues(
                              alpha: 0.2,
                            ),
                            checkmarkColor: AppColors.primary,
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),

                      // Surface Type
                      Text(
                        context.l10n.surfaceType,
                        style: AppTextStyles.titleSmall.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [null, 'Grass', 'Turf', 'Indoor'].map((
                          surface,
                        ) {
                          final isSelected = _surfaceType == surface;
                          final label = () {
                            switch (surface) {
                              case 'Grass':
                                return context.l10n.surfaceGrass;
                              case 'Turf':
                                return context.l10n.surfaceTurf;
                              case 'Indoor':
                                return context.l10n.indoor;
                              default:
                                return context.l10n.anyOption;
                            }
                          }();
                          return FilterChip(
                            label: Text(label),
                            selected: isSelected,
                            onSelected: (_) {
                              setState(() => _surfaceType = surface);
                            },
                            selectedColor: AppColors.primary.withValues(
                              alpha: 0.2,
                            ),
                            checkmarkColor: AppColors.primary,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Action Buttons - fixed at bottom
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
                      child: Text(context.l10n.clearAll),
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
                      child: Text(context.l10n.applyFilters),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
