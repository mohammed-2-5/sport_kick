import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Search Filters Entity
///
/// Encapsulates all filter criteria for advanced field search.
class SearchFiltersEntity extends Equatable {
  final String? query;
  final String? categoryId;
  final String? city;
  final String? cityId;
  final double? minPrice;
  final double? maxPrice;
  final List<String>? amenities;
  final SearchSortBy sortBy;
  final bool sortAscending;

  const SearchFiltersEntity({
    this.query,
    this.categoryId,
    this.city,
    this.cityId,
    this.minPrice,
    this.maxPrice,
    this.amenities,
    this.sortBy = SearchSortBy.relevance,
    this.sortAscending = true,
  });

  /// Check if any filters are active
  bool get hasActiveFilters =>
      categoryId != null ||
      city != null ||
      cityId != null ||
      minPrice != null ||
      maxPrice != null ||
      (amenities != null && amenities!.isNotEmpty);

  /// Count of active filters
  int get activeFilterCount {
    int count = 0;
    if (categoryId != null) count++;
    if (city != null || cityId != null) count++;
    if (minPrice != null || maxPrice != null) count++;
    if (amenities != null && amenities!.isNotEmpty) count++;
    return count;
  }

  /// Copy with updated values
  SearchFiltersEntity copyWith({
    String? query,
    String? categoryId,
    String? city,
    String? cityId,
    double? minPrice,
    double? maxPrice,
    List<String>? amenities,
    SearchSortBy? sortBy,
    bool? sortAscending,
    bool clearCategory = false,
    bool clearCity = false,
    bool clearPriceRange = false,
    bool clearAmenities = false,
  }) {
    return SearchFiltersEntity(
      query: query ?? this.query,
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      city: clearCity ? null : (city ?? this.city),
      cityId: clearCity ? null : (cityId ?? this.cityId),
      minPrice: clearPriceRange ? null : (minPrice ?? this.minPrice),
      maxPrice: clearPriceRange ? null : (maxPrice ?? this.maxPrice),
      amenities: clearAmenities ? null : (amenities ?? this.amenities),
      sortBy: sortBy ?? this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
    );
  }

  /// Clear all filters
  SearchFiltersEntity clearAll() {
    return const SearchFiltersEntity();
  }

  @override
  List<Object?> get props => [
        query,
        categoryId,
        city,
        cityId,
        minPrice,
        maxPrice,
        amenities,
        sortBy,
        sortAscending,
      ];
}

/// Sort options for search results
enum SearchSortBy {
  relevance,
  priceLowToHigh,
  priceHighToLow,
  rating,
  newest,
  popular,
}

/// Extension for user-friendly names
extension SearchSortByExtension on SearchSortBy {
  String get displayName {
    switch (this) {
      case SearchSortBy.relevance:
        return 'Relevance';
      case SearchSortBy.priceLowToHigh:
        return 'Price: Low to High';
      case SearchSortBy.priceHighToLow:
        return 'Price: High to Low';
      case SearchSortBy.rating:
        return 'Highest Rated';
      case SearchSortBy.newest:
        return 'Newest First';
      case SearchSortBy.popular:
        return 'Most Popular';
    }
  }

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
