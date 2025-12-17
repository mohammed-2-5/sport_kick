import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/super_admin/domain/repositories/super_admin_repository.dart';

/// Delete type options for super admin.
enum DeleteType {
  /// Soft delete - sets is_active = false, recoverable
  soft,

  /// Hard delete - permanently removes from database
  hard,
}

/// Use case for deleting a field.
///
/// Supports both soft delete (deactivate) and hard delete (permanent).
/// Super admin chooses which option to use.
class DeleteFieldUseCase {
  final SuperAdminRepository _repository;

  const DeleteFieldUseCase(this._repository);

  /// Delete a field using the specified delete type.
  ///
  /// - [DeleteType.soft]: Sets is_active = false, field can be reactivated
  /// - [DeleteType.hard]: Permanently removes field and related data
  ///
  /// Returns [void] on success, [Failure] on error.
  Future<Either<Failure, void>> call({
    required String fieldId,
    required DeleteType deleteType,
  }) {
    return _repository.deleteField(
      fieldId: fieldId,
      hardDelete: deleteType == DeleteType.hard,
    );
  }
}
