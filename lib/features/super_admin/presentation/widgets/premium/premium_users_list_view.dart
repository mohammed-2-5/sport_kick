import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/premium_admin_filter_chips.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/premium_admin_search_bar.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/premium_bulk_action_bar.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/premium_user_card.dart';

/// Premium users list view for super admin.
///
/// Features:
/// - Premium curved header
/// - Search and filter
/// - Responsive grid layout
/// - Bulk selection mode
/// - Staggered animations
class PremiumUsersListView extends StatefulWidget {
  const PremiumUsersListView({super.key});

  @override
  State<PremiumUsersListView> createState() => _PremiumUsersListViewState();
}

class _PremiumUsersListViewState extends State<PremiumUsersListView> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedStatus;
  bool _isSelectionMode = false;
  Set<String> _selectedIds = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSelectionMode() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedIds.clear();
      }
    });
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _selectAll(List<UserEntity> users) {
    setState(() {
      _selectedIds = users.map((u) => u.id).toSet();
    });
  }

  void _deselectAll() {
    setState(() {
      _selectedIds.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: BlocConsumer<SuperAdminCubit, SuperAdminState>(
        listener: (context, state) {
          if (state is SuperAdminError) {
            SnackbarHelper.showError(context, state.message);
          } else if (state is BulkActionCompleted) {
            SnackbarHelper.showSuccess(context, state.message);
            setState(() {
              _selectedIds.clear();
              _isSelectionMode = false;
            });
          } else if (state is UserActivated) {
            SnackbarHelper.showSuccess(context, 'User activated');
          } else if (state is UserDeactivated) {
            SnackbarHelper.showSuccess(context, 'User deactivated');
          }
        },
        builder: (context, state) {
          List<UserEntity> users = [];
          if (state is UsersListLoaded) {
            users = state.users;
          }

          // Filter by search and status
          var filteredUsers = users.where((user) {
            final matchesSearch =
                _searchController.text.isEmpty ||
                (user.fullName?.toLowerCase().contains(
                      _searchController.text.toLowerCase(),
                    ) ??
                    false) ||
                user.email.toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                );

            final matchesStatus =
                _selectedStatus == null ||
                (_selectedStatus == 'Active' && user.isActive) ||
                (_selectedStatus == 'Inactive' && !user.isActive);

            return matchesSearch && matchesStatus;
          }).toList();

          final activeCount = users.where((u) => u.isActive).length;
          final inactiveCount = users.where((u) => !u.isActive).length;

          return Stack(
            children: [
              Column(
                children: [
                  // Premium Header
                  PremiumCurvedHeader(
                    title: 'Users',
                    subtitle: '${users.length} total users',
                    showBackButton: true,
                    trailing: IconButton(
                      onPressed: _toggleSelectionMode,
                      icon: Icon(
                        _isSelectionMode ? Icons.close : Icons.checklist,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // Content
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context.read<SuperAdminCubit>().loadUsers();
                      },
                      color: AppColors.premiumGold,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // Search bar
                            PremiumAdminSearchBar(
                              controller: _searchController,
                              hintText: 'Search users...',
                              onChanged: (value) => setState(() {}),
                              hasActiveFilters: _selectedStatus != null,
                              onFilterTap: () {
                                // Show filter sheet
                              },
                            ),
                            const SizedBox(height: 16),

                            // Filter chips
                            PremiumStatusFilterChips(
                              selectedStatus: _selectedStatus,
                              allCount: users.length,
                              activeCount: activeCount,
                              inactiveCount: inactiveCount,
                              onStatusSelected: (status) {
                                setState(() => _selectedStatus = status);
                              },
                            ),
                            const SizedBox(height: 20),

                            // Loading state
                            if (state is SuperAdminLoading)
                              const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.premiumGold,
                                ),
                              ),

                            // Empty state
                            if (state is! SuperAdminLoading &&
                                filteredUsers.isEmpty)
                              _EmptyState(
                                hasFilters:
                                    _selectedStatus != null ||
                                    _searchController.text.isNotEmpty,
                                onClearFilters: () {
                                  setState(() {
                                    _selectedStatus = null;
                                    _searchController.clear();
                                  });
                                },
                              ),

                            // Users list
                            if (filteredUsers.isNotEmpty)
                              _buildUsersList(filteredUsers),

                            // Space for bulk action bar
                            if (_selectedIds.isNotEmpty)
                              const SizedBox(height: 80),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Bulk action bar
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: PremiumBulkActionBar(
                  selectedCount: _selectedIds.length,
                  totalCount: filteredUsers.length,
                  onSelectAll: () => _selectAll(filteredUsers),
                  onDeselectAll: _deselectAll,
                  onActivate: () => _handleBulkAction('activate'),
                  onDeactivate: () => _handleBulkAction('deactivate'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUsersList(List<UserEntity> users) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 900 ? 3 : (screenWidth > 600 ? 2 : 1);

    if (crossAxisCount == 1) {
      return AnimationLimiter(
        child: Column(
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 375),
            childAnimationBuilder: (widget) => SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(child: widget),
            ),
            children: users
                .map(
                  (user) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildUserCard(user),
                  ),
                )
                .toList(),
          ),
        ),
      );
    }

    return AnimationLimiter(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.4,
        ),
        itemCount: users.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 375),
            columnCount: crossAxisCount,
            child: ScaleAnimation(
              child: FadeInAnimation(child: _buildUserCard(users[index])),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserCard(UserEntity user) {
    return PremiumUserCard(
      id: user.id,
      name: user.fullName ?? 'Unknown',
      email: user.email,
      phone: user.phone,
      isActive: user.isActive,
      bookingsCount: 0, // Would come from user data
      isSelected: _selectedIds.contains(user.id),
      isSelectable: _isSelectionMode,
      onTap: () {
        if (_isSelectionMode) {
          _toggleSelection(user.id);
        } else {
          context.pushNamed('superAdminUserDetails', extra: user);
        }
      },
      onSelectionChanged: (selected) => _toggleSelection(user.id),
      onToggleStatus: _isSelectionMode
          ? null
          : () {
              final cubit = context.read<SuperAdminCubit>();
              if (user.isActive) {
                cubit.deactivateUser(user.id);
              } else {
                cubit.activateUser(user.id);
              }
            },
      onDelete: null,
    );
  }

  void _handleBulkAction(String action) {
    HapticFeedback.mediumImpact();
    final ids = _selectedIds.toList();
    switch (action) {
      case 'activate':
        context.read<SuperAdminCubit>().bulkActivateUsers(ids);
        break;
      case 'deactivate':
        context.read<SuperAdminCubit>().bulkDeactivateUsers(ids);
        break;
      default:
        break;
    }
  }
}

/// Empty state widget.
class _EmptyState extends StatelessWidget {
  final bool hasFilters;
  final VoidCallback onClearFilters;

  const _EmptyState({required this.hasFilters, required this.onClearFilters});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.premiumGold.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.people_outline,
                size: 40,
                color: AppColors.premiumGold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              hasFilters ? 'No users match your filters' : 'No users found',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hasFilters
                  ? 'Try adjusting your search or filters'
                  : 'Users will appear here once they register',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textSecondary.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            if (hasFilters) ...[
              const SizedBox(height: 16),
              TextButton(
                onPressed: onClearFilters,
                child: Text(
                  'Clear Filters',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.premiumGold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
