import 'package:flutter/material.dart';

/// Generic empty state widget for list views.
///
/// Displays an icon, title, and subtitle for empty states.
/// Supports different messages for filtered vs unfiltered empty states.
class GenericEmptyState extends StatelessWidget {
  /// Whether the empty state is due to active filters/search
  final bool hasFilters;

  /// Icon to display (defaults based on hasFilters if not provided)
  final IconData? icon;

  /// Title for unfiltered empty state
  final String emptyTitle;

  /// Title for filtered empty state
  final String filteredTitle;

  /// Subtitle for unfiltered empty state
  final String emptySubtitle;

  /// Subtitle for filtered empty state
  final String filteredSubtitle;

  /// Icon size (defaults to 80 for unfiltered, 64 for filtered)
  final double? iconSize;

  const GenericEmptyState({
    required this.hasFilters,
    this.icon,
    required this.emptyTitle,
    required this.filteredTitle,
    required this.emptySubtitle,
    required this.filteredSubtitle,
    this.iconSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // If no custom icon provided:
    // - With filters (search active): use search_off icon
    // - Without filters (truly empty): use inbox_outlined as generic fallback
    final displayIcon = icon ??
        (hasFilters ? Icons.search_off : Icons.inbox_outlined);
    final displayIconSize = iconSize ?? (hasFilters ? 64.0 : 80.0);
    final title = hasFilters ? filteredTitle : emptyTitle;
    final subtitle = hasFilters ? filteredSubtitle : emptySubtitle;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            displayIcon,
            size: displayIconSize,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
