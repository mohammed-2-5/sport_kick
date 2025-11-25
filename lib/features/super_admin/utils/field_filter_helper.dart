import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';

/// Helper class for filtering fields list
class FieldFilterHelper {
  /// Filters fields based on search query and filter criteria
  static List<FieldEntity> filterFields(
    List<FieldEntity> fields, {
    String? searchQuery,
    String? cityFilter,
    String? sportFilter,
    String? ownerFilter,
    String? statusFilter,
    double? minPrice,
    double? maxPrice,
  }) {
    var filtered = fields;

    // Search filter - search by name, city, address
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filtered = filtered.where((field) {
        final nameMatch = field.name.toLowerCase().contains(query);
        final cityMatch = field.city.toLowerCase().contains(query);
        final addressMatch = field.address.toLowerCase().contains(query);
        return nameMatch || cityMatch || addressMatch;
      }).toList();
    }

    // City filter
    if (cityFilter != null && cityFilter != 'all') {
      filtered = filtered.where((field) => field.city == cityFilter).toList();
    }

    // Sport category filter
    if (sportFilter != null && sportFilter != 'all') {
      filtered = filtered
          .where((field) => field.sportCategoryId == sportFilter)
          .toList();
    }

    // Owner filter
    if (ownerFilter != null && ownerFilter != 'all') {
      filtered = filtered
          .where((field) => field.ownerId == ownerFilter)
          .toList();
    }

    // Status filter
    if (statusFilter != null) {
      filtered = filtered.where((field) {
        if (statusFilter == 'active') return field.isActive;
        if (statusFilter == 'inactive') return !field.isActive;
        return true;
      }).toList();
    }

    // Price range filter
    if (minPrice != null || maxPrice != null) {
      filtered = filtered.where((field) {
        final price = field.pricePerHour;
        if (minPrice != null && price < minPrice) return false;
        if (maxPrice != null && price > maxPrice) return false;
        return true;
      }).toList();
    }

    return filtered;
  }

  /// Get unique cities from fields list
  static List<String> getUniqueCities(List<FieldEntity> fields) {
    return fields.map((f) => f.city).toSet().toList()..sort();
  }

  /// Get unique sport category IDs from fields list
  static List<String> getUniqueSportTypes(List<FieldEntity> fields) {
    return fields.map((f) => f.sportCategoryId).toSet().toList()..sort();
  }

  /// Get unique owner IDs from fields list
  static List<String> getUniqueOwners(List<FieldEntity> fields) {
    return fields
        .where((f) => f.ownerId != null)
        .map((f) => f.ownerId!)
        .toSet()
        .toList()
      ..sort();
  }

  /// Calculate price range from fields list
  static ({double min, double max}) getPriceRange(List<FieldEntity> fields) {
    if (fields.isEmpty) return (min: 0, max: 1000);

    final prices = fields.map((f) => f.pricePerHour).toList();
    return (
      min: prices.reduce((a, b) => a < b ? a : b),
      max: prices.reduce((a, b) => a > b ? a : b),
    );
  }
}
