import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';

/// State for owner fields management.
///
/// Manages:
/// - Fields list
/// - Search query
/// - Filter options
sealed class OwnerFieldsState extends Equatable {
  const OwnerFieldsState();

  @override
  List<Object?> get props => [];
}

/// Initial loading state.
final class OwnerFieldsLoading extends OwnerFieldsState {
  const OwnerFieldsLoading();
}

/// Fields loaded successfully.
final class OwnerFieldsLoaded extends OwnerFieldsState {
  final List<FieldEntity> allFields;
  final String searchQuery;
  final bool?
  activeFilter; // null = all, true = active only, false = inactive only
  final bool isRefreshing;

  const OwnerFieldsLoaded({
    required this.allFields,
    this.searchQuery = '',
    this.activeFilter,
    this.isRefreshing = false,
  });

  /// Get filtered fields based on current filters.
  List<FieldEntity> get filteredFields {
    var fields = allFields;

    // Apply active filter
    if (activeFilter != null) {
      fields = fields.where((f) => f.isActive == activeFilter).toList();
    }

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      fields = fields.where((f) {
        return f.name.toLowerCase().contains(query) ||
            f.city.toLowerCase().contains(query) ||
            (f.description?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    return fields;
  }

  /// Get count by status.
  int get activeCount => allFields.where((f) => f.isActive).length;
  int get inactiveCount => allFields.where((f) => !f.isActive).length;

  OwnerFieldsLoaded copyWith({
    List<FieldEntity>? allFields,
    String? searchQuery,
    bool? activeFilter,
    bool clearFilter = false,
    bool? isRefreshing,
  }) {
    return OwnerFieldsLoaded(
      allFields: allFields ?? this.allFields,
      searchQuery: searchQuery ?? this.searchQuery,
      activeFilter: clearFilter ? null : (activeFilter ?? this.activeFilter),
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [
    allFields,
    searchQuery,
    activeFilter,
    isRefreshing,
  ];
}

/// Error state.
final class OwnerFieldsError extends OwnerFieldsState {
  final String message;

  const OwnerFieldsError(this.message);

  @override
  List<Object?> get props => [message];
}
