import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/auth/domain/entities/login_activity_entity.dart';
import 'package:spo_kick/features/auth/domain/repositories/login_activity_repository.dart';

/// Log Login Activity Use Case
///
/// Records a login event for security monitoring.
class LogLoginActivityUseCase {
  final LoginActivityRepository _repository;

  LogLoginActivityUseCase(this._repository);

  Future<Either<Failure, void>> call({
    required String userId,
    required LoginStatus status,
    String? ipAddress,
    String? location,
  }) {
    return _repository.logLoginActivity(
      userId: userId,
      status: status,
      ipAddress: ipAddress,
      location: location,
    );
  }
}
