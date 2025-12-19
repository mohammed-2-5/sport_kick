import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/recurring_bookings/domain/entities/recurring_booking_entity.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/widgets/recurring_status_badge.dart';

/// Detail page for viewing a recurring booking subscription.
///
/// Displays comprehensive information about the subscription including:
/// - Field info and schedule
/// - Status and progress
/// - Next upcoming booking
/// - Cancel/manage actions
class RecurringBookingDetailPage extends StatelessWidget {
  final RecurringBookingEntity booking;

  const RecurringBookingDetailPage({required this.booking, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildScheduleCard(),
                  const SizedBox(height: 16),
                  _buildStatsCard(),
                  if (booking.nextBookingDate != null) ...[
                    const SizedBox(height: 16),
                    _buildNextBookingCard(),
                  ],
                  if (booking.isActive) ...[
                    const SizedBox(height: 24),
                    _buildCancelButton(context),
                  ],
                  if (booking.status == RecurringBookingStatus.rejected &&
                      booking.rejectionReason != null) ...[
                    const SizedBox(height: 16),
                    _buildRejectionCard(),
                  ],
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 180,
      pinned: true,
      backgroundColor: AppColors.navyDeep,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
        ),
        color: Colors.white,
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/bookings');
          }
        },
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.navyDeep,
                AppColors.navyDeep.withValues(alpha: 0.8),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(60, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.event_repeat_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking.fieldName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (booking.cityName != null)
                              Text(
                                booking.cityName!,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontSize: 14,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  RecurringStatusBadge(status: booking.status),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleCard() {
    return _Card(
      title: 'Schedule',
      icon: Icons.schedule_rounded,
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.calendar_today_rounded,
            label: 'Day',
            value: 'Every ${booking.dayName}',
            color: AppColors.accentCyan,
          ),
          const Divider(height: 24),
          _InfoRow(
            icon: Icons.access_time_rounded,
            label: 'Time',
            value: booking.timeRange,
            color: AppColors.navyDeep,
          ),
          const Divider(height: 24),
          _InfoRow(
            icon: Icons.timer_outlined,
            label: 'Duration',
            value:
                '${booking.durationHours} hour${booking.durationHours > 1 ? 's' : ''}',
            color: Colors.orange,
          ),
          const Divider(height: 24),
          _InfoRow(
            icon: Icons.payments_outlined,
            label: 'Weekly Price',
            value: '${booking.pricePerBooking.toStringAsFixed(0)} EGP',
            color: const Color(0xFF10B981),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    final progress = booking.totalBookingsCount > 0
        ? booking.completedBookingsCount / booking.totalBookingsCount
        : 0.0;

    return _Card(
      title: 'Statistics',
      icon: Icons.bar_chart_rounded,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                value: booking.totalBookingsCount.toString(),
                label: 'Total',
                color: AppColors.navyDeep,
              ),
              _StatItem(
                value: booking.completedBookingsCount.toString(),
                label: 'Completed',
                color: const Color(0xFF10B981),
              ),
              _StatItem(
                value:
                    (booking.totalBookingsCount -
                            booking.completedBookingsCount)
                        .toString(),
                label: 'Upcoming',
                color: AppColors.accentCyan,
              ),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.navyDeep.withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF10B981),
              ),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(progress * 100).toInt()}% completed',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextBookingCard() {
    final isPaid = booking.nextBookingPaid ?? false;
    final dateFormat = DateFormat('EEEE, MMM d, y');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isPaid
              ? [const Color(0xFF10B981), const Color(0xFF059669)]
              : [
                  AppColors.goldAccent,
                  AppColors.goldAccent.withValues(alpha: 0.8),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isPaid ? const Color(0xFF10B981) : AppColors.goldAccent)
                .withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isPaid ? Icons.check_circle_rounded : Icons.payment_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Next Booking',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateFormat.format(booking.nextBookingDate!),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              isPaid ? '✓ Paid' : 'Pay Now',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isPaid ? const Color(0xFF10B981) : AppColors.goldAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRejectionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.block_rounded, color: AppColors.error, size: 20),
              SizedBox(width: 10),
              Text(
                'Rejection Reason',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            booking.rejectionReason!,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _showCancelDialog(context),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.error,
          side: BorderSide(color: AppColors.error.withValues(alpha: 0.5)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        icon: const Icon(Icons.cancel_outlined, size: 20),
        label: const Text(
          'Cancel Subscription',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Future<void> _showCancelDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.cancel_outlined, color: AppColors.error, size: 24),
            SizedBox(width: 12),
            Text('Cancel Subscription?'),
          ],
        ),
        content: const Text(
          'Bookings within the next 7 days will still be honored. '
          'Only future bookings will be canceled.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      // Pop back to the list page and let it handle the cancellation
      context.pop(true); // Return true to indicate cancellation requested
    }
  }
}

/// Reusable card wrapper with title and icon.
class _Card extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _Card({required this.title, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.navyDeep.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.accentCyan),
              const SizedBox(width: 8),
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
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

/// Info row with icon, label, and value.
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.navyDeep,
          ),
        ),
      ],
    );
  }
}

/// Statistics item widget.
class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
