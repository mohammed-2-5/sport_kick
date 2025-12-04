import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/favorites/domain/repositories/favorites_repository.dart';

/// Use case for adding a field to favorites.
///
/// When a user taps the favorite button on a field,
/// this use case adds it to their favorites list.
class AddToFavoritesUseCase {
  final FavoritesRepository repository;

  AddToFavoritesUseCase(this.repository);

  /// Execute the use case.
  ///
  /// [fieldId] - The field ID to add to favorites.
  ///
  /// Returns [Right] with void on success.
  /// Returns [Left] with [CacheFailure] if unable to save.
  ///
  /// Note: If field is already favorited, this is a no-op.
  Future<Either<Failure, void>> call(String fieldId) async {
    return await repository.addToFavorites(fieldId);
  }
}
