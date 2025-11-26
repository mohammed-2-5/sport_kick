import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/owner/domain/entities/owner_revenue_entity.dart';
import 'package:spo_kick/features/owner/domain/repositories/owner_repository.dart';

/// Use case to get revenue statistics for an owner
class GetOwnerRevenueUseCase {
  final OwnerRepository repository;

  GetOwnerRevenueUseCase(this.repository);

  /// Execute the use case
  ///
  /// Returns [OwnerRevenueEntity] containing revenue analytics
  /// for all fields owned by the specified owner
  Future<Either<Failure, OwnerRevenueEntity>> call({
    required String ownerId,
  }) async {
    return await repository.getOwnerRevenue(ownerId);
  }
}
