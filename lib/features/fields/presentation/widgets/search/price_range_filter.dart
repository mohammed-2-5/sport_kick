import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/fields/presentation/constants/search_constants.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Price Range Filter Widget
///
/// Slider for filtering fields by price range.
class PriceRangeFilter extends StatelessWidget {
  final double minPrice;
  final double maxPrice;
  final ValueChanged<RangeValues> onChanged;

  const PriceRangeFilter({
    required this.minPrice,
    required this.maxPrice,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.l10n.priceRange,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              '${LocaleFormatters.formatNumber(context, minPrice, decimalDigits: 0)} - ${LocaleFormatters.formatNumber(context, maxPrice, decimalDigits: 0)} EGP/${context.l10n.perHour}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        RangeSlider(
          values: RangeValues(minPrice, maxPrice),
          min: SearchConstants.minPriceValue,
          max: SearchConstants.maxPriceValue,
          divisions: (SearchConstants.maxPriceValue / SearchConstants.priceStep)
              .round(),
          labels: RangeLabels(
            LocaleFormatters.formatNumber(context, minPrice, decimalDigits: 0),
            LocaleFormatters.formatNumber(context, maxPrice, decimalDigits: 0),
          ),
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
      ],
    );
  }
}
