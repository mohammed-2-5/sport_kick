import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/widgets/bulk_selection_app_bar.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/admin_filter_sheet.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/admins_list/admin_list_body.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/admins_list/admin_list_error_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/admins_list/admin_list_loading_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/admins_list/bulk_action_dialogs.dart';
import 'package:spo_kick/features/super_admin/utils/admin_filter_helper.dart';

/// Admins List Page
///
/// Displays all field owner (admin) accounts.
/// Supports search, filter, bulk operations and CSV export.
class AdminsListPage extends StatelessWidget {
  const AdminsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SuperAdminCubit>()..loadAdmins(),
      child: const _AdminsListView(),
    );
  }
}

class _AdminsListView extends StatefulWidget {
  const _AdminsListView();

  @override
  State<_AdminsListView> createState() => _AdminsListViewState();
}

class _AdminsListViewState extends State<_AdminsListView>
    with BulkSelectionMixin<UserEntity, _AdminsListView> {
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

  List<UserEntity> _filterAdmins(List<UserEntity> admins) {
    return AdminFilterHelper.filterAdmins(
      admins,
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
        builder: (_, setState) => AdminFilterSheet(
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
      builder: (context) => BulkActivateAdminsDialog(count: selectedIds.length),
    );

    if (confirmed == true && mounted) {
      context.read<SuperAdminCubit>().bulkActivateAdmins(selectedIds.toList());
      cancelSelection();
    }
  }

  Future<void> _handleBulkDeactivate() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) =>
          BulkDeactivateAdminsDialog(count: selectedIds.length),
    );

    if (confirmed == true && mounted) {
      context.read<SuperAdminCubit>().bulkDeactivateAdmins(
        selectedIds.toList(),
      );
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
        List<UserEntity> filteredAdmins = [];
        if (state is AdminsListLoaded) {
          filteredAdmins = _filterAdmins(state.admins);
        }

        return Scaffold(
          appBar: isSelectionMode
              ? BulkSelectionAppBar(
                  selectedCount: selectedCount,
                  totalCount: filteredAdmins.length,
                  onCancel: cancelSelection,
                  onSelectAll: () => selectAll(filteredAdmins, (a) => a.id),
                  onDeselectAll: deselectAll,
                  actions: [
                    BulkAction(
                      icon: Icons.download,
                      label: 'Export CSV',
                      onPressed: () async {
                        final selected = getSelectedItems(
                          filteredAdmins,
                          (a) => a.id,
                        );
                        await context.read<SuperAdminCubit>().exportAdminsToCSV(
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
                  title: const Text('Field Owners (Admins)'),
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
                      onPressed: () {
                        context.read<SuperAdminCubit>().loadAdmins();
                      },
                      tooltip: 'Refresh',
                    ),
                  ],
                ),
          body: Builder(
            builder: (context) {
              if (state is SuperAdminLoading) {
                return AdminListLoadingState(message: state.message);
              }

              if (state is SuperAdminError) {
                return AdminListErrorState(
                  message: state.message,
                  onRetry: () {
                    context.read<SuperAdminCubit>().loadAdmins();
                  },
                );
              }

              if (state is AdminsListLoaded) {
                return AdminListBody(
                  searchController: _searchController,
                  searchQuery: _searchQuery,
                  filteredAdmins: filteredAdmins,
                  totalCount: state.admins.length,
                  isSelectionMode: isSelectionMode,
                  selectedCount: selectedCount,
                  selectedIds: selectedIds,
                  isSearchEmpty:
                      _searchQuery.isEmpty &&
                      _statusFilter == null &&
                      _dateRange == null,
                  onSearchChanged: _onSearchChanged,
                  onClearSearch: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                  onAdminTap: (admin, isSelected) {
                    if (isSelectionMode) {
                      toggleSelection(admin.id);
                    } else {
                      context.pushNamed('superAdminAdminDetails', extra: admin);
                    }
                  },
                  onAdminLongPress: toggleSelection,
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
          floatingActionButton: !isSelectionMode
              ? FloatingActionButton.extended(
                  onPressed: () {
                    context.pushNamed('superAdminCreateAdmin');
                  },
                  icon: const Icon(Icons.person_add),
                  label: const Text('Create Admin'),
                )
              : null,
        );
      },
    );
  }
}
