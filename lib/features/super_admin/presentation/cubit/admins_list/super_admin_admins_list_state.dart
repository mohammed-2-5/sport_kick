import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';

/// State for super admin admins list management.
///
/// Manages:
/// - Admins list
/// - Search query
/// - Status filter
/// - Selection mode
sealed class SuperAdminAdminsListState extends Equatable {
  const SuperAdminAdminsListState();

  @override
  List<Object?> get props => [];
}

/// Initial loading state.
final class SuperAdminAdminsListLoading extends SuperAdminAdminsListState {
  const SuperAdminAdminsListLoading();
}

/// Admins loaded successfully.
final class SuperAdminAdminsListLoaded extends SuperAdminAdminsListState {
  final List<UserEntity> allAdmins;
  final String searchQuery;
  final String? statusFilter; // null = all, 'Active', 'Inactive'
  final bool isSelectionMode;
  final Set<String> selectedIds;
  final bool isRefreshing;

  const SuperAdminAdminsListLoaded({
    required this.allAdmins,
    this.searchQuery = '',
    this.statusFilter,
    this.isSelectionMode = false,
    this.selectedIds = const {},
    this.isRefreshing = false,
  });

  /// Get filtered admins based on search and status.
  List<UserEntity> get filteredAdmins {
    var admins = allAdmins;

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      admins = admins.where((admin) {
        return (admin.fullName?.toLowerCase().contains(query) ?? false) ||
            admin.email.toLowerCase().contains(query) ||
            (admin.phone?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    // Apply status filter
    if (statusFilter != null) {
      admins = admins.where((admin) {
        return (statusFilter == 'Active' && admin.isActive) ||
            (statusFilter == 'Inactive' && !admin.isActive);
      }).toList();
    }

    return admins;
  }

  /// Get count by status.
  int get activeCount => allAdmins.where((a) => a.isActive).length;
  int get inactiveCount => allAdmins.where((a) => !a.isActive).length;

  SuperAdminAdminsListLoaded copyWith({
    List<UserEntity>? allAdmins,
    String? searchQuery,
    String? statusFilter,
    bool clearStatusFilter = false,
    bool? isSelectionMode,
    Set<String>? selectedIds,
    bool? isRefreshing,
  }) {
    return SuperAdminAdminsListLoaded(
      allAdmins: allAdmins ?? this.allAdmins,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: clearStatusFilter
          ? null
          : (statusFilter ?? this.statusFilter),
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
      selectedIds: selectedIds ?? this.selectedIds,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [
    allAdmins,
    searchQuery,
    statusFilter,
    isSelectionMode,
    selectedIds,
    isRefreshing,
  ];
}

/// Error state.
final class SuperAdminAdminsListError extends SuperAdminAdminsListState {
  final String message;

  const SuperAdminAdminsListError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Action success state.
final class SuperAdminAdminsListActionSuccess
    extends SuperAdminAdminsListState {
  final String message;

  const SuperAdminAdminsListActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
