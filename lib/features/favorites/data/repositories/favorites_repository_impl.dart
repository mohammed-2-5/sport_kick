import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/exceptions.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/favorites/data/datasources/favorites_local_datasource.dart';
import 'package:spo_kick/features/favorites/domain/repositories/favorites_repository.dart';

/// Implementation of [FavoritesRepository].
///
/// Uses [FavoritesLocalDataSource] to persist favorites to local storage.
/// Converts exceptions to failures for the domain layer.
class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource localDataSource;

  FavoritesRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<String>>> getFavoriteFieldIds() async {
    try {
      final favorites = await localDataSource.getFavoriteFieldIds();
      return Right(favorites);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite(String fieldId) async {
    try {
      final favorites = await localDataSource.getFavoriteFieldIds();
      final isFavorited = favorites.contains(fieldId);
      return Right(isFavorited);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> addToFavorites(String fieldId) async {
    try {
      // Get current favorites
      final favorites = await localDataSource.getFavoriteFieldIds();

      // Add field if not already present
      if (!favorites.contains(fieldId)) {
        favorites.add(fieldId);
        await localDataSource.saveFavoriteFieldIds(favorites);
      }

      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromFavorites(String fieldId) async {
    try {
      // Get current favorites
      final favorites = await localDataSource.getFavoriteFieldIds();

      // Remove field if present
      favorites.remove(fieldId);
      await localDataSource.saveFavoriteFieldIds(favorites);

      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> clearAllFavorites() async {
    try {
      await localDataSource.clearFavorites();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error: ${e.toString()}'));
    }
  }
}
