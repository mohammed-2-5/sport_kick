import 'package:flutter/material.dart';
import 'package:spo_kick/features/fields/domain/entities/search_filters_entity.dart';

/// UI properties extension for SearchSortBy
///
/// Provides icons for sort options in the presentation layer.
/// This keeps the domain layer pure by separating UI concerns.
extension SearchSortByUIExtension on SearchSortBy {
  /// Icon for sort option display in UI
  IconData get icon {
    switch (this) {
      case SearchSortBy.relevance:
        return Icons.star;
      case SearchSortBy.priceLowToHigh:
      case SearchSortBy.priceHighToLow:
        return Icons.attach_money;
      case SearchSortBy.rating:
        return Icons.star_rate;
      case SearchSortBy.newest:
        return Icons.new_releases;
      case SearchSortBy.popular:
        return Icons.trending_up;
    }
  }
}
