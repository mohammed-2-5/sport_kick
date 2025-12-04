import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/favorites/domain/usecases/add_to_favorites_usecase.dart';
import 'package:spo_kick/features/favorites/domain/usecases/get_favorite_field_ids_usecase.dart';
import 'package:spo_kick/features/favorites/domain/usecases/is_favorite_usecase.dart';
import 'package:spo_kick/features/favorites/domain/usecases/remove_from_favorites_usecase.dart';
import 'package:spo_kick/features/favorites/presentation/cubit/favorites_state.dart';

/// Cubit for managing favorites state.
///
/// Handles checking favorite status, toggling favorites,
/// and loading the list of favorited fields.
class FavoritesCubit extends Cubit<FavoritesState> {
  final IsFavoriteUseCase isFavoriteUseCase;
  final AddToFavoritesUseCase addToFavoritesUseCase;
  final RemoveFromFavoritesUseCase removeFromFavoritesUseCase;
  final GetFavoriteFieldIdsUseCase getFavoriteFieldIdsUseCase;

  FavoritesCubit({
    required this.isFavoriteUseCase,
    required this.addToFavoritesUseCase,
    required this.removeFromFavoritesUseCase,
    required this.getFavoriteFieldIdsUseCase,
  }) : super(const FavoritesInitial());

  /// Check if a specific field is in favorites.
  ///
  /// [fieldId] - The field ID to check.
  ///
  /// Emits [FavoritesLoading] while checking.
  /// Emits [FavoriteStatusLoaded] with result on success.
  /// Emits [FavoritesError] on failure.
  Future<void> checkIsFavorite(String fieldId) async {
    emit(const FavoritesLoading());

    final result = await isFavoriteUseCase(fieldId);

    result.fold(
      (failure) => emit(FavoritesError(message: failure.message)),
      (isFavorite) =>
          emit(FavoriteStatusLoaded(fieldId: fieldId, isFavorite: isFavorite)),
    );
  }

  /// Toggle favorite status of a field.
  ///
  /// [fieldId] - The field ID to toggle.
  /// [currentStatus] - The current favorite status (true if favorited).
  ///
  /// If currently favorited, removes from favorites.
  /// If not favorited, adds to favorites.
  ///
  /// Emits [FavoriteToggled] on success with updated status.
  /// Emits [FavoritesError] on failure.
  Future<void> toggleFavorite(String fieldId, bool currentStatus) async {
    final result = currentStatus
        ? await removeFromFavoritesUseCase(fieldId)
        : await addToFavoritesUseCase(fieldId);

    result.fold(
      (failure) => emit(FavoritesError(message: failure.message)),
      (_) =>
          emit(FavoriteToggled(fieldId: fieldId, isFavorite: !currentStatus)),
    );
  }

  /// Load the complete list of favorite field IDs.
  ///
  /// Used in the favorites page to display all favorited fields.
  ///
  /// Emits [FavoritesLoading] while loading.
  /// Emits [FavoritesListLoaded] with field IDs on success.
  /// Emits [FavoritesError] on failure.
  Future<void> loadFavorites() async {
    emit(const FavoritesLoading());

    final result = await getFavoriteFieldIdsUseCase();

    result.fold(
      (failure) => emit(FavoritesError(message: failure.message)),
      (favoriteFieldIds) =>
          emit(FavoritesListLoaded(favoriteFieldIds: favoriteFieldIds)),
    );
  }

  /// Add a field to favorites without toggling.
  ///
  /// [fieldId] - The field ID to add.
  ///
  /// This is useful when you know the field is not favorited
  /// and want to add it directly (e.g., from a share action).
  ///
  /// Emits [FavoriteToggled] on success with isFavorite=true.
  /// Emits [FavoritesError] on failure.
  Future<void> addFavorite(String fieldId) async {
    final result = await addToFavoritesUseCase(fieldId);

    result.fold(
      (failure) => emit(FavoritesError(message: failure.message)),
      (_) => emit(FavoriteToggled(fieldId: fieldId, isFavorite: true)),
    );
  }

  /// Remove a field from favorites without toggling.
  ///
  /// [fieldId] - The field ID to remove.
  ///
  /// This is useful when you know the field is favorited
  /// and want to remove it directly (e.g., swipe to delete).
  ///
  /// Emits [FavoriteToggled] on success with isFavorite=false.
  /// Emits [FavoritesError] on failure.
  Future<void> removeFavorite(String fieldId) async {
    final result = await removeFromFavoritesUseCase(fieldId);

    result.fold(
      (failure) => emit(FavoritesError(message: failure.message)),
      (_) => emit(FavoriteToggled(fieldId: fieldId, isFavorite: false)),
    );
  }
}
