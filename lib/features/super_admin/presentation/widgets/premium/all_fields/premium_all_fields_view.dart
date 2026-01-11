import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/all_fields/premium_all_field_card.dart';
import 'package:spo_kick/features/super_admin/utils/field_filter_helper.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/all_fields/components/search_bar.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/all_fields/components/stats_row.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/all_fields/components/filter_chips.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/all_fields/components/refresh_button.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/all_fields/components/loading_view.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/all_fields/components/error_view.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/all_fields/components/empty_state.dart';

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
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, SuperAdminState state) {
    if (state is SuperAdminLoading) {
      return AllFieldsLoadingView(message: state.message);
    }

    if (state is SuperAdminError) {
      return AllFieldsErrorView(
        message: state.message,
        onRetry: () => context.read<SuperAdminCubit>().loadAllFields(),
      );
    }

    if (state is AllFieldsLoaded) {
      return _buildLoadedContent(context, state.fields.cast<FieldEntity>());
    }

    return AllFieldsLoadingView(message: context.l10n.loadingFields);
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
              title: context.l10n.allFields,
              subtitle: context.l10n.totalFieldsCount(fields.length),
              showBackButton: true,
              actions: [
                AllFieldsRefreshButton(
                  onTap: () => context.read<SuperAdminCubit>().loadAllFields(),
                ),
              ],
            ),
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: AllFieldsSearchBar(
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
              child: AllFieldsStatsRow(
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
              child: AllFieldsFilterChips(
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
            const SliverFillRemaining(child: AllFieldsEmptyState())
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
