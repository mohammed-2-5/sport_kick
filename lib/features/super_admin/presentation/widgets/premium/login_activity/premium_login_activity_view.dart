import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/auth/domain/entities/login_activity_entity.dart';
import 'package:spo_kick/features/auth/presentation/cubit/login_activity_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/login_activity_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/login_activity/components/login_activity_empty_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/login_activity/components/login_activity_error_view.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/login_activity/components/login_activity_load_more_indicator.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/login_activity/components/login_activity_loading_view.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/login_activity/components/login_activity_refresh_button.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/login_activity/premium_login_activity_card.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/login_activity/premium_login_activity_filter_chips.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/login_activity/premium_login_activity_stats_bar.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Premium login activity view for super admin.
///
/// Features:
/// - Premium curved header
/// - Stats bar with key metrics
/// - Filter chips by status
/// - Paginated login activity list
/// - Pull-to-refresh
class PremiumLoginActivityView extends StatefulWidget {
  const PremiumLoginActivityView({super.key});

  @override
  State<PremiumLoginActivityView> createState() =>
      _PremiumLoginActivityViewState();
}

class _PremiumLoginActivityViewState extends State<PremiumLoginActivityView> {
  String _filterStatus = 'all';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _loadData() {
    context.read<LoginActivityCubit>().loadAllLoginActivity();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<LoginActivityCubit>().loadMore();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  List<LoginActivityEntity> _filterActivities(
    List<LoginActivityEntity> activities,
  ) {
    if (_filterStatus == 'all') return activities;

    final status = LoginStatus.fromString(_filterStatus);
    return activities.where((a) => a.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginActivityCubit, LoginActivityState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, LoginActivityState state) {
    if (state is LoginActivityLoading) {
      return const LoginActivityLoadingView();
    }

    if (state is LoginActivityError) {
      return LoginActivityErrorView(message: state.message, onRetry: _loadData);
    }

    if (state is LoginActivityLoaded) {
      return _buildLoadedContent(context, state);
    }

    return const LoginActivityLoadingView();
  }

  Widget _buildLoadedContent(BuildContext context, LoginActivityLoaded state) {
    final activities = state.activities;
    final filteredActivities = _filterActivities(activities);

    final successCount = activities
        .where((a) => a.status == LoginStatus.success)
        .length;
    final failedCount = activities
        .where((a) => a.status == LoginStatus.failed)
        .length;
    final blockedCount = activities
        .where((a) => a.status == LoginStatus.blocked)
        .length;

    return RefreshIndicator(
      color: Theme.of(context).colorScheme.primary,
      onRefresh: () async {
        context.read<LoginActivityCubit>().refresh();
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Premium Header
          SliverToBoxAdapter(
            child: PremiumCurvedHeader(
              title: context.l10n.loginActivity,
              subtitle: context.l10n.platformSecurityMonitoring,
              showBackButton: true,
              actions: [LoginActivityRefreshButton(onTap: _loadData)],
            ),
          ),

          // Stats Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: PremiumLoginActivityStatsBar(
                totalLogins: activities.length,
                successLogins: successCount,
                failedLogins: failedCount,
                blockedLogins: blockedCount,
              ),
            ),
          ),

          // Filter Chips
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 16),
              child: PremiumLoginActivityFilterChips(
                selectedFilter: _filterStatus,
                allCount: activities.length,
                successCount: successCount,
                failedCount: failedCount,
                blockedCount: blockedCount,
                onFilterChanged: (filter) {
                  setState(() => _filterStatus = filter);
                },
              ),
            ),
          ),

          // Login Activity List
          if (filteredActivities.isEmpty)
            const SliverFillRemaining(child: LoginActivityEmptyState())
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index >= filteredActivities.length) {
                      return state.isLoadingMore
                          ? const LoginActivityLoadMoreIndicator()
                          : const SizedBox.shrink();
                    }

                    final activity = filteredActivities[index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 400),
                      child: SlideAnimation(
                        verticalOffset: 50,
                        child: FadeInAnimation(
                          child: PremiumLoginActivityCard(
                            activity: activity,
                            userName: activity.userName ?? activity.userEmail,
                            userRole: activity.userRole,
                          ),
                        ),
                      ),
                    );
                  },
                  childCount:
                      filteredActivities.length +
                      (state.hasMore && state.isLoadingMore ? 1 : 0),
                ),
              ),
            ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}
