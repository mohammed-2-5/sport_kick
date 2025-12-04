import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/admins_list/admin_list_empty_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/admins_list/admin_list_search_bar.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/admins_list/admin_list_stats.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/admins_list/selectable_admin_card.dart';

/// Main list body widget for admins list.
///
/// Displays search bar, stats, and scrollable list of admin cards.
class AdminListBody extends StatelessWidget {
  /// Search controller
  final TextEditingController searchController;

  /// Current search query
  final String searchQuery;

  /// Filtered admins to display
  final List<UserEntity> filteredAdmins;

  /// Total admins count (before filtering)
  final int totalCount;

  /// Whether in selection mode
  final bool isSelectionMode;

  /// Selected admins count
  final int selectedCount;

  /// Selected admin IDs
  final Set<String> selectedIds;

  /// Whether search/filter is empty
  final bool isSearchEmpty;

  /// Callback for search changed
  final ValueChanged<String> onSearchChanged;

  /// Callback for clear search
  final VoidCallback onClearSearch;

  /// Callback for admin card tap
  final void Function(UserEntity admin, bool isSelected) onAdminTap;

  /// Callback for admin card long press
  final ValueChanged<String> onAdminLongPress;

  const AdminListBody({
    required this.searchController,
    required this.searchQuery,
    required this.filteredAdmins,
    required this.totalCount,
    required this.isSelectionMode,
    required this.selectedCount,
    required this.selectedIds,
    required this.isSearchEmpty,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.onAdminTap,
    required this.onAdminLongPress,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<SuperAdminCubit>().loadAdmins();
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: Column(
        children: [
          AdminListSearchBar(
            controller: searchController,
            searchQuery: searchQuery,
            onChanged: onSearchChanged,
            onClear: onClearSearch,
          ),
          AdminListStats(
            filteredCount: filteredAdmins.length,
            totalCount: totalCount,
            isSelectionMode: isSelectionMode,
            selectedCount: selectedCount,
          ),
          Expanded(
            child: filteredAdmins.isEmpty
                ? AdminListEmptyState(isSearchEmpty: isSearchEmpty)
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: filteredAdmins.length,
                    itemBuilder: (context, index) {
                      final admin = filteredAdmins[index];
                      final isSelected = selectedIds.contains(admin.id);

                      return SelectableAdminCard(
                        admin: admin,
                        isSelectionMode: isSelectionMode,
                        isSelected: isSelected,
                        onTap: () => onAdminTap(admin, isSelected),
                        onLongPress: () => onAdminLongPress(admin.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
