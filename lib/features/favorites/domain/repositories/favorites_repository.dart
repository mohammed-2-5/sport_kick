import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';

/// Repository interface for favorites operations.
///
/// Defines the contract for managing user's favorite fields.
/// Implementation is in the data layer.
abstract class FavoritesRepository {
  /// Get list of all favorite field IDs for the current user.
  ///
  /// Returns [Right] with list of field IDs on success.
  /// Returns [Left] with [CacheFailure] on error.
  Future<Either<Failure, List<String>>> getFavoriteFieldIds();

  /// Check if a specific field is in favorites.
  ///
  /// [fieldId] - The field ID to check.
  ///
  /// Returns [Right] with true if field is favorited, false otherwise.
  /// Returns [Left] with [CacheFailure] on error.
  Future<Either<Failure, bool>> isFavorite(String fieldId);

  /// Add a field to favorites.
  ///
  /// [fieldId] - The field ID to add.
  ///
  /// Returns [Right] with void on success.
  /// Returns [Left] with [CacheFailure] on error.
  ///
  /// Note: If field is already in favorites, this is a no-op.
  Future<Either<Failure, void>> addToFavorites(String fieldId);

  /// Remove a field from favorites.
  ///
  /// [fieldId] - The field ID to remove.
  ///
  /// Returns [Right] with void on success.
  /// Returns [Left] with [CacheFailure] on error.
  ///
  /// Note: If field is not in favorites, this is a no-op.
  Future<Either<Failure, void>> removeFromFavorites(String fieldId);

  /// Clear all favorites.
  ///
  /// Returns [Right] with void on success.
  /// Returns [Left] with [CacheFailure] on error.
  Future<Either<Failure, void>> clearAllFavorites();
}
