import 'package:flutter/material.dart';
import 'package:spo_kick/features/fields/presentation/widgets/search/search_tip_item.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Search tips widget.
///
/// Displays helpful tips for searching fields when no search is active.
/// Includes search history if provided.
class SearchTips extends StatelessWidget {
  /// Search history items
  final List<String> searchHistory;

  /// Callback when a history item is tapped
  final void Function(String query)? onHistoryTap;

  /// Callback when a history item's remove button is tapped
  final void Function(String query)? onHistoryRemove;

  /// Callback when "Clear All" is tapped
  final VoidCallback? onClearHistory;

  const SearchTips({
    super.key,
    this.searchHistory = const [],
    this.onHistoryTap,
    this.onHistoryRemove,
    this.onClearHistory,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search History
          if (searchHistory.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.recentSearches,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: onClearHistory,
                  child: Text(context.l10n.clearAll),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...searchHistory.map(
              (query) => Builder(
                builder: (context) {
                  final colorScheme = Theme.of(context).colorScheme;
                  return ListTile(
                    leading: Icon(
                      Icons.history,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    title: Text(query),
                    trailing: IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => onHistoryRemove?.call(query),
                    ),
                    onTap: () => onHistoryTap?.call(query),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
          ],

          // Search Tips
          Center(
            child: Builder(
              builder: (context) {
                final colorScheme = Theme.of(context).colorScheme;
                return Column(
                  children: [
                    Icon(
                      Icons.search,
                      size: 64,
                      color: colorScheme.primary.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      context.l10n.searchForFields,
                      style: AppTextStyles.titleLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      context.l10n.searchByNameCityAddressDescription,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          SearchTipItem(
            icon: Icons.sports_soccer,
            title: context.l10n.searchTipFieldNameTitle,
            example: context.l10n.searchTipFieldNameExample,
          ),
          const SizedBox(height: 16),
          SearchTipItem(
            icon: Icons.location_city,
            title: context.l10n.searchTipCityTitle,
            example: context.l10n.searchTipCityExample,
          ),
          const SizedBox(height: 16),
          SearchTipItem(
            icon: Icons.location_on,
            title: context.l10n.searchTipAddressTitle,
            example: context.l10n.searchTipAddressExample,
          ),
        ],
      ),
    );
  }
}
