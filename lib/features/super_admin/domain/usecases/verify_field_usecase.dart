import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/super_admin/domain/repositories/super_admin_repository.dart';

/// Use case for verifying/unverifying a field.
///
/// Verified fields show a "verified" badge in the app
/// and may receive higher visibility in search results.
class VerifyFieldUseCase {
  final SuperAdminRepository _repository;

  const VerifyFieldUseCase(this._repository);

  /// Toggle the verification status of a field.
  ///
  /// - [isVerified] = true: Field gets verified badge
  /// - [isVerified] = false: Verification removed
  ///
  /// Returns [void] on success, [Failure] on error.
  Future<Either<Failure, void>> call({
    required String fieldId,
    required bool isVerified,
  }) {
    return _repository.verifyField(fieldId: fieldId, isVerified: isVerified);
  }
}
