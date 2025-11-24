import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/exceptions.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/fields/data/datasources/field_remote_datasource.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/sport_category_entity.dart';
import 'package:spo_kick/features/fields/domain/repositories/field_repository.dart';

/// Implementation of [FieldRepository].
///
/// Coordinates field-related operations and handles error mapping
/// from exceptions to failures.
class FieldRepositoryImpl implements FieldRepository {
  final FieldRemoteDataSource remoteDataSource;

  const FieldRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<FieldEntity>>> getAllFields() async {
    try {
      final fields = await remoteDataSource.getAllFields();
      return Right(fields);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, FieldEntity>> getFieldById(String fieldId) async {
    try {
      final field = await remoteDataSource.getFieldById(fieldId);
      return Right(field);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<FieldEntity>>> searchFields(String query) async {
    try {
      final fields = await remoteDataSource.searchFields(query);
      return Right(fields);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<FieldEntity>>> getFieldsByCategory(
    String categoryId,
  ) async {
    try {
      final fields = await remoteDataSource.getFieldsByCategory(categoryId);
      return Right(fields);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<FieldEntity>>> getFieldsByCity(
    String city,
  ) async {
    try {
      final fields = await remoteDataSource.getFieldsByCity(city);
      return Right(fields);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<FieldEntity>>> getFeaturedFields() async {
    try {
      final fields = await remoteDataSource.getFeaturedFields();
      return Right(fields);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<FieldEntity>>> getPopularFields({
    int limit = 10,
  }) async {
    try {
      final fields = await remoteDataSource.getPopularFields(limit: limit);
      return Right(fields);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<FieldEntity>>> getFieldsByOwner(
    String ownerId,
  ) async {
    try {
      final fields = await remoteDataSource.getFieldsByOwner(ownerId);
      return Right(fields);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<SportCategoryEntity>>>
      getSportCategories() async {
    try {
      final categories = await remoteDataSource.getSportCategories();
      return Right(categories);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, SportCategoryEntity>> getSportCategoryById(
    String categoryId,
  ) async {
    try {
      final category =
          await remoteDataSource.getSportCategoryById(categoryId);
      return Right(category);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<FieldEntity>>> filterFields({
    String? categoryId,
    String? city,
    double? minPrice,
    double? maxPrice,
    List<String>? amenities,
  }) async {
    try {
      final fields = await remoteDataSource.filterFields(
        categoryId: categoryId,
        city: city,
        minPrice: minPrice,
        maxPrice: maxPrice,
        amenities: amenities,
      );
      return Right(fields);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
}
