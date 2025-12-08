import 'package:equatable/equatable.dart';

/// Base class for all favorites states.
abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

/// Initial state when favorites feature is first loaded.
class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

/// Loading state when checking favorite status or loading favorites list.
class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

/// State when favorite status for a field has been checked.
///
/// Used in field detail pages to show the correct favorite icon.
class FavoriteStatusLoaded extends FavoritesState {
  final String fieldId;
  final bool isFavorite;

  const FavoriteStatusLoaded({required this.fieldId, required this.isFavorite});

  @override
  List<Object?> get props => [fieldId, isFavorite];
}

/// State when list of favorite field IDs has been loaded.
///
/// Used in favorites page to display the list of favorited fields.
class FavoritesListLoaded extends FavoritesState {
  final List<String> favoriteFieldIds;

  const FavoritesListLoaded({required this.favoriteFieldIds});

  @override
  List<Object?> get props => [favoriteFieldIds];

  /// Check if a specific field is in favorites.
  bool isFavorite(String fieldId) => favoriteFieldIds.contains(fieldId);

  /// Get the count of favorited fields.
  int get count => favoriteFieldIds.length;

  /// Check if favorites list is empty.
  bool get isEmpty => favoriteFieldIds.isEmpty;

  /// Filter a list of fields to only include favorites.
  List<T> filterFavorites<T>(List<T> fields, String Function(T) getId) {
    return fields
        .where((field) => favoriteFieldIds.contains(getId(field)))
        .toList();
  }
}

/// State when a field has been successfully toggled (added/removed).
///
/// This state includes both the updated favorite status and field ID
/// so the UI can react appropriately (show snackbar, update icon, etc.).
class FavoriteToggled extends FavoritesState {
  final String fieldId;
  final bool isFavorite;

  const FavoriteToggled({required this.fieldId, required this.isFavorite});

  @override
  List<Object?> get props => [fieldId, isFavorite];
}

/// Error state when favorites operation fails.
class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError({required this.message});

  @override
  List<Object?> get props => [message];
}
