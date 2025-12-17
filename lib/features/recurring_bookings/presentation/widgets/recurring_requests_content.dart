import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/cubit/recurring_requests_state.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/widgets/recurring_request_card.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/widgets/active_subscription_card.dart';

/// Content widget for recurring requests page (owner view).
class RecurringRequestsContent extends StatelessWidget {
  final RecurringRequestsLoaded state;
  final Function(String) onApprove;
  final Function(String) onReject;
  final VoidCallback onRefresh;

  const RecurringRequestsContent({
    required this.state,
    required this.onApprove,
    required this.onReject,
    required this.onRefresh,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isEmpty = !state.hasPendingRequests && !state.hasActiveSubscriptions;

    if (isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      color: AppColors.accentCyan,
      child: CustomScrollView(
        slivers: [
          // Stats header
          SliverToBoxAdapter(child: _buildStatsHeader()),

          // Pending requests section
          if (state.hasPendingRequests) ...[
            _buildSectionHeader(
              'Pending Requests',
              badge: state.pendingCount.toString(),
              badgeColor: AppColors.goldAccent,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final request = state.pendingRequests[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: RecurringRequestCard(
                    request: request,
                    isProcessing: state.isProcessing(request.id),
                    onApprove: () => onApprove(request.id),
                    onReject: () => onReject(request.id),
                  ),
                );
              }, childCount: state.pendingRequests.length),
            ),
          ],

          // Active subscriptions section
          if (state.hasActiveSubscriptions) ...[
            _buildSectionHeader(
              'Active Subscriptions',
              badge: state.activeCount.toString(),
              badgeColor: const Color(0xFF10B981),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final subscription = state.activeSubscriptions[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ActiveSubscriptionCard(subscription: subscription),
                );
              }, childCount: state.activeSubscriptions.length),
            ),
          ],

          // Bottom padding
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
    );
  }

  Widget _buildStatsHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.navyDeep,
            AppColors.navyDeep.withValues(alpha: 0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.navyDeep.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              icon: Icons.hourglass_empty_rounded,
              value: state.pendingCount.toString(),
              label: 'Pending',
              color: AppColors.goldAccent,
            ),
          ),
          Container(
            width: 1,
            height: 50,
            color: Colors.white.withValues(alpha: 0.2),
          ),
          Expanded(
            child: _buildStatItem(
              icon: Icons.autorenew_rounded,
              value: state.activeCount.toString(),
              label: 'Active',
              color: const Color(0xFF10B981),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  SliverToBoxAdapter _buildSectionHeader(
    String title, {
    String? badge,
    Color? badgeColor,
  }) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: badgeColor ?? AppColors.accentCyan,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.navyDeep,
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color:
                      badgeColor?.withValues(alpha: 0.15) ??
                      AppColors.accentCyan.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: badgeColor ?? AppColors.accentCyan,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
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
                color: AppColors.navyDeep.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.event_repeat_rounded,
                size: 48,
                color: AppColors.navyDeep.withValues(alpha: 0.4),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Recurring Subscriptions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.navyDeep,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'When users request weekly recurring bookings, they\'ll appear here for your approval.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
