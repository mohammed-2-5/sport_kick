import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/users_list/super_admin_users_list_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/users_list/super_admin_users_list_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/users_list/premium_users_list_header.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/users_list/premium_users_list_filters.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/users_list/premium_users_list_content.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/users_list/premium_users_bulk_action_bar.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Premium view for super admin users list management.
///
/// Features:
/// - Premium gold-themed header with glassmorphism
/// - Search functionality with blur effect
/// - Stats chips showing user counts
/// - Filter chips (All, Active, Inactive)
/// - Selection mode for bulk actions
/// - Bulk activate/deactivate
/// - Responsive grid layout
/// - Staggered animations
/// - Pull-to-refresh
/// - All logic handled by SuperAdminUsersListCubit
class PremiumSuperAdminUsersListView extends StatefulWidget {
  const PremiumSuperAdminUsersListView({super.key});

  @override
  State<PremiumSuperAdminUsersListView> createState() =>
      _PremiumSuperAdminUsersListViewState();
}

class _PremiumSuperAdminUsersListViewState
    extends State<PremiumSuperAdminUsersListView> {
  @override
  void initState() {
    super.initState();
    context.read<SuperAdminUsersListCubit>().loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: BlocConsumer<SuperAdminUsersListCubit, SuperAdminUsersListState>(
        listener: (context, state) {
          if (state is SuperAdminUsersListError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          } else if (state is SuperAdminUsersListActionSuccess) {
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
          final cubit = context.read<SuperAdminUsersListCubit>();
          final stats = cubit.getStats();

          return Stack(
            children: [
              Column(
                children: [
                  // Header with search and stats
                  PremiumUsersListHeader(
                    searchQuery: state is SuperAdminUsersListLoaded
                        ? state.searchQuery
                        : '',
                    onSearchChanged: (query) => cubit.search(query),
                    onClearSearch: () => cubit.clearSearch(),
                    stats: stats,
                    isSelectionMode: state is SuperAdminUsersListLoaded
                        ? state.isSelectionMode
                        : false,
                    onToggleSelection: () => cubit.toggleSelectionMode(),
                  ),

                  const SizedBox(height: 20),

                  // Filter chips
                  PremiumUsersListFilters(
                    selectedFilter: state is SuperAdminUsersListLoaded
                        ? state.statusFilter
                        : null,
                    onFilterChanged: (filter) => cubit.filterByStatus(filter),
                    stats: stats,
                  ),

                  const SizedBox(height: 20),

                  // Users list
                  Expanded(child: _buildContent(context, state, cubit)),
                ],
              ),

              // Bulk action bar
              if (state is SuperAdminUsersListLoaded &&
                  state.selectedIds.isNotEmpty)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: PremiumUsersBulkActionBar(
                    selectedCount: state.selectedIds.length,
                    totalCount: state.filteredUsers.length,
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
    );
  }

  Widget _buildContent(
    BuildContext context,
    SuperAdminUsersListState state,
    SuperAdminUsersListCubit cubit,
  ) {
    if (state is SuperAdminUsersListLoading) {
      return PremiumUsersListContent(
        users: const [],
        isLoading: true,
        isRefreshing: false,
        onRefresh: () {},
        isSelectionMode: false,
        selectedIds: const {},
        onToggleSelection: (_) {},
        onActivateUser: (_) {},
        onDeactivateUser: (_) {},
      );
    }

    if (state is SuperAdminUsersListLoaded) {
      final filteredUsers = state.filteredUsers;

      return PremiumUsersListContent(
        users: filteredUsers,
        isLoading: false,
        isRefreshing: state.isRefreshing,
        onRefresh: () => cubit.refresh(),
        isSelectionMode: state.isSelectionMode,
        selectedIds: state.selectedIds,
        onToggleSelection: (id) => cubit.toggleSelection(id),
        onActivateUser: (id) => cubit.activateUser(id),
        onDeactivateUser: (id) => cubit.deactivateUser(id),
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
            context.l10n.failedToLoadUsers,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => cubit.loadUsers(),
            icon: const Icon(Icons.refresh),
            label: Text(context.l10n.retry),
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

  String _getEmptyMessage(SuperAdminUsersListLoaded state) {
    if (state.searchQuery.isNotEmpty) {
      return context.l10n.noUsersMatchYourFilters;
    }

    if (state.statusFilter != null) {
      return context.l10n.noUsersMatchYourFilters;
    }

    return context.l10n.noUsersYet;
  }

  Future<void> _handleBulkActivate(
    BuildContext context,
    SuperAdminUsersListCubit cubit,
    SuperAdminUsersListLoaded state,
  ) async {
    final confirmed = await _showConfirmDialog(
      context,
      title: context.l10n.activateUsers,
      message: context.l10n.areYouSureYouWantToActivateCountUsers(
        state.selectedIds.length,
      ),
      confirmText: context.l10n.activate,
      confirmColor: Colors.green,
    );

    if (confirmed) {
      await cubit.bulkActivateUsers(state.selectedIds.toList());
    }
  }

  Future<void> _handleBulkDeactivate(
    BuildContext context,
    SuperAdminUsersListCubit cubit,
    SuperAdminUsersListLoaded state,
  ) async {
    final confirmed = await _showConfirmDialog(
      context,
      title: context.l10n.deactivateUsers,
      message: context.l10n.areYouSureYouWantToDeactivateCountUsers(
        state.selectedIds.length,
      ),
      confirmText: context.l10n.deactivate,
      confirmColor: Colors.red,
    );

    if (confirmed) {
      await cubit.bulkDeactivateUsers(state.selectedIds.toList());
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
        title: Text(title, style: AppTextStyles.titleLarge),
        content: Text(
          message,
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              context.l10n.cancel,
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
