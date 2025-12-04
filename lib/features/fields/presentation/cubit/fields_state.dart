import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/sport_category_entity.dart';

/// Base state for fields feature.
abstract class FieldsState extends Equatable {
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
  final String? selectedCategoryId;
  final String? searchQuery;
  final String? currentCityId;

  const FieldsLoaded({
    required this.fields,
    required this.categories,
    this.selectedCategoryId,
    this.searchQuery,
    this.currentCityId,
  });

  /// Get filtered fields based on selected category.
  List<FieldEntity> get filteredFields {
    if (selectedCategoryId == null) {
      return fields;
    }
    return fields
        .where((field) => field.sportCategoryId == selectedCategoryId)
        .toList();
  }

  /// Check if any filters are active.
  bool get hasActiveFilters =>
      selectedCategoryId != null || searchQuery != null;

  /// Get selected category name.
  String? get selectedCategoryName {
    if (selectedCategoryId == null) return null;
    try {
      final category = categories.firstWhere(
        (cat) => cat.id == selectedCategoryId,
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
    selectedCategoryId,
    searchQuery,
    currentCityId,
  ];

  /// Create a copy with modified properties.
  FieldsLoaded copyWith({
    List<FieldEntity>? fields,
    List<SportCategoryEntity>? categories,
    String? selectedCategoryId,
    String? searchQuery,
    String? currentCityId,
    bool clearCategoryFilter = false,
    bool clearSearchQuery = false,
    bool clearCityFilter = false,
  }) {
    return FieldsLoaded(
      fields: fields ?? this.fields,
      categories: categories ?? this.categories,
      selectedCategoryId: clearCategoryFilter
          ? null
          : (selectedCategoryId ?? this.selectedCategoryId),
      searchQuery: clearSearchQuery ? null : (searchQuery ?? this.searchQuery),
      currentCityId: clearCityFilter
          ? null
          : (currentCityId ?? this.currentCityId),
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

/// Search results loaded.
class FieldsSearchResults extends FieldsState {
  final List<FieldEntity> results;
  final String query;

  const FieldsSearchResults({required this.results, required this.query});

  /// Check if search returned no results.
  bool get isEmpty => results.isEmpty;

  @override
  List<Object?> get props => [results, query];
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
