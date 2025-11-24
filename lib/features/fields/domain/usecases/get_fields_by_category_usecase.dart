import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/domain/repositories/field_repository.dart';

/// Use case for getting fields by sport category.
///
/// Returns fields filtered by a specific sport category
/// (e.g., all Football fields, all Basketball courts).
///
/// Usage:
/// ```dart
/// final result = await getFieldsByCategoryUseCase('football-id');
/// result.fold(
///   (failure) => print('Error: ${failure.message}'),
///   (fields) => print('Found ${fields.length} football fields'),
/// );
/// ```
class GetFieldsByCategoryUseCase {
  final FieldRepository repository;

  const GetFieldsByCategoryUseCase(this.repository);

  /// Execute the use case.
  ///
  /// [categoryId] - Sport category ID (e.g., 'football', 'basketball')
  ///
  /// Returns [Either] with:
  /// - [Failure] on error (network, server, etc.)
  /// - [List<FieldEntity>] on success
  Future<Either<Failure, List<FieldEntity>>> call(String categoryId) async {
    if (categoryId.isEmpty) {
      return Left(ValidationFailure('Category ID cannot be empty'));
    }

    return await repository.getFieldsByCategory(categoryId);
  }
}
