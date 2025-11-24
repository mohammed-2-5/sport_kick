import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/domain/repositories/field_repository.dart';

/// Use case for searching fields by query.
///
/// Searches fields by name, city, address, or other criteria.
///
/// Usage:
/// ```dart
/// final result = await searchFieldsUseCase('stadium');
/// result.fold(
///   (failure) => print('Error: ${failure.message}'),
///   (fields) => print('Found ${fields.length} matching fields'),
/// );
/// ```
class SearchFieldsUseCase {
  final FieldRepository repository;

  const SearchFieldsUseCase(this.repository);

  /// Execute the use case.
  ///
  /// [query] - Search term (field name, city, address)
  ///
  /// Returns [Either] with:
  /// - [Failure] on error (network, server, etc.)
  /// - [List<FieldEntity>] on success (empty list if no matches)
  Future<Either<Failure, List<FieldEntity>>> call(String query) async {
    // Trim and validate query
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      return Left(ValidationFailure('Search query cannot be empty'));
    }

    if (trimmedQuery.length < 2) {
      return Left(
        ValidationFailure('Search query must be at least 2 characters'),
      );
    }

    return await repository.searchFields(trimmedQuery);
  }
}
