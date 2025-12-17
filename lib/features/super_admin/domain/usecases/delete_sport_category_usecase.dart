import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/super_admin/domain/repositories/super_admin_repository.dart';

/// Use case for deleting a sport category.
///
/// Deletes a category if no fields are using it.
/// Only super admin can perform this operation.
class DeleteSportCategoryUseCase {
  final SuperAdminRepository repository;

  DeleteSportCategoryUseCase(this.repository);

  Future<Either<Failure, void>> call({required String categoryId}) async {
    return await repository.deleteSportCategory(categoryId: categoryId);
  }
}
