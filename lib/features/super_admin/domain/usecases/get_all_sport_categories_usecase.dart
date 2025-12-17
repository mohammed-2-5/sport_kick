import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/fields/domain/entities/sport_category_entity.dart';
import 'package:spo_kick/features/super_admin/domain/repositories/super_admin_repository.dart';

/// Use case for getting all sport categories.
///
/// Returns all categories regardless of active status.
/// Used by super admin to manage sport types.
class GetAllSportCategoriesUseCase {
  final SuperAdminRepository repository;

  GetAllSportCategoriesUseCase(this.repository);

  Future<Either<Failure, List<SportCategoryEntity>>> call() async {
    return await repository.getAllSportCategories();
  }
}
