import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
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

class _UsersListViewState extends State<_UsersListView> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers (Users)'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Badge(
              isLabelVisible: _statusFilter != null || _dateRange != null,
              child: const Icon(Icons.filter_list),
            ),
            onPressed: _showFilterSheet,
            tooltip: 'Filter',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<SuperAdminCubit>().loadUsers(),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: BlocConsumer<SuperAdminCubit, SuperAdminState>(
        listener: (context, state) {
          if (state is SuperAdminError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
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
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
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
            final allUsers = state.users;
            final filteredUsers = _filterUsers(allUsers);
            final activeCount = allUsers.where((u) => u.isActive).length;

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
                        hintText: 'Search users by name, email, or phone...',
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
                        Icon(Icons.people, size: 20, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Text(
                          'Showing ${filteredUsers.length} of ${allUsers.length} users',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${activeCount} active',
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
                              return UserCard(
                                user: user,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/super-admin/user-details',
                                    arguments: user,
                                  );
                                },
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
