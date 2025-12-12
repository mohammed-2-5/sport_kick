import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/auth/data/datasources/login_activity_datasource.dart';
import 'package:spo_kick/features/auth/data/models/login_activity_model.dart';
import 'package:spo_kick/features/auth/domain/entities/login_activity_entity.dart';
import 'package:spo_kick/features/auth/domain/repositories/login_activity_repository.dart';
import 'package:uuid/uuid.dart';

/// Login Activity Repository Implementation
class LoginActivityRepositoryImpl implements LoginActivityRepository {
  final LoginActivityDataSource _dataSource;

  LoginActivityRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, void>> logLoginActivity({
    required String userId,
    required LoginStatus status,
    String? ipAddress,
    String? location,
  }) async {
    try {
      final activity = LoginActivityModel(
        id: const Uuid().v4(),
        userId: userId,
        timestamp: DateTime.now(),
        ipAddress: ipAddress,
        deviceType: LoginActivityRemoteDataSource.getDeviceType(),
        deviceName: LoginActivityRemoteDataSource.getDeviceName(),
        location: location,
        status: status,
      );

      await _dataSource.logLoginActivity(activity);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to log login activity: $e'));
    }
  }

  @override
  Future<Either<Failure, List<LoginActivityEntity>>> getLoginActivity(
    String userId, {
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final activities = await _dataSource.getLoginActivity(
        userId,
        limit: limit,
        offset: offset,
      );
      return Right(activities);
    } catch (e) {
      return Left(ServerFailure('Failed to get login activity: $e'));
    }
  }

  @override
  Future<Either<Failure, List<LoginActivityEntity>>> getAllLoginActivity({
    int limit = 50,
    int offset = 0,
    String? statusFilter,
  }) async {
    try {
      final activities = await _dataSource.getAllLoginActivity(
        limit: limit,
        offset: offset,
        statusFilter: statusFilter,
      );
      return Right(activities);
    } catch (e) {
      return Left(ServerFailure('Failed to get all login activity: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteOldActivity(int daysOld) async {
    try {
      await _dataSource.deleteOldActivity(daysOld);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to delete old activity: $e'));
    }
  }
}
