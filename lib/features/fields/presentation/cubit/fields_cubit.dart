import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/fields/domain/usecases/get_all_fields_usecase.dart';
import 'package:spo_kick/features/fields/domain/usecases/get_field_by_id_usecase.dart';
import 'package:spo_kick/features/fields/domain/usecases/get_fields_by_category_usecase.dart';
import 'package:spo_kick/features/fields/domain/usecases/get_featured_fields_usecase.dart';
import 'package:spo_kick/features/fields/domain/usecases/get_sport_categories_usecase.dart';
import 'package:spo_kick/features/fields/domain/usecases/search_fields_usecase.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_state.dart';

import '../../domain/entities/sport_category_entity.dart';

/// Cubit for managing fields feature state.
///
/// Handles:
/// - Loading all fields
/// - Loading field details
/// - Searching fields
/// - Filtering by category
/// - Loading sport categories
/// - Tracking current city for filtering
class FieldsCubit extends Cubit<FieldsState> {
  final GetAllFieldsUseCase getAllFieldsUseCase;
  final GetFieldByIdUseCase getFieldByIdUseCase;
  final GetFieldsByCategoryUseCase getFieldsByCategoryUseCase;
  final GetFeaturedFieldsUseCase getFeaturedFieldsUseCase;
  final GetSportCategoriesUseCase getSportCategoriesUseCase;
  final SearchFieldsUseCase searchFieldsUseCase;

  /// Current city ID for filtering fields.
  String? _currentCityId;

  /// Get current city ID.
  String? get currentCityId => _currentCityId;

  FieldsCubit({
    required this.getAllFieldsUseCase,
    required this.getFieldByIdUseCase,
    required this.getFieldsByCategoryUseCase,
    required this.getFeaturedFieldsUseCase,
    required this.getSportCategoriesUseCase,
    required this.searchFieldsUseCase,
    String? initialCityId,
  }) : _currentCityId = initialCityId,
       super(const FieldsInitial());

  /// Set current city and reload fields.
  ///
  /// [cityId] - City ID to filter by, or null to show all cities.
  Future<void> setCurrentCity(String? cityId) async {
    _currentCityId = cityId;
    await loadAllFields();
  }

  /// Load all fields and sport categories.
  ///
  /// This is the main method to initialize the fields list screen.
  /// Uses the current city ID for filtering if set.
  Future<void> loadAllFields() async {
    emit(const FieldsLoading());

    // Load both fields and categories in parallel
    final fieldsResult = await getAllFieldsUseCase(cityId: _currentCityId);
    final categoriesResult = await getSportCategoriesUseCase();

    // Check results
    fieldsResult.fold(
      (failure) {
        emit(FieldsError(failure.message));
      },
      (fields) {
        categoriesResult.fold(
          (failure) {
            // If categories fail, still show fields
            emit(
              FieldsLoaded(
                fields: fields,
                categories: const [],
                currentCityId: _currentCityId,
              ),
            );
          },
          (categories) {
            if (fields.isEmpty) {
              emit(const FieldsEmpty());
            } else {
              emit(
                FieldsLoaded(
                  fields: fields,
                  categories: categories,
                  currentCityId: _currentCityId,
                ),
              );
            }
          },
        );
      },
    );
  }

  /// Load featured fields.
  ///
  /// Used for homepage/promotions.
  /// Uses the current city ID for filtering if set.
  Future<void> loadFeaturedFields() async {
    emit(const FieldsLoading());

    final fieldsResult = await getFeaturedFieldsUseCase(cityId: _currentCityId);
    final categoriesResult = await getSportCategoriesUseCase();

    fieldsResult.fold(
      (failure) {
        emit(FieldsError(failure.message));
      },
      (fields) {
        categoriesResult.fold(
          (failure) {
            emit(
              FieldsLoaded(
                fields: fields,
                categories: const [],
                currentCityId: _currentCityId,
              ),
            );
          },
          (categories) {
            if (fields.isEmpty) {
              emit(const FieldsEmpty(message: 'No featured fields available.'));
            } else {
              emit(
                FieldsLoaded(
                  fields: fields,
                  categories: categories,
                  currentCityId: _currentCityId,
                ),
              );
            }
          },
        );
      },
    );
  }

  /// Load field details by ID.
  ///
  /// Used for field details screen.
  Future<void> loadFieldDetails(String fieldId) async {
    emit(const FieldsLoading());

    final result = await getFieldByIdUseCase(fieldId);

    result.fold(
      (failure) {
        emit(FieldsError(failure.message));
      },
      (field) async {
        // Try to load the sport category for this field
        final categoryResult = await getSportCategoriesUseCase();

        categoryResult.fold(
          (failure) {
            // If category fails, still show field
            emit(FieldDetailsLoaded(field: field));
          },
          (categories) {
            // Find matching category
            SportCategoryEntity? category;
            try {
              category = categories.firstWhere(
                (cat) => cat.id == field.sportCategoryId,
              );
            } catch (e) {
              // Category not found, field will display without category
              category = null;
            }
            emit(FieldDetailsLoaded(field: field, category: category));
          },
        );
      },
    );
  }

  /// Search fields by query.
  ///
  /// Searches in field name, city, and address.
  /// Uses the current city ID for filtering if set.
  /// Search fields by query (Client-side filtering).
  ///
  /// Updates the search query in the state to filter the list.
  void searchFields(String query) {
    final currentState = state;
    if (currentState is FieldsLoaded) {
      emit(
        currentState.copyWith(
          searchQuery: query.isEmpty ? null : query,
          clearSearchQuery: query.isEmpty,
        ),
      );
    }
  }

  /// Apply advanced filters.
  ///
  /// Updates the filter options in the state.
  void applyFilters(FieldFilterOptions options) {
    final currentState = state;
    if (currentState is FieldsLoaded) {
      emit(currentState.copyWith(filterOptions: options));
    }
  }

  /// Filter fields by sport category.
  ///
  /// [categoryId] - Sport category ID, or null to show all
  /// Uses the current city ID for filtering if set.
  /// Filter fields by sport category.
  ///
  /// Convenience method that updates the active [FieldFilterOptions].
  void filterByCategory(String? categoryId) {
    final currentState = state;
    if (currentState is! FieldsLoaded) return;

    final currentOptions = currentState.filterOptions;

    // Create new options with updated category (keeping other filters)
    final newOptions = FieldFilterOptions(
      categoryId: categoryId,
      minPrice: currentOptions.minPrice,
      maxPrice: currentOptions.maxPrice,
      minRating: currentOptions.minRating,
      isIndoor: currentOptions.isIndoor,
      verifiedOnly: currentOptions.verifiedOnly,
    );

    emit(currentState.copyWith(filterOptions: newOptions));
  }

  /// Clear all filters and reload all fields.
  Future<void> clearFilters() async {
    await loadAllFields();
  }

  /// Refresh fields list.
  ///
  /// Useful for pull-to-refresh functionality.
  Future<void> refresh() async {
    await loadAllFields();
  }
}
