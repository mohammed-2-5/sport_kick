import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/fields/domain/entities/sport_category_entity.dart';
import 'package:spo_kick/features/fields/domain/repositories/field_repository.dart';

/// Use case for getting all sport categories.
///
/// Returns a list of all active sport categories (Football, Basketball, etc.)
/// Used for filtering fields by sport type.
///
/// Usage:
/// ```dart
/// final result = await getSportCategoriesUseCase();
/// result.fold(
///   (failure) => print('Error: ${failure.message}'),
///   (categories) => print('Found ${categories.length} sports'),
/// );
/// ```
class GetSportCategoriesUseCase {
  final FieldRepository repository;

  const GetSportCategoriesUseCase(this.repository);

  /// Execute the use case.
  ///
  /// Returns [Either] with:
  /// - [Failure] on error (network, server, etc.)
  /// - [List<SportCategoryEntity>] on success
  Future<Either<Failure, List<SportCategoryEntity>>> call() async {
    return await repository.getSportCategories();
  }
}
