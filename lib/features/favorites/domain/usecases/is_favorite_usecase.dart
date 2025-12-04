import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/favorites/domain/repositories/favorites_repository.dart';

/// Use case for checking if a field is in favorites.
///
/// Used to display the correct favorite icon state (filled/outlined)
/// on field cards and detail pages.
class IsFavoriteUseCase {
  final FavoritesRepository repository;

  IsFavoriteUseCase(this.repository);

  /// Execute the use case.
  ///
  /// [fieldId] - The field ID to check.
  ///
  /// Returns [Right] with true if field is favorited, false otherwise.
  /// Returns [Left] with [CacheFailure] if unable to check favorite status.
  Future<Either<Failure, bool>> call(String fieldId) async {
    return await repository.isFavorite(fieldId);
  }
}
