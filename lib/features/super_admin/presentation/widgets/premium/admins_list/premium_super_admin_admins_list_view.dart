import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/admins_list/super_admin_admins_list_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/admins_list/super_admin_admins_list_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/admins_list/premium_admins_list_header.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/admins_list/premium_admins_list_filters.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/admins_list/premium_admins_list_content.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/admins_list/premium_admins_bulk_action_bar.dart';

/// Premium view for super admin admins list management.
///
/// Features:
/// - Premium gold-themed header with glassmorphism
/// - Search functionality with blur effect
/// - Stats chips showing admin counts
/// - Filter chips (All, Active, Inactive)
/// - Selection mode for bulk actions
/// - Bulk activate/deactivate
/// - Responsive grid layout
/// - Staggered animations
/// - Pull-to-refresh
/// - All logic handled by SuperAdminAdminsListCubit
class PremiumSuperAdminAdminsListView extends StatefulWidget {
  const PremiumSuperAdminAdminsListView({super.key});

  @override
  State<PremiumSuperAdminAdminsListView> createState() =>
      _PremiumSuperAdminAdminsListViewState();
}

class _PremiumSuperAdminAdminsListViewState
    extends State<PremiumSuperAdminAdminsListView> {
  @override
  void initState() {
    super.initState();
    context.read<SuperAdminAdminsListCubit>().loadAdmins();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: BlocConsumer<SuperAdminAdminsListCubit, SuperAdminAdminsListState>(
        listener: (context, state) {
          if (state is SuperAdminAdminsListError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          } else if (state is SuperAdminAdminsListActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<SuperAdminAdminsListCubit>();
          final stats = cubit.getStats();

          return Stack(
            children: [
              Column(
                children: [
                  // Header with search and stats
                  PremiumAdminsListHeader(
                    searchQuery: state is SuperAdminAdminsListLoaded
                        ? state.searchQuery
                        : '',
                    onSearchChanged: (query) => cubit.search(query),
                    onClearSearch: () => cubit.clearSearch(),
                    stats: stats,
                    isSelectionMode: state is SuperAdminAdminsListLoaded
                        ? state.isSelectionMode
                        : false,
                    onToggleSelection: () => cubit.toggleSelectionMode(),
                  ),

                  const SizedBox(height: 20),

                  // Filter chips
                  PremiumAdminsListFilters(
                    selectedFilter: state is SuperAdminAdminsListLoaded
                        ? state.statusFilter
                        : null,
                    onFilterChanged: (filter) => cubit.filterByStatus(filter),
                    stats: stats,
                  ),

                  const SizedBox(height: 20),

                  // Admins list
                  Expanded(child: _buildContent(context, state, cubit)),
                ],
              ),

              // Bulk action bar
              if (state is SuperAdminAdminsListLoaded &&
                  state.selectedIds.isNotEmpty)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: PremiumAdminsBulkActionBar(
                    selectedCount: state.selectedIds.length,
                    totalCount: state.filteredAdmins.length,
                    onSelectAll: () => cubit.selectAll(),
                    onDeselectAll: () => cubit.deselectAll(),
                    onActivate: () =>
                        _handleBulkActivate(context, cubit, state),
                    onDeactivate: () =>
                        _handleBulkDeactivate(context, cubit, state),
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: _buildCreateAdminFab(context),
    );
  }

  Widget? _buildCreateAdminFab(BuildContext context) {
    return BlocBuilder<SuperAdminAdminsListCubit, SuperAdminAdminsListState>(
      builder: (context, state) {
        // Hide FAB when in selection mode
        if (state is SuperAdminAdminsListLoaded &&
            state.selectedIds.isNotEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          decoration: BoxDecoration(
            gradient: AppColors.navyGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.navyDeep.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => context.pushNamed('superAdminCreateAdmin'),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.person_add_rounded, color: Colors.white),
                    const SizedBox(width: 10),
                    Text(
                      'Create Admin',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    SuperAdminAdminsListState state,
    SuperAdminAdminsListCubit cubit,
  ) {
    if (state is SuperAdminAdminsListLoading) {
      return PremiumAdminsListContent(
        admins: const [],
        isLoading: true,
        isRefreshing: false,
        onRefresh: () {},
        isSelectionMode: false,
        selectedIds: const {},
        onToggleSelection: (_) {},
        onActivateAdmin: (_) {},
        onDeactivateAdmin: (_) {},
      );
    }

    if (state is SuperAdminAdminsListLoaded) {
      final filteredAdmins = state.filteredAdmins;

      return PremiumAdminsListContent(
        admins: filteredAdmins,
        isLoading: false,
        isRefreshing: state.isRefreshing,
        onRefresh: () => cubit.refresh(),
        isSelectionMode: state.isSelectionMode,
        selectedIds: state.selectedIds,
        onToggleSelection: (id) => cubit.toggleSelection(id),
        onActivateAdmin: (id) => cubit.activateAdmin(id),
        onDeactivateAdmin: (id) => cubit.deactivateAdmin(id),
        emptyMessage: _getEmptyMessage(state),
      );
    }

    // Error state - show empty with retry
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Failed to load admins',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => cubit.loadAdmins(),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.premiumGold,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getEmptyMessage(SuperAdminAdminsListLoaded state) {
    if (state.searchQuery.isNotEmpty) {
      return 'No admins match your search';
    }

    if (state.statusFilter != null) {
      return state.statusFilter == 'Active'
          ? 'No active admins'
          : 'No inactive admins';
    }

    return 'No admins yet';
  }

  Future<void> _handleBulkActivate(
    BuildContext context,
    SuperAdminAdminsListCubit cubit,
    SuperAdminAdminsListLoaded state,
  ) async {
    final confirmed = await _showConfirmDialog(
      context,
      title: 'Activate Admins',
      message:
          'Are you sure you want to activate ${state.selectedIds.length} admin${state.selectedIds.length > 1 ? 's' : ''}?',
      confirmText: 'Activate',
      confirmColor: Colors.green,
    );

    if (confirmed) {
      await cubit.bulkActivateAdmins(state.selectedIds.toList());
    }
  }

  Future<void> _handleBulkDeactivate(
    BuildContext context,
    SuperAdminAdminsListCubit cubit,
    SuperAdminAdminsListLoaded state,
  ) async {
    final confirmed = await _showConfirmDialog(
      context,
      title: 'Deactivate Admins',
      message:
          'Are you sure you want to deactivate ${state.selectedIds.length} admin${state.selectedIds.length > 1 ? 's' : ''}?',
      confirmText: 'Deactivate',
      confirmColor: Colors.red,
    );

    if (confirmed) {
      await cubit.bulkDeactivateAdmins(state.selectedIds.toList());
    }
  }

  Future<bool> _showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmText,
    required Color confirmColor,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          title,
          style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.w700),
        ),
        content: Text(
          message,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              confirmText,
              style: AppTextStyles.labelLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    return result ?? false;
  }
}
