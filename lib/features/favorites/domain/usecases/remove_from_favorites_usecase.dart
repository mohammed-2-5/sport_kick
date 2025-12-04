import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/favorites/domain/repositories/favorites_repository.dart';

/// Use case for removing a field from favorites.
///
/// When a user taps the favorite button on an already-favorited field,
/// this use case removes it from their favorites list.
class RemoveFromFavoritesUseCase {
  final FavoritesRepository repository;

  RemoveFromFavoritesUseCase(this.repository);

  /// Execute the use case.
  ///
  /// [fieldId] - The field ID to remove from favorites.
  ///
  /// Returns [Right] with void on success.
  /// Returns [Left] with [CacheFailure] if unable to save.
  ///
  /// Note: If field is not favorited, this is a no-op.
  Future<Either<Failure, void>> call(String fieldId) async {
    return await repository.removeFromFavorites(fieldId);
  }
}
