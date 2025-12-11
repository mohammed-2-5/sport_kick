import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/analytics/premium_booking_stat_card.dart';

/// Premium Stats Grid for bookings.
///
/// Features:
/// - 2x2 grid layout
/// - Gradient icons
/// - Animated counters
/// - Subtle shadows
class PremiumBookingStatsGrid extends StatelessWidget {
  /// Total bookings count.
  final int totalBookings;

  /// Confirmed bookings count.
  final int confirmedBookings;

  /// Pending bookings count.
  final int pendingBookings;

  /// Canceled bookings count.
  final int canceledBookings;

  const PremiumBookingStatsGrid({
    super.key,
    required this.totalBookings,
    required this.confirmedBookings,
    required this.pendingBookings,
    required this.canceledBookings,
  });

  @override
  Widget build(BuildContext context) {
    final stats = [
      BookingStatData(
        label: 'Total',
        value: totalBookings,
        icon: Icons.calendar_month_rounded,
        gradient: const [Color(0xFF6366F1), Color(0xFF8B5CF6)],
      ),
      BookingStatData(
        label: 'Confirmed',
        value: confirmedBookings,
        icon: Icons.check_circle_rounded,
        gradient: const [Color(0xFF10B981), Color(0xFF059669)],
      ),
      BookingStatData(
        label: 'Pending',
        value: pendingBookings,
        icon: Icons.schedule_rounded,
        gradient: const [Color(0xFFF59E0B), Color(0xFFD97706)],
      ),
      BookingStatData(
        label: 'Canceled',
        value: canceledBookings,
        icon: Icons.cancel_rounded,
        gradient: const [Color(0xFFEF4444), Color(0xFFDC2626)],
      ),
    ];

    return AnimationLimiter(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.4,
        ),
        itemCount: stats.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredGrid(
            position: index,
            columnCount: 2,
            duration: const Duration(milliseconds: 400),
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: PremiumBookingStatCard(stat: stats[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}
