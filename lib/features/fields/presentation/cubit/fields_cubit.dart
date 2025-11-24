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
class FieldsCubit extends Cubit<FieldsState> {
  final GetAllFieldsUseCase getAllFieldsUseCase;
  final GetFieldByIdUseCase getFieldByIdUseCase;
  final GetFieldsByCategoryUseCase getFieldsByCategoryUseCase;
  final GetFeaturedFieldsUseCase getFeaturedFieldsUseCase;
  final GetSportCategoriesUseCase getSportCategoriesUseCase;
  final SearchFieldsUseCase searchFieldsUseCase;

  FieldsCubit({
    required this.getAllFieldsUseCase,
    required this.getFieldByIdUseCase,
    required this.getFieldsByCategoryUseCase,
    required this.getFeaturedFieldsUseCase,
    required this.getSportCategoriesUseCase,
    required this.searchFieldsUseCase,
  }) : super(const FieldsInitial());

  /// Load all fields and sport categories.
  ///
  /// This is the main method to initialize the fields list screen.
  Future<void> loadAllFields() async {
    emit(const FieldsLoading());

    // Load both fields and categories in parallel
    final fieldsResult = await getAllFieldsUseCase();
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
            emit(FieldsLoaded(
              fields: fields,
              categories: const [],
            ));
          },
          (categories) {
            if (fields.isEmpty) {
              emit(const FieldsEmpty());
            } else {
              emit(FieldsLoaded(
                fields: fields,
                categories: categories,
              ));
            }
          },
        );
      },
    );
  }

  /// Load featured fields.
  ///
  /// Used for homepage/promotions.
  Future<void> loadFeaturedFields() async {
    emit(const FieldsLoading());

    final fieldsResult = await getFeaturedFieldsUseCase();
    final categoriesResult = await getSportCategoriesUseCase();

    fieldsResult.fold(
      (failure) {
        emit(FieldsError(failure.message));
      },
      (fields) {
        categoriesResult.fold(
          (failure) {
            emit(FieldsLoaded(
              fields: fields,
              categories: const [],
            ));
          },
          (categories) {
            if (fields.isEmpty) {
              emit(const FieldsEmpty(
                message: 'No featured fields available',
              ));
            } else {
              emit(FieldsLoaded(
                fields: fields,
                categories: categories,
              ));
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
        final categoryResult =
            await getSportCategoriesUseCase();

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
  Future<void> searchFields(String query) async {
    if (query.trim().isEmpty) {
      // If search is cleared, reload all fields
      await loadAllFields();
      return;
    }

    emit(const FieldsLoading());

    final result = await searchFieldsUseCase(query);

    result.fold(
      (failure) {
        emit(FieldsError(failure.message));
      },
      (fields) {
        emit(FieldsSearchResults(
          results: fields,
          query: query,
        ));
      },
    );
  }

  /// Filter fields by sport category.
  ///
  /// [categoryId] - Sport category ID, or null to show all
  Future<void> filterByCategory(String? categoryId) async {
    final currentState = state;

    // Only filter if we have loaded fields
    if (currentState is! FieldsLoaded) {
      await loadAllFields();
      return;
    }

    if (categoryId == null) {
      // Clear filter - reload all fields
      emit(currentState.copyWith(clearCategoryFilter: true));
      return;
    }

    emit(const FieldsLoading());

    final result = await getFieldsByCategoryUseCase(categoryId);

    result.fold(
      (failure) {
        emit(FieldsError(failure.message));
      },
      (fields) {
        if (fields.isEmpty) {
          emit(FieldsEmpty(
            message:
                'No ${currentState.selectedCategoryName ?? "fields"} available',
          ));
        } else {
          emit(currentState.copyWith(
            fields: fields,
            selectedCategoryId: categoryId,
          ));
        }
      },
    );
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
