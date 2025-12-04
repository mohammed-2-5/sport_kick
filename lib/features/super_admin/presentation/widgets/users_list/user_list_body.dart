import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/users_list/user_list_empty_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/users_list/user_list_search_bar.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/users_list/user_list_stats.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/users_list/selectable_user_card.dart';

/// Main list body widget for users list.
///
/// Displays search bar, stats, and scrollable list of user cards.
class UserListBody extends StatelessWidget {
  final TextEditingController searchController;
  final String searchQuery;
  final List<UserEntity> filteredUsers;
  final int totalCount;
  final int activeCount;
  final bool isSelectionMode;
  final int selectedCount;
  final Set<String> selectedIds;
  final bool hasFilters;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final void Function(UserEntity user, bool isSelected) onUserTap;
  final ValueChanged<String> onUserLongPress;

  const UserListBody({
    required this.searchController,
    required this.searchQuery,
    required this.filteredUsers,
    required this.totalCount,
    required this.activeCount,
    required this.isSelectionMode,
    required this.selectedCount,
    required this.selectedIds,
    required this.hasFilters,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.onUserTap,
    required this.onUserLongPress,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<SuperAdminCubit>().loadUsers();
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: Column(
        children: [
          UserListSearchBar(
            controller: searchController,
            searchQuery: searchQuery,
            onChanged: onSearchChanged,
            onClear: onClearSearch,
          ),
          UserListStats(
            filteredCount: filteredUsers.length,
            totalCount: totalCount,
            activeCount: activeCount,
            isSelectionMode: isSelectionMode,
            selectedCount: selectedCount,
          ),
          Expanded(
            child: filteredUsers.isEmpty
                ? UserListEmptyState(hasFilters: hasFilters)
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      final isSelected = selectedIds.contains(user.id);

                      return SelectableUserCard(
                        user: user,
                        isSelectionMode: isSelectionMode,
                        isSelected: isSelected,
                        onTap: () => onUserTap(user, isSelected),
                        onLongPress: () => onUserLongPress(user.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
