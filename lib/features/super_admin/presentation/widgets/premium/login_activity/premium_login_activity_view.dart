import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/auth/domain/entities/login_activity_entity.dart';
import 'package:spo_kick/features/auth/presentation/cubit/login_activity_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/login_activity_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/login_activity/premium_login_activity_card.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/login_activity/premium_login_activity_filter_chips.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/login_activity/premium_login_activity_stats_bar.dart';

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
          backgroundColor: AppColors.backgroundLight,
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, LoginActivityState state) {
    if (state is LoginActivityLoading) {
      return const _LoadingView();
    }

    if (state is LoginActivityError) {
      return _ErrorView(message: state.message, onRetry: _loadData);
    }

    if (state is LoginActivityLoaded) {
      return _buildLoadedContent(context, state);
    }

    return const _LoadingView();
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
      color: AppColors.goldAccent,
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
              title: 'Login Activity',
              subtitle: 'Platform security monitoring',
              showBackButton: true,
              actions: [_RefreshButton(onTap: _loadData)],
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
            const SliverFillRemaining(child: _EmptyState())
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index >= filteredActivities.length) {
                      return state.isLoadingMore
                          ? const _LoadMoreIndicator()
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

/// Refresh button for the header.
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
  const _LoadingView();

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
            'Loading login activity...',
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
              'Failed to load activity',
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
                Icons.history_rounded,
                color: AppColors.accentCyan.withValues(alpha: 0.6),
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No login activity',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No login events match\nyour filter criteria',
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

/// Load more indicator.
class _LoadMoreIndicator extends StatelessWidget {
  const _LoadMoreIndicator();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.accentCyan,
          ),
        ),
      ),
    );
  }
}
