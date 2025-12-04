import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/search_filters_entity.dart';
import 'package:spo_kick/features/fields/domain/repositories/field_repository.dart';

/// Advanced Search Fields Use Case
///
/// Searches and filters fields with multiple criteria and sorting options.
class AdvancedSearchFieldsUseCase {
  final FieldRepository repository;

  const AdvancedSearchFieldsUseCase(this.repository);

  /// Execute advanced search with filters and sorting
  ///
  /// [filters] - Search filters and criteria
  ///
  /// Returns filtered and sorted list of fields
  Future<Either<Failure, List<FieldEntity>>> call(
    SearchFiltersEntity filters,
  ) async {
    // Use repository filterFields method
    final result = await repository.filterFields(
      categoryId: filters.categoryId,
      city: filters.city,
      cityId: filters.cityId,
      minPrice: filters.minPrice,
      maxPrice: filters.maxPrice,
      amenities: filters.amenities,
    );

    // Apply sorting to results
    return result.fold(
      (failure) => Left(failure),
      (fields) {
        final sortedFields = _sortFields(fields, filters.sortBy, filters.sortAscending);

        // Apply text search filter if query exists
        if (filters.query != null && filters.query!.trim().isNotEmpty) {
          final query = filters.query!.toLowerCase();
          final filteredFields = sortedFields.where((field) {
            return field.name.toLowerCase().contains(query) ||
                field.address.toLowerCase().contains(query) ||
                (field.description?.toLowerCase().contains(query) ?? false);
          }).toList();
          return Right(filteredFields);
        }

        return Right(sortedFields);
      },
    );
  }

  /// Sort fields based on sort criteria
  List<FieldEntity> _sortFields(
    List<FieldEntity> fields,
    SearchSortBy sortBy,
    bool ascending,
  ) {
    final sorted = List<FieldEntity>.from(fields);

    switch (sortBy) {
      case SearchSortBy.priceLowToHigh:
        sorted.sort((a, b) => a.pricePerHour.compareTo(b.pricePerHour));
        break;

      case SearchSortBy.priceHighToLow:
        sorted.sort((a, b) => b.pricePerHour.compareTo(a.pricePerHour));
        break;

      case SearchSortBy.rating:
        sorted.sort((a, b) {
          final aRating = a.averageRating ?? 0.0;
          final bRating = b.averageRating ?? 0.0;
          return bRating.compareTo(aRating); // Highest first
        });
        break;

      case SearchSortBy.newest:
        sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;

      case SearchSortBy.popular:
        sorted.sort((a, b) {
          final aBookings = a.totalBookings ?? 0;
          final bBookings = b.totalBookings ?? 0;
          return bBookings.compareTo(aBookings); // Most bookings first
        });
        break;

      case SearchSortBy.relevance:
      default:
        // Keep original order for relevance
        break;
    }

    // Reverse if descending (except for already-descending sorts)
    if (!ascending &&
        sortBy != SearchSortBy.priceHighToLow &&
        sortBy != SearchSortBy.rating &&
        sortBy != SearchSortBy.newest &&
        sortBy != SearchSortBy.popular) {
      return sorted.reversed.toList();
    }

    return sorted;
  }
}
