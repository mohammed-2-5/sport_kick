import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/widgets/bulk_selection_app_bar.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/admin_card.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/admin_filter_sheet.dart';
import 'package:spo_kick/features/super_admin/utils/admin_filter_helper.dart';

/// Admins List Page
///
/// Displays all field owner (admin) accounts.
/// Allows super admin to:
/// - View admin details
/// - Search/filter admins
/// - View assigned fields
/// - Deactivate/activate admins
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
      setState(() {
        _searchQuery = value;
      });
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
      builder: (context) => AlertDialog(
        title: const Text('Activate Selected Admins'),
        content: Text(
          'Are you sure you want to activate ${selectedIds.length} admins?',
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
      context.read<SuperAdminCubit>().bulkActivateAdmins(selectedIds.toList());
      cancelSelection();
    }
  }

  Future<void> _handleBulkDeactivate() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deactivate Selected Admins'),
        content: Text(
          'Are you sure you want to deactivate ${selectedIds.length} admins?',
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
                        'Error loading admins',
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
                          context.read<SuperAdminCubit>().loadAdmins();
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (state is AdminsListLoaded) {
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<SuperAdminCubit>().loadAdmins();
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
                                'Search admins by name, email, or phone...',
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
                              Icons.admin_panel_settings,
                              size: 20,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Showing ${filteredAdmins.length} of ${state.admins.length} admins',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (isSelectionMode) ...[
                              const Spacer(),
                              Text(
                                '$selectedCount selected',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      // Admins List
                      Expanded(
                        child: filteredAdmins.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                itemCount: filteredAdmins.length,
                                itemBuilder: (context, index) {
                                  final admin = filteredAdmins[index];
                                  final isSelected = selectedIds.contains(
                                    admin.id,
                                  );

                                  return Stack(
                                    children: [
                                      AdminCard(
                                        admin: admin,
                                        onTap: () {
                                          if (isSelectionMode) {
                                            toggleSelection(admin.id);
                                          } else {
                                            Navigator.pushNamed(
                                              context,
                                              '/super-admin/admin-details',
                                              arguments: admin,
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
                                                  toggleSelection(admin.id),
                                              onLongPress: () =>
                                                  toggleSelection(admin.id),
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
                                                  toggleSelection(admin.id),
                                              onTap: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  '/super-admin/admin-details',
                                                  arguments: admin,
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

              // Initial or unknown state
              return const Center(child: CircularProgressIndicator());
            },
          ),
          floatingActionButton: !isSelectionMode
              ? FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.pushNamed(context, '/super-admin/create-admin');
                  },
                  icon: const Icon(Icons.person_add),
                  label: const Text('Create Admin'),
                )
              : null,
        );
      },
    );
  }

  Widget _buildEmptyState() {
    final isEmpty =
        _searchQuery.isEmpty && _statusFilter == null && _dateRange == null;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isEmpty ? Icons.admin_panel_settings_outlined : Icons.search_off,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            isEmpty ? 'No Admins Yet' : 'No Results Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isEmpty
                ? 'Create your first field owner account'
                : 'Try adjusting your filters',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
