import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/all_fields/premium_all_field_card.dart';
import 'package:spo_kick/features/super_admin/utils/field_filter_helper.dart';

/// Premium All Fields view with advanced filtering.
///
/// Features:
/// - Premium curved header
/// - Search bar with blur effect
/// - Stats row with field counts
/// - Filter chips (All, Active, Inactive)
/// - Staggered field cards list
/// - Pull-to-refresh
/// - Empty and error states
class PremiumAllFieldsView extends StatefulWidget {
  const PremiumAllFieldsView({super.key});

  @override
  State<PremiumAllFieldsView> createState() => _PremiumAllFieldsViewState();
}

class _PremiumAllFieldsViewState extends State<PremiumAllFieldsView> {
  final _searchController = TextEditingController();
  Timer? _debounceTimer;
  String _searchQuery = '';
  String _statusFilter = 'all';

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

  List<FieldEntity> _filterFields(List<FieldEntity> fields) {
    var result = FieldFilterHelper.filterFields(
      fields,
      searchQuery: _searchQuery,
      statusFilter: _statusFilter == 'all' ? null : _statusFilter,
    );
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SuperAdminCubit, SuperAdminState>(
      listener: (context, state) {
        if (state is SuperAdminError) {
          SnackbarHelper.showError(context, state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.backgroundLight,
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, SuperAdminState state) {
    if (state is SuperAdminLoading) {
      return _LoadingView(message: state.message);
    }

    if (state is SuperAdminError) {
      return _ErrorView(
        message: state.message,
        onRetry: () => context.read<SuperAdminCubit>().loadAllFields(),
      );
    }

    if (state is AllFieldsLoaded) {
      return _buildLoadedContent(context, state.fields.cast<FieldEntity>());
    }

    return const _LoadingView(message: 'Loading fields...');
  }

  Widget _buildLoadedContent(BuildContext context, List<FieldEntity> fields) {
    final filteredFields = _filterFields(fields);
    final activeCount = fields.where((f) => f.isActive).length;
    final inactiveCount = fields.length - activeCount;

    return RefreshIndicator(
      color: AppColors.goldAccent,
      onRefresh: () async {
        context.read<SuperAdminCubit>().loadAllFields();
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: CustomScrollView(
        slivers: [
          // Premium Header
          SliverToBoxAdapter(
            child: PremiumCurvedHeader(
              title: 'All Fields',
              subtitle: '${fields.length} total fields',
              showBackButton: true,
              actions: [
                _RefreshButton(
                  onTap: () => context.read<SuperAdminCubit>().loadAllFields(),
                ),
              ],
            ),
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: _SearchBar(
                controller: _searchController,
                onChanged: _onSearchChanged,
                onClear: () {
                  _searchController.clear();
                  setState(() => _searchQuery = '');
                },
              ),
            ),
          ),

          // Stats Row
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: _StatsRow(
                totalCount: fields.length,
                activeCount: activeCount,
                inactiveCount: inactiveCount,
              ),
            ),
          ),

          // Filter Chips
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: _FilterChips(
                selectedFilter: _statusFilter,
                allCount: fields.length,
                activeCount: activeCount,
                inactiveCount: inactiveCount,
                onFilterChanged: (filter) {
                  setState(() => _statusFilter = filter);
                },
              ),
            ),
          ),

          // Fields List
          if (filteredFields.isEmpty)
            const SliverFillRemaining(child: _EmptyState())
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final field = filteredFields[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 400),
                    child: SlideAnimation(
                      verticalOffset: 50,
                      child: FadeInAnimation(
                        child: PremiumAllFieldCard(
                          name: field.name,
                          cityName: field.city,
                          sportType: field.surfaceType ?? 'Football',
                          imageUrl: field.mainImage,
                          pricePerHour: field.pricePerHour,
                          rating: field.averageRating ?? 0.0,
                          reviewCount: field.totalReviews,
                          isActive: field.isActive,
                          isVerified: field.isVerified,
                          onTap: () => context.pushNamed(
                            'ownerFieldDetail',
                            pathParameters: {'fieldId': field.id},
                            extra: field,
                          ),
                        ),
                      ),
                    ),
                  );
                }, childCount: filteredFields.length),
              ),
            ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

/// Search bar widget.
class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search fields...',
          hintStyle: TextStyle(
            color: AppColors.textSecondary.withValues(alpha: 0.6),
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppColors.textSecondary.withValues(alpha: 0.6),
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close_rounded),
                  color: AppColors.textSecondary,
                  onPressed: onClear,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}

/// Stats row widget.
class _StatsRow extends StatelessWidget {
  final int totalCount;
  final int activeCount;
  final int inactiveCount;

  const _StatsRow({
    required this.totalCount,
    required this.activeCount,
    required this.inactiveCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatChip(label: 'Total', count: totalCount, color: AppColors.navyDeep),
        const SizedBox(width: 12),
        _StatChip(
          label: 'Active',
          count: activeCount,
          color: const Color(0xFF10B981),
        ),
        const SizedBox(width: 12),
        _StatChip(
          label: 'Inactive',
          count: inactiveCount,
          color: const Color(0xFFEF4444),
        ),
      ],
    );
  }
}

/// Individual stat chip.
class _StatChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatChip({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$count',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              fontWeight: FontWeight.w500,
              color: color.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

/// Filter chips widget.
class _FilterChips extends StatelessWidget {
  final String selectedFilter;
  final int allCount;
  final int activeCount;
  final int inactiveCount;
  final ValueChanged<String> onFilterChanged;

  const _FilterChips({
    required this.selectedFilter,
    required this.allCount,
    required this.activeCount,
    required this.inactiveCount,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _FilterChip(
          label: 'All',
          isSelected: selectedFilter == 'all',
          onTap: () => onFilterChanged('all'),
        ),
        const SizedBox(width: 10),
        _FilterChip(
          label: 'Active',
          isSelected: selectedFilter == 'active',
          onTap: () => onFilterChanged('active'),
        ),
        const SizedBox(width: 10),
        _FilterChip(
          label: 'Inactive',
          isSelected: selectedFilter == 'inactive',
          onTap: () => onFilterChanged('inactive'),
        ),
      ],
    );
  }
}

/// Individual filter chip.
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.navyDeep : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.navyDeep
                : AppColors.border.withValues(alpha: 0.5),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.navyDeep.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

/// Refresh button.
class _RefreshButton extends StatelessWidget {
  final VoidCallback onTap;

  const _RefreshButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.glassHighlight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: const Icon(
          Icons.refresh_rounded,
          color: AppColors.textOnNavy,
          size: 22,
        ),
        onPressed: onTap,
      ),
    );
  }
}

/// Loading view.
class _LoadingView extends StatelessWidget {
  final String message;

  const _LoadingView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: AppColors.goldAccent,
            strokeWidth: 3,
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Error view.
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

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
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: Colors.red,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Failed to load fields',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navyDeep,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Empty state.
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.accentCyan.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.sports_soccer_rounded,
                color: AppColors.accentCyan.withValues(alpha: 0.6),
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No fields found',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search\nor filters',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
