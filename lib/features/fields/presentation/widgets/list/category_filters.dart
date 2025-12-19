import 'package:flutter/material.dart';
import 'package:spo_kick/features/fields/domain/entities/sport_category_entity.dart';
import 'package:spo_kick/features/fields/presentation/widgets/list/category_chip.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Category filter chips widget for fields list.
///
/// Displays horizontal scrollable list of category chips
/// with "All" option at the start.
class CategoryFilters extends StatelessWidget {
  final List<SportCategoryEntity> categories;
  final String? selectedCategoryId;
  final ValueChanged<String?> onCategorySelected;

  const CategoryFilters({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: categories.length + 1, // +1 for "All" chip
        itemBuilder: (context, index) {
          if (index == 0) {
            // "All" chip
            return CategoryChip(
              label: context.l10n.anyOption,
              icon: '🏟️',
              isSelected: selectedCategoryId == null,
              onTap: () => onCategorySelected(null),
            );
          }

          final category = categories[index - 1];
          return CategoryChip(
            label: category.name,
            icon: category.icon ?? '⚽',
            isSelected: selectedCategoryId == category.id,
            onTap: () => onCategorySelected(category.id),
          );
        },
      ),
    );
  }
}
