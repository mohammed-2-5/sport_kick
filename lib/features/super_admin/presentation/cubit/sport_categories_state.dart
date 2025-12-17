import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/fields/domain/entities/sport_category_entity.dart';

/// Base state for sport categories management.
abstract class SportCategoriesState extends Equatable {
  const SportCategoriesState();

  @override
  List<Object?> get props => [];
}

/// Initial state.
class SportCategoriesInitial extends SportCategoriesState {
  const SportCategoriesInitial();
}

/// Loading state.
class SportCategoriesLoading extends SportCategoriesState {
  const SportCategoriesLoading();
}

/// Loaded state with categories list.
class SportCategoriesLoaded extends SportCategoriesState {
  final List<SportCategoryEntity> categories;

  const SportCategoriesLoaded({required this.categories});

  @override
  List<Object?> get props => [categories];
}

/// Error state.
class SportCategoriesError extends SportCategoriesState {
  final String message;

  const SportCategoriesError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Category operation success state.
class SportCategoryOperationSuccess extends SportCategoriesState {
  final String message;
  final List<SportCategoryEntity> updatedCategories;

  const SportCategoryOperationSuccess({
    required this.message,
    required this.updatedCategories,
  });

  @override
  List<Object?> get props => [message, updatedCategories];
}
