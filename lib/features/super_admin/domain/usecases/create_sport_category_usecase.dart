import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/fields/domain/entities/sport_category_entity.dart';
import 'package:spo_kick/features/super_admin/domain/repositories/super_admin_repository.dart';

/// Use case for creating a new sport category.
///
/// Creates a new sport type that can be assigned to fields.
/// Only super admin can perform this operation.
class CreateSportCategoryUseCase {
  final SuperAdminRepository repository;

  CreateSportCategoryUseCase(this.repository);

  Future<Either<Failure, SportCategoryEntity>> call({
    required String name,
    String? icon,
    String? description,
  }) async {
    return await repository.createSportCategory(
      name: name,
      icon: icon,
      description: description,
    );
  }
}
