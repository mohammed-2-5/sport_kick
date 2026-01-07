import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/sport_category_entity.dart';

/// Filter options for fields.
class FieldFilterOptions extends Equatable {
  final String? categoryId;
  final double? minPrice;
  final double? maxPrice;
  final double? minRating;
  final bool? isIndoor;
  final bool verifiedOnly;

  const FieldFilterOptions({
    this.categoryId,
    this.minPrice,
    this.maxPrice,
    this.minRating,
    this.isIndoor,
    this.verifiedOnly = false,
  });

  bool get isActive =>
      categoryId != null ||
      minPrice != null ||
      maxPrice != null ||
      minRating != null ||
      isIndoor != null ||
      verifiedOnly;

  @override
  List<Object?> get props => [
    categoryId,
    minPrice,
    maxPrice,
    minRating,
    isIndoor,
    verifiedOnly,
  ];
}

/// Base state for fields feature.
sealed class FieldsState extends Equatable {
  const FieldsState();

  @override
  List<Object?> get props => [];
}

/// Initial state - no data loaded yet.
class FieldsInitial extends FieldsState {
  const FieldsInitial();
}

/// Loading state - data is being fetched.
class FieldsLoading extends FieldsState {
  const FieldsLoading();
}

/// Fields loaded successfully.
class FieldsLoaded extends FieldsState {
  final List<FieldEntity> fields;
  final List<SportCategoryEntity> categories;
  final FieldFilterOptions filterOptions;
  final String? searchQuery;
  final String? currentCityId;

  const FieldsLoaded({
    required this.fields,
    required this.categories,
    this.filterOptions = const FieldFilterOptions(),
    this.searchQuery,
    this.currentCityId,
  });

  /// Get filtered fields based on ALL active filters and search query.
  List<FieldEntity> get filteredFields {
    return fields.where((field) {
      // 1. Search Query
      if (searchQuery != null && searchQuery!.isNotEmpty) {
        final query = searchQuery!.toLowerCase();
        final matchesName = field.name.toLowerCase().contains(query);
        final matchesAddress = field.address.toLowerCase().contains(query);
        if (!matchesName && !matchesAddress) return false;
      }

      // City filter is handled at the fetch level (fields only contains current city fields)

      // 3. Category
      if (filterOptions.categoryId != null &&
          field.sportCategoryId != filterOptions.categoryId) {
        return false;
      }

      // 4. Price
      if (filterOptions.minPrice != null &&
          field.pricePerHour < filterOptions.minPrice!) {
        return false;
      }
      if (filterOptions.maxPrice != null &&
          field.pricePerHour > filterOptions.maxPrice!) {
        return false;
      }

      // 5. Rating
      if (filterOptions.minRating != null) {
        final rating = field.averageRating ?? 0.0;
        if (rating < filterOptions.minRating!) {
          return false;
        }
      }

      // 6. Indoor/Outdoor
      if (filterOptions.isIndoor != null &&
          field.isIndoor != filterOptions.isIndoor) {
        return false;
      }

      // 7. Verified
      if (filterOptions.verifiedOnly && !field.isVerified) {
        return false;
      }

      return true;
    }).toList();
  }

  /// Check if any filters are active.
  bool get hasActiveFilters =>
      filterOptions.isActive || (searchQuery?.isNotEmpty ?? false);

  /// Get selected category name.
  String? get selectedCategoryName {
    if (filterOptions.categoryId == null) return null;
    try {
      final category = categories.firstWhere(
        (cat) => cat.id == filterOptions.categoryId,
      );
      return category.name;
    } catch (_) {
      return null;
    }
  }

  @override
  List<Object?> get props => [
    fields,
    categories,
    filterOptions,
    searchQuery,
    currentCityId,
  ];

  /// Create a copy with modified properties.
  FieldsLoaded copyWith({
    List<FieldEntity>? fields,
    List<SportCategoryEntity>? categories,
    FieldFilterOptions? filterOptions,
    String? searchQuery,
    String? currentCityId,
    bool clearSearchQuery = false,
    bool clearFilters = false,
  }) {
    return FieldsLoaded(
      fields: fields ?? this.fields,
      categories: categories ?? this.categories,
      filterOptions: clearFilters
          ? const FieldFilterOptions()
          : (filterOptions ?? this.filterOptions),
      searchQuery: clearSearchQuery ? null : (searchQuery ?? this.searchQuery),
      currentCityId: currentCityId ?? this.currentCityId,
    );
  }
}

/// Field details loaded successfully.
class FieldDetailsLoaded extends FieldsState {
  final FieldEntity field;
  final SportCategoryEntity? category;

  const FieldDetailsLoaded({required this.field, this.category});

  @override
  List<Object?> get props => [field, category];
}

/// Error state - something went wrong.
class FieldsError extends FieldsState {
  final String message;

  const FieldsError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Empty state - no fields available.
class FieldsEmpty extends FieldsState {
  final String message;

  const FieldsEmpty({this.message = 'No fields available'});

  @override
  List<Object?> get props => [message];
}
