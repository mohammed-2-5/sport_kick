import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/cubit/my_recurring_bookings_state.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/widgets/recurring_booking_card.dart';

/// Content widget for my recurring bookings page.
class MyRecurringBookingsContent extends StatelessWidget {
  final MyRecurringBookingsLoaded state;
  final Function(String)? onCancel;
  final Future<void> Function() onRefresh;

  const MyRecurringBookingsContent({
    required this.state,
    required this.onCancel,
    required this.onRefresh,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (state.isEmpty) {
      return _buildEmptyState(context);
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.accentCyan,
      child: CustomScrollView(
        slivers: [
          // Header with summary
          SliverToBoxAdapter(child: _buildSummaryHeader()),

          // Active subscriptions section
          if (state.hasActive) ...[
            _buildSectionHeader('Active Subscriptions'),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final booking = state.activeBookings[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: RecurringBookingCard(
                    booking: booking,
                    onCancel: onCancel != null
                        ? () => onCancel!(booking.id)
                        : null,
                  ),
                );
              }, childCount: state.activeBookings.length),
            ),
          ],

          // Pending approvals section
          if (state.hasPending) ...[
            _buildSectionHeader('Pending Approval'),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final booking = state.pendingBookings[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: RecurringBookingCard(booking: booking),
                );
              }, childCount: state.pendingBookings.length),
            ),
          ],

          // History section (canceled/rejected)
          if (state.otherBookings.isNotEmpty) ...[
            _buildSectionHeader('History'),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final booking = state.otherBookings[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Opacity(
                    opacity: 0.7,
                    child: RecurringBookingCard(booking: booking),
                  ),
                );
              }, childCount: state.otherBookings.length),
            ),
          ],

          // Bottom padding
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
    );
  }

  Widget _buildSummaryHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.accentCyan,
            AppColors.accentCyan.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentCyan.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.event_repeat_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Weekly Reservations',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${state.activeBookings.length} active • ${state.pendingBookings.length} pending',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildSectionHeader(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: AppColors.accentCyan,
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
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.accentCyan.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.event_repeat_rounded,
                size: 56,
                color: AppColors.accentCyan.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Subscriptions Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.navyDeep,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Reserve your favorite weekly slot and never miss a game!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 32),
            _buildBenefitsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitsList() {
    return Column(
      children: [
        _buildBenefitItem(
          icon: Icons.lock_clock_rounded,
          text: 'Guaranteed weekly slot',
        ),
        _buildBenefitItem(
          icon: Icons.autorenew_rounded,
          text: 'Auto-renews every week',
        ),
        _buildBenefitItem(
          icon: Icons.notifications_active_rounded,
          text: 'Payment reminders',
        ),
      ],
    );
  }

  Widget _buildBenefitItem({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: const Color(0xFF10B981)),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(fontSize: 14, color: AppColors.navyDeep),
          ),
        ],
      ),
    );
  }
}
