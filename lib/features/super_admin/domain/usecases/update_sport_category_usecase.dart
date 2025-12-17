import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/fields/domain/entities/sport_category_entity.dart';
import 'package:spo_kick/features/super_admin/domain/repositories/super_admin_repository.dart';

/// Use case for updating an existing sport category.
///
/// Updates category details like name, icon, or description.
/// Only super admin can perform this operation.
class UpdateSportCategoryUseCase {
  final SuperAdminRepository repository;

  UpdateSportCategoryUseCase(this.repository);

  Future<Either<Failure, SportCategoryEntity>> call({
    required String categoryId,
    String? name,
    String? icon,
    String? description,
  }) async {
    return await repository.updateSportCategory(
      categoryId: categoryId,
      name: name,
      icon: icon,
      description: description,
    );
  }
}
