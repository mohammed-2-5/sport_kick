import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/super_admin/domain/repositories/super_admin_repository.dart';

/// Use case for assigning a field to an admin.
///
/// Updates field ownership and creates audit trail entry.
/// Only super admins can assign fields to admins.
///
/// Usage:
/// ```dart
/// final useCase = AssignFieldToAdminUseCase(repository);
/// final result = await useCase(
///   adminId: 'admin-123',
///   fieldId: 'field-456',
///   notes: 'Assigned Champions Field to John',
/// );
///
/// result.fold(
///   (failure) => showError(failure.message),
///   (_) => showSuccess('Field assigned successfully'),
/// );
/// ```
class AssignFieldToAdminUseCase {
  final SuperAdminRepository repository;

  AssignFieldToAdminUseCase(this.repository);

  /// Execute the use case.
  ///
  /// Parameters:
  /// - [adminId]: ID of the admin to assign field to (required)
  /// - [fieldId]: ID of the field to assign (required)
  /// - [notes]: Optional notes about the assignment
  ///
  /// Returns:
  /// - [Right(void)]: Assignment successful
  /// - [Left(Failure)]: Error occurred
  ///
  /// Validation:
  /// - Admin ID must not be empty
  /// - Field ID must not be empty
  /// - Admin must exist and have admin role
  /// - Field must exist
  Future<Either<Failure, void>> call({
    required String adminId,
    required String fieldId,
    String? notes,
  }) async {
    // Input validation
    if (adminId.trim().isEmpty) {
      return Left(ValidationFailure('Admin ID cannot be empty'));
    }

    if (fieldId.trim().isEmpty) {
      return Left(ValidationFailure('Field ID cannot be empty'));
    }

    // Call repository to assign field
    return await repository.assignFieldToAdmin(
      adminId: adminId.trim(),
      fieldId: fieldId.trim(),
      notes: notes?.trim(),
    );
  }
}
