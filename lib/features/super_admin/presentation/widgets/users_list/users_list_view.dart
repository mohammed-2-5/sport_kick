import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/core/widgets/bulk_selection_app_bar.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/user_filter_sheet.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/users_list/bulk_user_action_dialogs.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/users_list/user_list_body.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/users_list/user_list_error_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/users_list/user_list_loading_state.dart';
import 'package:spo_kick/features/super_admin/utils/user_filter_helper.dart';

/// Users List View - displays and manages users list with filtering and bulk actions.
class UsersListView extends StatefulWidget {
  const UsersListView({super.key});

  @override
  State<UsersListView> createState() => _UsersListViewState();
}

class _UsersListViewState extends State<UsersListView>
    with BulkSelectionMixin<UserEntity, UsersListView> {
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
      setState(() => _searchQuery = value);
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
    final cubit = context.read<SuperAdminCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => BulkActivateUsersDialog(count: selectedIds.length),
    );

    if (confirmed == true && mounted) {
      cubit.bulkActivateUsers(selectedIds.toList());
      cancelSelection();
    }
  }

  Future<void> _handleBulkDeactivate() async {
    final cubit = context.read<SuperAdminCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) =>
          BulkDeactivateUsersDialog(count: selectedIds.length),
    );

    if (confirmed == true && mounted) {
      cubit.bulkDeactivateUsers(selectedIds.toList());
      cancelSelection();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SuperAdminCubit, SuperAdminState>(
      listener: (context, state) {
        if (state is SuperAdminError) {
          SnackbarHelper.showError(context, state.message);
        } else if (state is BulkActionCompleted) {
          SnackbarHelper.showSuccess(context, state.message);
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
          body: _buildBody(
            context,
            state,
            filteredUsers,
            totalCount,
            activeCount,
          ),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    SuperAdminState state,
    List<UserEntity> filteredUsers,
    int totalCount,
    int activeCount,
  ) {
    if (state is SuperAdminLoading) {
      return UserListLoadingState(message: state.message);
    }

    if (state is SuperAdminError) {
      return UserListErrorState(
        message: state.message,
        onRetry: () => context.read<SuperAdminCubit>().loadUsers(),
      );
    }

    if (state is UsersListLoaded) {
      return UserListBody(
        searchController: _searchController,
        searchQuery: _searchQuery,
        filteredUsers: filteredUsers,
        totalCount: totalCount,
        activeCount: activeCount,
        isSelectionMode: isSelectionMode,
        selectedCount: selectedCount,
        selectedIds: selectedIds,
        hasFilters:
            _searchQuery.isNotEmpty ||
            _statusFilter != null ||
            _dateRange != null,
        onSearchChanged: _onSearchChanged,
        onClearSearch: () {
          _searchController.clear();
          setState(() => _searchQuery = '');
        },
        onUserTap: (user, isSelected) {
          if (isSelectionMode) {
            toggleSelection(user.id);
          } else {
            context.pushNamed('superAdminUserDetails', extra: user);
          }
        },
        onUserLongPress: toggleSelection,
      );
    }

    return const Center(child: CircularProgressIndicator());
  }
}
