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
              emit(const FieldsEmpty(message: 'No featured fields available'));
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
  Future<void> searchFields(String query) async {
    if (query.trim().isEmpty) {
      // If search is cleared, reload all fields
      await loadAllFields();
      return;
    }

    emit(const FieldsLoading());

    final result = await searchFieldsUseCase(query, cityId: _currentCityId);

    result.fold(
      (failure) {
        emit(FieldsError(failure.message));
      },
      (fields) {
        emit(FieldsSearchResults(results: fields, query: query));
      },
    );
  }

  /// Filter fields by sport category.
  ///
  /// [categoryId] - Sport category ID, or null to show all
  /// Uses the current city ID for filtering if set.
  Future<void> filterByCategory(String? categoryId) async {
    final currentState = state;

    print('🔍 [FILTER] filterByCategory called with categoryId: $categoryId');

    // Only filter if we have loaded fields
    if (currentState is! FieldsLoaded) {
      print(
        '⚠️ [FILTER] State is not FieldsLoaded, loading all fields first...',
      );
      await loadAllFields();
      // After loading, call filterByCategory again
      if (categoryId != null) {
        await filterByCategory(categoryId);
      }
      return;
    }

    print(
      '📊 [FILTER] Current state has ${currentState.fields.length} total fields',
    );

    if (categoryId == null) {
      // Clear filter - show all fields
      print('🔄 [FILTER] Clearing category filter');
      emit(currentState.copyWith(clearCategoryFilter: true));
      return;
    }

    // Update the state with the selected category ID
    // The filteredFields getter will handle the actual filtering
    final newState = currentState.copyWith(selectedCategoryId: categoryId);

    print('✅ [FILTER] Setting selectedCategoryId to: $categoryId');
    print(
      '📋 [FILTER] Filtered fields count: ${newState.filteredFields.length}',
    );

    // Debug: Print all fields and their categories
    for (var field in currentState.fields) {
      final isMatch = field.sportCategoryId == categoryId;
      print(
        '   ${isMatch ? "✓" : "✗"} Field: ${field.name}, Category: ${field.sportCategoryId}',
      );
    }

    if (newState.filteredFields.isEmpty) {
      print('⚠️ [FILTER] No fields found for category: $categoryId');
    } else {
      print(
        '✅ [FILTER] Emitting state with ${newState.filteredFields.length} filtered fields',
      );
    }
    emit(newState);
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
