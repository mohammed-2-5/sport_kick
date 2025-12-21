import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/premium_admin_card.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/premium_admin_filter_chips.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/premium_admin_search_bar.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/premium_bulk_action_bar.dart';

/// Premium admins list view for super admin.
///
/// Features:
/// - Premium curved header with gold accent
/// - Search and filter
/// - Responsive grid layout
/// - Bulk selection mode
/// - Create admin button
/// - Staggered animations
class PremiumAdminsListView extends StatefulWidget {
  const PremiumAdminsListView({super.key});

  @override
  State<PremiumAdminsListView> createState() => _PremiumAdminsListViewState();
}

class _PremiumAdminsListViewState extends State<PremiumAdminsListView> {
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

  void _selectAll(List<UserEntity> admins) {
    setState(() {
      _selectedIds = admins.map((a) => a.id).toSet();
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
          } else if (state is AdminAccountCreated) {
            SnackbarHelper.showSuccess(context, state.successMessage);
          }
        },
        builder: (context, state) {
          List<UserEntity> admins = [];
          if (state is AdminsListLoaded) {
            admins = state.admins;
          }

          // Filter by search and status
          var filteredAdmins = admins.where((admin) {
            final matchesSearch =
                _searchController.text.isEmpty ||
                (admin.fullName?.toLowerCase().contains(
                      _searchController.text.toLowerCase(),
                    ) ??
                    false) ||
                admin.email.toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                );

            final matchesStatus =
                _selectedStatus == null ||
                (_selectedStatus == 'Active' && admin.isActive) ||
                (_selectedStatus == 'Inactive' && !admin.isActive);

            return matchesSearch && matchesStatus;
          }).toList();

          final activeCount = admins.where((a) => a.isActive).length;
          final inactiveCount = admins.where((a) => !a.isActive).length;

          return Stack(
            children: [
              Column(
                children: [
                  // Premium Header
                  PremiumCurvedHeader(
                    title: context.l10n.fieldOwners,
                    subtitle: context.l10n.totalAdminsCount(admins.length),
                    showBackButton: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: _toggleSelectionMode,
                          icon: Icon(
                            _isSelectionMode ? Icons.close : Icons.checklist,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            context.pushNamed('createAdmin');
                          },
                          icon: const Icon(
                            Icons.person_add,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context.read<SuperAdminCubit>().loadAdmins();
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
                              hintText: context.l10n.searchAdmins,
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
                              allCount: admins.length,
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
                                filteredAdmins.isEmpty)
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
                                onCreateAdmin: () {
                                  context.pushNamed('createAdmin');
                                },
                              ),

                            // Admins list
                            if (filteredAdmins.isNotEmpty)
                              _buildAdminsList(filteredAdmins),

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
                  totalCount: filteredAdmins.length,
                  onSelectAll: () => _selectAll(filteredAdmins),
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

  Widget _buildAdminsList(List<UserEntity> admins) {
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
            children: admins
                .map(
                  (admin) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildAdminCard(admin),
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
          childAspectRatio: 1.3,
        ),
        itemCount: admins.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 375),
            columnCount: crossAxisCount,
            child: ScaleAnimation(
              child: FadeInAnimation(child: _buildAdminCard(admins[index])),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAdminCard(UserEntity admin) {
    return PremiumAdminCard(
      id: admin.id,
      name: admin.fullName ?? 'Unknown',
      email: admin.email,
      phone: admin.phone,
      isActive: admin.isActive,
      fieldsCount: 0, // Would come from admin data
      revenue: 0, // Would come from admin data
      isSelected: _selectedIds.contains(admin.id),
      isSelectable: _isSelectionMode,
      onTap: () {
        if (_isSelectionMode) {
          _toggleSelection(admin.id);
        } else {
          context.pushNamed('superAdminAdminDetails', extra: admin);
        }
      },
      onSelectionChanged: (selected) => _toggleSelection(admin.id),
      onAssignField: _isSelectionMode
          ? null
          : () {
              // Show assign field dialog
            },
      onToggleStatus: _isSelectionMode
          ? null
          : () {
              context.read<SuperAdminCubit>().toggleAdminStatus(
                admin.id,
                !admin.isActive,
              );
            },
      onDelete: null,
    );
  }

  void _handleBulkAction(String action) {
    HapticFeedback.mediumImpact();
    final ids = _selectedIds.toList();
    switch (action) {
      case 'activate':
        context.read<SuperAdminCubit>().bulkActivateAdmins(ids);
        break;
      case 'deactivate':
        context.read<SuperAdminCubit>().bulkDeactivateAdmins(ids);
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
  final VoidCallback onCreateAdmin;

  const _EmptyState({
    required this.hasFilters,
    required this.onClearFilters,
    required this.onCreateAdmin,
  });

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
                gradient: LinearGradient(
                  colors: [
                    AppColors.premiumGold.withValues(alpha: 0.2),
                    AppColors.premiumGoldDark.withValues(alpha: 0.1),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.admin_panel_settings,
                size: 40,
                color: AppColors.premiumGold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              hasFilters
                  ? context.l10n.noAdminsMatchYourFilters
                  : context.l10n.noAdminsFound,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hasFilters
                  ? context.l10n.tryAdjustingYourSearchOrFilters
                  : 'Create your first admin to get started',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textSecondary.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (hasFilters)
              TextButton(
                onPressed: onClearFilters,
                child: Text(
                  context.l10n.clearFilters,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.premiumGold,
                  ),
                ),
              )
            else
              PremiumButton(
                label: context.l10n.createAdmin,
                onPressed: onCreateAdmin,
                icon: Icons.person_add,
              ),
          ],
        ),
      ),
    );
  }
}
