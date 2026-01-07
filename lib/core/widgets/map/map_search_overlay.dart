import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/map_location_picker_constants.dart';
import 'package:spo_kick/core/models/location_data.dart';
import 'package:spo_kick/core/widgets/map/map_location_picker_widgets.dart';

/// Overlay widget for map search functionality.
///
/// Displays a search bar with geocoding autocomplete and location results.
/// Positioned at the top of the map with search results dropdown below.
///
/// Features:
/// - Text input with debounced search
/// - Loading indicator while searching
/// - Dropdown list of search results
/// - Clear button to reset search
///
/// Called by [MapLocationPicker] to handle address search UI.
class MapSearchOverlay extends StatelessWidget {
  /// Controller for the search text field.
  final TextEditingController searchController;

  /// Focus node for managing keyboard focus.
  final FocusNode searchFocusNode;

  /// Search results from Nominatim geocoding service.
  final List<LocationData> searchResults;

  /// Whether search is currently in progress.
  final bool isSearching;

  /// Whether to show the search results dropdown.
  final bool showSearchResults;

  /// Called when search text changes with debounce.
  final ValueChanged<String> onSearchChanged;

  /// Called when a search result is selected.
  final ValueChanged<LocationData> onSearchResultSelected;

  const MapSearchOverlay({
    super.key,
    required this.searchController,
    required this.searchFocusNode,
    required this.searchResults,
    required this.isSearching,
    required this.showSearchResults,
    required this.onSearchChanged,
    required this.onSearchResultSelected,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Positioned(
      top: topPadding + 60,
      left: MapLocationPickerConstants.horizontalPadding,
      right: MapLocationPickerConstants.horizontalPadding,
      child: Column(
        children: [
          // Search bar
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              borderRadius: BorderRadius.circular(
                MapLocationPickerConstants.searchBarRadius,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: searchController,
              focusNode: searchFocusNode,
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: MapLocationPickerConstants.searchHint,
                hintStyle: const TextStyle(color: AppColors.lightTextSecondary),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.accentCyan,
                ),
                suffixIcon: _buildSuffixIcon(),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            ),
          ),

          // Search results dropdown
          if (showSearchResults && searchResults.isNotEmpty)
            _buildSearchResultsDropdown(),
        ],
      ),
    );
  }

  /// Builds the suffix icon for the search field.
  ///
  /// Shows:
  /// - Loading spinner if search is in progress
  /// - Clear button if text is entered
  /// - Nothing if field is empty
  Widget? _buildSuffixIcon() {
    if (isSearching) {
      return const Padding(
        padding: EdgeInsets.all(14),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (searchController.text.isNotEmpty) {
      return IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          searchController.clear();
          onSearchChanged('');
        },
      );
    }

    return null;
  }

  /// Builds the dropdown container for search results.
  Widget _buildSearchResultsDropdown() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      constraints: const BoxConstraints(maxHeight: 200),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(
          MapLocationPickerConstants.borderRadius,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: searchResults.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (_, index) {
          return MapSearchResultItem(
            location: searchResults[index],
            onTap: () => onSearchResultSelected(searchResults[index]),
          );
        },
      ),
    );
  }
}
