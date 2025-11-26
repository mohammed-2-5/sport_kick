import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_gradients.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/owner/presentation/widgets/stat_card.dart';

/// Dashboard statistics section showing key metrics
///
/// Displays:
/// - Total bookings count
/// - Pending bookings count
/// - Total fields count
/// - Total revenue
class DashboardStatsSection extends StatelessWidget {
  final List<BookingEntity> bookings;
  final List<FieldEntity> fields;
  final double revenue;

  const DashboardStatsSection({
    super.key,
    required this.bookings,
    required this.fields,
    required this.revenue,
  });

  @override
  Widget build(BuildContext context) {
    final int totalBookings = bookings.length;
    final int pendingBookings = bookings
        .where((b) => b.status.toString().contains('pending'))
        .length;
    final int totalFields = fields.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Overview',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Total Bookings',
                value: totalBookings.toString(),
                icon: Icons.calendar_month_rounded,
                gradient: const LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                title: 'Pending',
                value: pendingBookings.toString(),
                icon: Icons.pending_actions_rounded,
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFA726), Color(0xFFFFB74D)],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'My Fields',
                value: totalFields.toString(),
                icon: Icons.sports_soccer_rounded,
                gradient: const LinearGradient(
                  colors: [Color(0xFF42A5F5), Color(0xFF64B5F6)],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                title: 'Revenue',
                value: '\$${revenue.toStringAsFixed(0)}',
                icon: Icons.attach_money_rounded,
                gradient: AppGradients.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
