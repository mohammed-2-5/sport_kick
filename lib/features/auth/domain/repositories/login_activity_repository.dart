import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/auth/domain/entities/login_activity_entity.dart';

/// Login Activity Repository Interface
///
/// Defines the contract for login activity data operations.
abstract class LoginActivityRepository {
  /// Log a new login event.
  Future<Either<Failure, void>> logLoginActivity({
    required String userId,
    required LoginStatus status,
    String? ipAddress,
    String? location,
  });

  /// Get login activity for a specific user.
  Future<Either<Failure, List<LoginActivityEntity>>> getLoginActivity(
    String userId, {
    int limit = 20,
    int offset = 0,
  });

  /// Get all login activity (super admin only).
  Future<Either<Failure, List<LoginActivityEntity>>> getAllLoginActivity({
    int limit = 50,
    int offset = 0,
    String? statusFilter,
  });

  /// Delete old login activity.
  Future<Either<Failure, void>> deleteOldActivity(int daysOld);
}
