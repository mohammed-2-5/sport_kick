import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/sport_category_entity.dart';

/// Repository interface for field-related operations.
///
/// Defines the contract for accessing field data from various sources.
/// Implementation is in the data layer.
abstract class FieldRepository {
  /// Get all active fields.
  ///
  /// Returns a list of all active and bookable fields.
  /// Returns [ServerFailure] if the request fails.
  Future<Either<Failure, List<FieldEntity>>> getAllFields();

  /// Get field details by ID.
  ///
  /// [fieldId] - Unique identifier of the field
  /// Returns the field entity if found.
  /// Returns [ServerFailure] if the request fails.
  /// Returns [NotFoundFailure] if field doesn't exist.
  Future<Either<Failure, FieldEntity>> getFieldById(String fieldId);

  /// Search fields by query.
  ///
  /// [query] - Search term (field name, city, address)
  /// Returns fields matching the search criteria.
  Future<Either<Failure, List<FieldEntity>>> searchFields(String query);

  /// Get fields by sport category.
  ///
  /// [categoryId] - Sport category ID (e.g., Football, Basketball)
  /// Returns fields belonging to the specified sport category.
  Future<Either<Failure, List<FieldEntity>>> getFieldsByCategory(
    String categoryId,
  );

  /// Get fields by city.
  ///
  /// [city] - City name
  /// Returns fields in the specified city.
  Future<Either<Failure, List<FieldEntity>>> getFieldsByCity(String city);

  /// Get featured fields.
  ///
  /// Returns fields marked as featured for promotion.
  Future<Either<Failure, List<FieldEntity>>> getFeaturedFields();

  /// Get popular fields.
  ///
  /// Returns fields sorted by booking count (most popular first).
  /// [limit] - Maximum number of fields to return (default 10)
  Future<Either<Failure, List<FieldEntity>>> getPopularFields({int limit = 10});

  /// Get fields by owner ID.
  ///
  /// [ownerId] - User ID of the field owner
  /// Returns all fields owned by the specified user.
  /// Used for owner dashboard.
  Future<Either<Failure, List<FieldEntity>>> getFieldsByOwner(String ownerId);

  /// Get all sport categories.
  ///
  /// Returns a list of all active sport categories.
  Future<Either<Failure, List<SportCategoryEntity>>> getSportCategories();

  /// Get sport category by ID.
  ///
  /// [categoryId] - Sport category ID
  /// Returns the sport category entity if found.
  Future<Either<Failure, SportCategoryEntity>> getSportCategoryById(
    String categoryId,
  );

  /// Filter fields by criteria.
  ///
  /// Advanced filtering with multiple criteria.
  /// [categoryId] - Filter by sport category (optional)
  /// [city] - Filter by city (optional)
  /// [minPrice] - Minimum price per hour (optional)
  /// [maxPrice] - Maximum price per hour (optional)
  /// [amenities] - Required amenities (optional)
  /// Returns fields matching all specified criteria.
  Future<Either<Failure, List<FieldEntity>>> filterFields({
    String? categoryId,
    String? city,
    double? minPrice,
    double? maxPrice,
    List<String>? amenities,
  });
}
