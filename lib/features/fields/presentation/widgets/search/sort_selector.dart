import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/fields/domain/entities/search_filters_entity.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Sort Selector Widget
///
/// Dropdown/list for selecting sort order.
class SortSelector extends StatelessWidget {
  final SearchSortBy selectedSort;
  final ValueChanged<SearchSortBy> onChanged;

  const SortSelector({
    required this.selectedSort,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.sortBy,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...SearchSortBy.values.map((sortOption) {
          final isSelected = selectedSort == sortOption;
          return RadioListTile<SearchSortBy>(
            value: sortOption,
            // ignore: deprecated_member_use
            groupValue: selectedSort,
            // ignore: deprecated_member_use
            onChanged: (value) {
              if (value != null) {
                onChanged(value);
              }
            },
            title: Row(
              children: [
                Icon(
                  sortOption.icon,
                  size: 20,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  sortOption.displayName(context.l10n),
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textPrimary,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
            activeColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
            dense: true,
          );
        }),
      ],
    );
  }
}
