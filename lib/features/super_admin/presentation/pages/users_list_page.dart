import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/widgets/bulk_selection_app_bar.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/user_card.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/user_filter_sheet.dart';
import 'package:spo_kick/features/super_admin/utils/user_filter_helper.dart';

/// Users List Page
///
/// Displays all regular customer accounts.
/// Allows super admin to:
/// - View user details
/// - Search/filter users
/// - View user booking history
/// - Deactivate/activate users
class UsersListPage extends StatelessWidget {
  const UsersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SuperAdminCubit>()..loadUsers(),
      child: const _UsersListView(),
    );
  }
}

class _UsersListView extends StatefulWidget {
  const _UsersListView();

  @override
  State<_UsersListView> createState() => _UsersListViewState();
}

class _UsersListViewState extends State<_UsersListView>
    with BulkSelectionMixin<UserEntity, _UsersListView> {
  final _searchController = TextEditingController();
  Timer? _debounceTimer;
  String _searchQuery = '';
  String? _statusFilter;
  DateTimeRange? _dateRange;

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _searchQuery = value;
      });
    });
  }

  List<UserEntity> _filterUsers(List<UserEntity> users) {
    return UserFilterHelper.filterUsers(
      users,
      searchQuery: _searchQuery,
      statusFilter: _statusFilter,
      dateRange: _dateRange,
    );
  }

  void _showFilterSheet() {
    String? tempStatus = _statusFilter;
    DateTimeRange? tempDate = _dateRange;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (c) => StatefulBuilder(
        builder: (_, setState) => UserFilterSheet(
          statusFilter: tempStatus,
          dateRange: tempDate,
          onStatusChanged: (v) => setState(() => tempStatus = v),
          onDateRangeChanged: (r) => setState(() => tempDate = r),
          onApply: () => this.setState(() {
            _statusFilter = tempStatus;
            _dateRange = tempDate;
          }),
          onReset: () => this.setState(() {
            _statusFilter = null;
            _dateRange = null;
          }),
        ),
      ),
    );
  }

  Future<void> _handleBulkActivate() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Activate Selected Users'),
        content: Text(
          'Are you sure you want to activate ${selectedIds.length} users?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Activate'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      context.read<SuperAdminCubit>().bulkActivateUsers(selectedIds.toList());
      cancelSelection();
    }
  }

  Future<void> _handleBulkDeactivate() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deactivate Selected Users'),
        content: Text(
          'Are you sure you want to deactivate ${selectedIds.length} users?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Deactivate'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      context.read<SuperAdminCubit>().bulkDeactivateUsers(selectedIds.toList());
      cancelSelection();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SuperAdminCubit, SuperAdminState>(
      listener: (context, state) {
        if (state is SuperAdminError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is BulkActionCompleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        List<UserEntity> filteredUsers = [];
        int activeCount = 0;
        int totalCount = 0;

        if (state is UsersListLoaded) {
          filteredUsers = _filterUsers(state.users);
          totalCount = state.users.length;
          activeCount = state.users.where((u) => u.isActive).length;
        }

        return Scaffold(
          appBar: isSelectionMode
              ? BulkSelectionAppBar(
                  selectedCount: selectedCount,
                  totalCount: filteredUsers.length,
                  onCancel: cancelSelection,
                  onSelectAll: () => selectAll(filteredUsers, (u) => u.id),
                  onDeselectAll: deselectAll,
                  actions: [
                    BulkAction(
                      icon: Icons.download,
                      label: 'Export CSV',
                      onPressed: () async {
                        final selected = getSelectedItems(
                          filteredUsers,
                          (u) => u.id,
                        );
                        await context.read<SuperAdminCubit>().exportUsersToCSV(
                          selected,
                        );
                      },
                      color: Colors.blue,
                    ),
                    BulkAction(
                      icon: Icons.check_circle_outline,
                      label: 'Activate',
                      onPressed: _handleBulkActivate,
                      color: Colors.green,
                    ),
                    BulkAction(
                      icon: Icons.block,
                      label: 'Deactivate',
                      onPressed: _handleBulkDeactivate,
                      color: Colors.red,
                    ),
                  ],
                )
              : AppBar(
                  title: const Text('Customers (Users)'),
                  elevation: 0,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  actions: [
                    IconButton(
                      icon: Badge(
                        isLabelVisible:
                            _statusFilter != null || _dateRange != null,
                        child: const Icon(Icons.filter_list),
                      ),
                      onPressed: _showFilterSheet,
                      tooltip: 'Filter',
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () =>
                          context.read<SuperAdminCubit>().loadUsers(),
                      tooltip: 'Refresh',
                    ),
                  ],
                ),
          body: Builder(
            builder: (context) {
              if (state is SuperAdminLoading) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        state.message,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                );
              }

              if (state is SuperAdminError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading users',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<SuperAdminCubit>().loadUsers();
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (state is UsersListLoaded) {
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<SuperAdminCubit>().loadUsers();
                    await Future.delayed(const Duration(milliseconds: 500));
                  },
                  child: Column(
                    children: [
                      // Search Bar
                      Container(
                        padding: const EdgeInsets.all(16),
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.05),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText:
                                'Search users by name, email, or phone...',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() => _searchQuery = '');
                                    },
                                  )
                                : null,
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          onChanged: _onSearchChanged,
                        ),
                      ),

                      // Stats Summary
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.people,
                              size: 20,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Showing ${filteredUsers.length} of $totalCount users',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            if (isSelectionMode)
                              Text(
                                '$selectedCount selected',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            else
                              Text(
                                '$activeCount active',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
                        ),
                      ),

                      // Users List
                      Expanded(
                        child: filteredUsers.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                itemCount: filteredUsers.length,
                                itemBuilder: (context, index) {
                                  final user = filteredUsers[index];
                                  final isSelected = selectedIds.contains(
                                    user.id,
                                  );

                                  return Stack(
                                    children: [
                                      UserCard(
                                        user: user,
                                        onTap: () {
                                          if (isSelectionMode) {
                                            toggleSelection(user.id);
                                          } else {
                                            Navigator.pushNamed(
                                              context,
                                              '/super-admin/user-details',
                                              arguments: user,
                                            );
                                          }
                                        },
                                      ),
                                      // Selection Overlay
                                      if (isSelectionMode)
                                        Positioned.fill(
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () =>
                                                  toggleSelection(user.id),
                                              onLongPress: () =>
                                                  toggleSelection(user.id),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: isSelected
                                                      ? Theme.of(context)
                                                            .colorScheme
                                                            .primary
                                                            .withValues(
                                                              alpha: 0.1,
                                                            )
                                                      : Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: isSelected
                                                      ? Border.all(
                                                          color: Theme.of(
                                                            context,
                                                          ).colorScheme.primary,
                                                          width: 2,
                                                        )
                                                      : null,
                                                ),
                                                child: isSelected
                                                    ? Align(
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                8.0,
                                                              ),
                                                          child: Icon(
                                                            Icons.check_circle,
                                                            color:
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .colorScheme
                                                                    .primary,
                                                          ),
                                                        ),
                                                      )
                                                    : null,
                                              ),
                                            ),
                                          ),
                                        )
                                      else
                                        Positioned.fill(
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onLongPress: () =>
                                                  toggleSelection(user.id),
                                              onTap: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  '/super-admin/user-details',
                                                  arguments: user,
                                                );
                                              },
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    final hasFilters =
        _searchQuery.isNotEmpty || _statusFilter != null || _dateRange != null;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hasFilters ? Icons.search_off : Icons.people_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            hasFilters ? 'No Results Found' : 'No Users Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasFilters
                ? 'Try adjusting your filters'
                : 'Users will appear here once they register',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
