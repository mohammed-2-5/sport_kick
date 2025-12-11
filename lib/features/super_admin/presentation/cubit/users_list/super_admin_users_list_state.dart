import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';

/// State for super admin users list management.
///
/// Manages:
/// - Users list
/// - Search query
/// - Status filter
/// - Selection mode
sealed class SuperAdminUsersListState extends Equatable {
  const SuperAdminUsersListState();

  @override
  List<Object?> get props => [];
}

/// Initial loading state.
final class SuperAdminUsersListLoading extends SuperAdminUsersListState {
  const SuperAdminUsersListLoading();
}

/// Users loaded successfully.
final class SuperAdminUsersListLoaded extends SuperAdminUsersListState {
  final List<UserEntity> allUsers;
  final String searchQuery;
  final String? statusFilter; // null = all, 'Active', 'Inactive'
  final bool isSelectionMode;
  final Set<String> selectedIds;
  final bool isRefreshing;

  const SuperAdminUsersListLoaded({
    required this.allUsers,
    this.searchQuery = '',
    this.statusFilter,
    this.isSelectionMode = false,
    this.selectedIds = const {},
    this.isRefreshing = false,
  });

  /// Get filtered users based on search and status.
  List<UserEntity> get filteredUsers {
    var users = allUsers;

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      users = users.where((user) {
        return (user.fullName?.toLowerCase().contains(query) ?? false) ||
            user.email.toLowerCase().contains(query) ||
            (user.phone?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    // Apply status filter
    if (statusFilter != null) {
      users = users.where((user) {
        return (statusFilter == 'Active' && user.isActive) ||
            (statusFilter == 'Inactive' && !user.isActive);
      }).toList();
    }

    return users;
  }

  /// Get count by status.
  int get activeCount => allUsers.where((u) => u.isActive).length;
  int get inactiveCount => allUsers.where((u) => !u.isActive).length;

  SuperAdminUsersListLoaded copyWith({
    List<UserEntity>? allUsers,
    String? searchQuery,
    String? statusFilter,
    bool clearStatusFilter = false,
    bool? isSelectionMode,
    Set<String>? selectedIds,
    bool? isRefreshing,
  }) {
    return SuperAdminUsersListLoaded(
      allUsers: allUsers ?? this.allUsers,
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
    allUsers,
    searchQuery,
    statusFilter,
    isSelectionMode,
    selectedIds,
    isRefreshing,
  ];
}

/// Error state.
final class SuperAdminUsersListError extends SuperAdminUsersListState {
  final String message;

  const SuperAdminUsersListError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Action success state.
final class SuperAdminUsersListActionSuccess extends SuperAdminUsersListState {
  final String message;

  const SuperAdminUsersListActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
