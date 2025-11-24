import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/domain/repositories/field_repository.dart';

/// Use case for getting all active fields.
///
/// Returns a list of all fields that are active and available for booking.
///
/// Usage:
/// ```dart
/// final result = await getAllFieldsUseCase();
/// result.fold(
///   (failure) => print('Error: ${failure.message}'),
///   (fields) => print('Found ${fields.length} fields'),
/// );
/// ```
class GetAllFieldsUseCase {
  final FieldRepository repository;

  const GetAllFieldsUseCase(this.repository);

  /// Execute the use case.
  ///
  /// Returns [Either] with:
  /// - [Failure] on error (network, server, etc.)
  /// - [List<FieldEntity>] on success
  Future<Either<Failure, List<FieldEntity>>> call() async {
    return await repository.getAllFields();
  }
}
