import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/super_admin/domain/entities/platform_statistics_entity.dart';
import 'package:spo_kick/features/super_admin/domain/repositories/super_admin_repository.dart';

/// Use case for getting platform-wide statistics.
///
/// Retrieves comprehensive platform metrics for super admin dashboard.
/// Shows users, admins, fields, bookings, and revenue statistics.
///
/// Usage:
/// ```dart
/// final useCase = GetPlatformStatisticsUseCase(repository);
/// final result = await useCase();
///
/// result.fold(
///   (failure) => showError(failure.message),
///   (stats) => displayDashboard(stats),
/// );
/// ```
class GetPlatformStatisticsUseCase {
  final SuperAdminRepository repository;

  GetPlatformStatisticsUseCase(this.repository);

  /// Execute the use case.
  ///
  /// Returns:
  /// - [Right(PlatformStatisticsEntity)]: Statistics loaded successfully
  /// - [Left(Failure)]: Error occurred
  Future<Either<Failure, PlatformStatisticsEntity>> call() async {
    return await repository.getPlatformStatistics();
  }
}
