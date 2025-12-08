import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/core/widgets/premium/premium_search_bar.dart';
import 'package:spo_kick/features/fields/presentation/widgets/fields_favorites_button.dart';
import 'package:spo_kick/features/fields/presentation/widgets/fields_filter_button.dart';
import 'package:spo_kick/features/home/presentation/widgets/city_dropdown_widget.dart';

/// Custom header widget for fields list page.
///
/// Uses [PremiumCurvedHeader] with:
/// - Back button
/// - City dropdown in trailing slot
/// - Favorites button
/// - Floating search bar with filter
class FieldsListHeader extends StatelessWidget {
  /// Controller for the search field
  final TextEditingController searchController;

  /// Callback when filter button is pressed
  final VoidCallback? onFilter;

  /// Callback when search text changes
  final ValueChanged<String>? onSearchChanged;

  const FieldsListHeader({
    super.key,
    required this.searchController,
    this.onFilter,
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCurvedHeader(
      title: 'Browse Fields',
      showBackButton: true,
      height: 220,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CityDropdownWidget(),
          const SizedBox(width: 8),
          FieldsFavoritesButton(
            onPressed: () => context.pushNamed('favorites'),
          ),
        ],
      ),
      bottom: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            Expanded(
              child: PremiumSearchBar(
                hint: 'Search fields...',
                controller: searchController,
                onChanged: onSearchChanged,
              ),
            ),
            const SizedBox(width: 12),
            FieldsFilterButton(onPressed: onFilter),
          ],
        ),
      ),
    );
  }
}
