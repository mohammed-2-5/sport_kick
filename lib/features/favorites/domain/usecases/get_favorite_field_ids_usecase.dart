import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/favorites/domain/repositories/favorites_repository.dart';

/// Use case for getting all favorite field IDs.
///
/// Returns a list of field IDs that the user has marked as favorites.
/// This can be used to display the favorites page or filter field lists.
class GetFavoriteFieldIdsUseCase {
  final FavoritesRepository repository;

  GetFavoriteFieldIdsUseCase(this.repository);

  /// Execute the use case.
  ///
  /// Returns [Right] with list of favorite field IDs on success.
  /// Returns [Left] with [CacheFailure] if unable to retrieve favorites.
  Future<Either<Failure, List<String>>> call() async {
    return await repository.getFavoriteFieldIds();
  }
}
