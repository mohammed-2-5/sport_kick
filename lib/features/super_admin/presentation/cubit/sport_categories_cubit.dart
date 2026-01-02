import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/create_sport_category_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/delete_sport_category_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_all_sport_categories_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/update_sport_category_usecase.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/sport_categories_state.dart';

/// Cubit for managing sport categories.
///
/// Handles:
/// - Loading all categories
/// - Creating new categories
/// - Updating existing categories
/// - Deleting categories
class SportCategoriesCubit extends Cubit<SportCategoriesState> {
  final GetAllSportCategoriesUseCase _getAllSportCategoriesUseCase;
  final CreateSportCategoryUseCase _createSportCategoryUseCase;
  final UpdateSportCategoryUseCase _updateSportCategoryUseCase;
  final DeleteSportCategoryUseCase _deleteSportCategoryUseCase;

  SportCategoriesCubit({
    required GetAllSportCategoriesUseCase getAllSportCategoriesUseCase,
    required CreateSportCategoryUseCase createSportCategoryUseCase,
    required UpdateSportCategoryUseCase updateSportCategoryUseCase,
    required DeleteSportCategoryUseCase deleteSportCategoryUseCase,
  }) : _getAllSportCategoriesUseCase = getAllSportCategoriesUseCase,
       _createSportCategoryUseCase = createSportCategoryUseCase,
       _updateSportCategoryUseCase = updateSportCategoryUseCase,
       _deleteSportCategoryUseCase = deleteSportCategoryUseCase,
       super(const SportCategoriesInitial());

  /// Load all sport categories.
  Future<void> loadCategories() async {
    emit(const SportCategoriesLoading());

    final result = await _getAllSportCategoriesUseCase();

    result.fold(
      (failure) => emit(SportCategoriesError(message: failure.message)),
      (categories) => emit(SportCategoriesLoaded(categories: categories)),
    );
  }

  /// Create a new sport category.
  Future<void> createCategory({
    required String name,
    String? icon,
    String? description,
  }) async {
    final result = await _createSportCategoryUseCase(
      name: name,
      icon: icon,
      description: description,
    );

    result.fold(
      (failure) => emit(SportCategoriesError(message: failure.message)),
      (newCategory) async {
        // Reload categories to get updated list
        await loadCategories();
        if (state is SportCategoriesLoaded) {
          final currentState = state as SportCategoriesLoaded;
          emit(
            SportCategoryOperationSuccess(
              message: 'Processing...',
              updatedCategories: currentState.categories,
            ),
          );
        }
      },
    );
  }

  /// Update an existing sport category.
  Future<void> updateCategory({
    required String categoryId,
    String? name,
    String? icon,
    String? description,
  }) async {
    final result = await _updateSportCategoryUseCase(
      categoryId: categoryId,
      name: name,
      icon: icon,
      description: description,
    );

    result.fold(
      (failure) => emit(SportCategoriesError(message: failure.message)),
      (updatedCategory) async {
        // Reload categories to get updated list
        await loadCategories();
        if (state is SportCategoriesLoaded) {
          final currentState = state as SportCategoriesLoaded;
          emit(
            SportCategoryOperationSuccess(
              message: 'Processing...',
              updatedCategories: currentState.categories,
            ),
          );
        }
      },
    );
  }

  /// Delete a sport category.
  Future<void> deleteCategory({required String categoryId}) async {
    final result = await _deleteSportCategoryUseCase(categoryId: categoryId);

    result.fold(
      (failure) => emit(SportCategoriesError(message: failure.message)),
      (_) async {
        // Reload categories to get updated list
        await loadCategories();
        if (state is SportCategoriesLoaded) {
          final currentState = state as SportCategoriesLoaded;
          emit(
            SportCategoryOperationSuccess(
              message: 'Processing...',
              updatedCategories: currentState.categories,
            ),
          );
        }
      },
    );
  }

  /// Refresh categories list.
  Future<void> refresh() async {
    await loadCategories();
  }
}
