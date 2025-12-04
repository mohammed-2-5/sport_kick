import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/exceptions.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/business_hours/data/datasources/business_hours_remote_datasource.dart';
import 'package:spo_kick/features/business_hours/data/models/business_hours_model.dart';
import 'package:spo_kick/features/business_hours/domain/repositories/business_hours_repository.dart';

import '../../domain/entities/business_hours_entity.dart';

/// Implementation of [BusinessHoursRepository].
///
/// Handles business hours operations by delegating to the remote data source
/// and converting between domain entities and data models.
class BusinessHoursRepositoryImpl implements BusinessHoursRepository {
  final BusinessHoursRemoteDataSource remoteDataSource;

  const BusinessHoursRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<BusinessHoursEntity>>> getFieldBusinessHours(
    String fieldId,
  ) async {
    try {
      final models = await remoteDataSource.getFieldBusinessHours(fieldId);
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BusinessHoursEntity>> updateBusinessHours({
    required String fieldId,
    required int dayOfWeek,
    required bool isOpen,
    String? openingTime,
    String? closingTime,
  }) async {
    try {
      final model = await remoteDataSource.updateBusinessHours(
        fieldId: fieldId,
        dayOfWeek: dayOfWeek,
        isOpen: isOpen,
        openingTime: openingTime,
        closingTime: closingTime,
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BusinessHoursEntity>>>
  updateMultipleBusinessHours({
    required String fieldId,
    required Map<int, BusinessHoursEntity> updates,
  }) async {
    try {
      // Convert entities to models for data layer
      final modelUpdates = updates.map(
        (key, value) => MapEntry(key, _entityToModel(value)),
      );

      final models = await remoteDataSource.updateMultipleBusinessHours(
        fieldId: fieldId,
        updates: modelUpdates,
      );

      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> initializeDefaultBusinessHours(
    String fieldId,
  ) async {
    try {
      await remoteDataSource.initializeDefaultBusinessHours(fieldId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> validateBookingTime({
    required String fieldId,
    required DateTime bookingTime,
  }) async {
    try {
      final isValid = await remoteDataSource.validateBookingTime(
        fieldId: fieldId,
        bookingTime: bookingTime,
      );
      return Right(isValid);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isFieldCurrentlyOpen(String fieldId) async {
    try {
      final isOpen = await remoteDataSource.isFieldCurrentlyOpen(fieldId);
      return Right(isOpen);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DateTime?>> getNextOpeningTime({
    required String fieldId,
    DateTime? fromTime,
  }) async {
    try {
      final nextOpening = await remoteDataSource.getNextOpeningTime(
        fieldId: fieldId,
        fromTime: fromTime,
      );
      return Right(nextOpening);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Helper method to convert entity to model
  BusinessHoursModel _entityToModel(BusinessHoursEntity entity) {
    // Import the model at the top of file if needed
    // ignore: depend_on_referenced_packages
    // لو أحيانًا بيوصلك Model أصلاً، استخدمه مباشرة
    if (entity is BusinessHoursModel) return entity;

    // لو Entity عادية، حوّلها بالـ factory
    return BusinessHoursModel.fromEntity(entity);
  }
}
