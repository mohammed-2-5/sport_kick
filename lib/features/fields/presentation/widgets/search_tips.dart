import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/fields/presentation/widgets/search_tip_item.dart';

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
                const Text(
                  'Recent Searches',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: onClearHistory,
                  child: const Text('Clear All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...searchHistory.map(
              (query) => ListTile(
                leading: const Icon(
                  Icons.history,
                  color: AppColors.textSecondary,
                ),
                title: Text(query),
                trailing: IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => onHistoryRemove?.call(query),
                ),
                onTap: () => onHistoryTap?.call(query),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
          ],

          // Search Tips
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.search,
                  size: 64,
                  color: AppColors.primary.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Search for fields',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Find fields by name, city, or address',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const SearchTipItem(
            icon: Icons.sports_soccer,
            title: 'Field Name',
            example: 'e.g., "Cairo Stadium", "Zamalek Arena"',
          ),
          const SizedBox(height: 16),
          const SearchTipItem(
            icon: Icons.location_city,
            title: 'City',
            example: 'e.g., "Cairo", "Alexandria", "Giza"',
          ),
          const SizedBox(height: 16),
          const SearchTipItem(
            icon: Icons.location_on,
            title: 'Address',
            example: 'e.g., "Nasr City", "Zamalek"',
          ),
        ],
      ),
    );
  }
}
