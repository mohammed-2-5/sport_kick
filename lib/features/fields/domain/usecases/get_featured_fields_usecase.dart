import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/domain/repositories/field_repository.dart';

/// Use case for getting featured fields.
///
/// Returns fields marked as featured, typically for promotion
/// or highlighting on the home screen.
///
/// Usage:
/// ```dart
/// final result = await getFeaturedFieldsUseCase();
/// result.fold(
///   (failure) => print('Error: ${failure.message}'),
///   (fields) => print('Found ${fields.length} featured fields'),
/// );
/// ```
class GetFeaturedFieldsUseCase {
  final FieldRepository repository;

  const GetFeaturedFieldsUseCase(this.repository);

  /// Execute the use case.
  ///
  /// Returns [Either] with:
  /// - [Failure] on error (network, server, etc.)
  /// - [List<FieldEntity>] on success
  Future<Either<Failure, List<FieldEntity>>> call() async {
    return await repository.getFeaturedFields();
  }
}
