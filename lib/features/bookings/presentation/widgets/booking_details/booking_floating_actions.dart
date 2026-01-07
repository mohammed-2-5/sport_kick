import 'package:flutter/material.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_details/booking_cancel_action_button.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_details/booking_contact_support_button.dart';

/// Floating action buttons for booking details.
///
/// Shows cancel and contact support buttons with glass effect.
/// Uses extracted [BookingCancelActionButton] and [BookingContactSupportButton].
class BookingFloatingActions extends StatelessWidget {
  final BookingEntity booking;

  const BookingFloatingActions({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (booking.canCancel) ...[
              Expanded(child: BookingCancelActionButton(bookingId: booking.id)),
              const SizedBox(width: 12),
            ],
            Expanded(child: BookingContactSupportButton(bookingId: booking.id)),
          ],
        ),
      ),
    );
  }
}
