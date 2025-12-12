import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/auth/domain/entities/login_activity_entity.dart';
import 'package:spo_kick/features/auth/domain/repositories/login_activity_repository.dart';

/// Get Login Activity Use Case
///
/// Retrieves login activity for a specific user.
class GetLoginActivityUseCase {
  final LoginActivityRepository _repository;

  GetLoginActivityUseCase(this._repository);

  Future<Either<Failure, List<LoginActivityEntity>>> call(
    String userId, {
    int limit = 20,
    int offset = 0,
  }) {
    return _repository.getLoginActivity(userId, limit: limit, offset: offset);
  }
}

/// Get All Login Activity Use Case
///
/// Retrieves all login activity (for super admin).
class GetAllLoginActivityUseCase {
  final LoginActivityRepository _repository;

  GetAllLoginActivityUseCase(this._repository);

  Future<Either<Failure, List<LoginActivityEntity>>> call({
    int limit = 50,
    int offset = 0,
    String? statusFilter,
  }) {
    return _repository.getAllLoginActivity(
      limit: limit,
      offset: offset,
      statusFilter: statusFilter,
    );
  }
}
