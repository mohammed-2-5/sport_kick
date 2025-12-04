import 'package:flutter/material.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/stat_card.dart';

/// Bookings statistics section widget
///
/// Displays overview statistics for all bookings including:
/// - Total bookings count
/// - Status breakdowns (pending, confirmed, canceled, completed)
/// - Total revenue
class BookingsStatisticsSection extends StatelessWidget {
  final List<BookingEntity> bookings;

  const BookingsStatisticsSection({super.key, required this.bookings});

  @override
  Widget build(BuildContext context) {
    final totalBookings = bookings.length;
    final pendingCount = bookings
        .where((b) => b.status == BookingStatus.pending)
        .length;
    final confirmedCount = bookings
        .where((b) => b.status == BookingStatus.confirmed)
        .length;
    final canceledCount = bookings
        .where((b) => b.status == BookingStatus.canceled)
        .length;
    final completedCount = bookings
        .where((b) => b.status == BookingStatus.completed)
        .length;
    final totalRevenue = bookings
        .where(
          (b) =>
              b.status == BookingStatus.confirmed ||
              b.status == BookingStatus.completed,
        )
        .fold<double>(0, (sum, booking) => sum + booking.totalPrice);

    return Container(
      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bookings Overview',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  label: 'Total',
                  value: totalBookings.toString(),
                  icon: Icons.event,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  label: 'Pending',
                  value: pendingCount.toString(),
                  icon: Icons.schedule,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  label: 'Confirmed',
                  value: confirmedCount.toString(),
                  icon: Icons.check_circle,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  label: 'Completed',
                  value: completedCount.toString(),
                  icon: Icons.done_all,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  label: 'Canceled',
                  value: canceledCount.toString(),
                  icon: Icons.cancel,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  label: 'Revenue',
                  value: '${totalRevenue.toStringAsFixed(0)} EGP',
                  icon: Icons.attach_money,
                  color: Colors.teal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
