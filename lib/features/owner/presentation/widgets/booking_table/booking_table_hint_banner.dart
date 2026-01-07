import 'package:flutter/material.dart';
import 'package:spo_kick/features/owner/presentation/widgets/booking_table/booking_table_hint_banner/empty_state_hint.dart';
import 'package:spo_kick/features/owner/presentation/widgets/booking_table/booking_table_hint_banner/scroll_hint.dart';

/// Hint banner for booking table.
///
/// Shows either:
/// - Scroll hint when bookings exist
/// - Empty state message when no bookings
class BookingTableHintBanner extends StatelessWidget {
  final bool hasBookings;

  const BookingTableHintBanner({required this.hasBookings, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          if (!hasBookings) const EmptyStateHint() else const ScrollHint(),
        ],
      ),
    );
  }
}
