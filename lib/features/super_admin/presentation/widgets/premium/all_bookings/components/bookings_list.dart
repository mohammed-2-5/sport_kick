import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/all_bookings/components/empty_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/all_bookings/premium_all_booking_card.dart';

/// Bookings list widget.
class BookingsList extends StatelessWidget {
  final List<BookingEntity> bookings;
  final void Function(BookingEntity booking)? onBookingTap;

  const BookingsList({super.key, required this.bookings, this.onBookingTap});

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return const EmptyState();
    }

    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 400),
            child: SlideAnimation(
              verticalOffset: 50,
              child: FadeInAnimation(
                child: PremiumAllBookingCard(
                  bookingId: booking.id,
                  userName: booking.userName ?? 'Unknown User',
                  fieldName: booking.fieldName ?? 'Unknown Field',
                  formattedDate: booking.formattedDate,
                  formattedTimeSlot: booking.formattedTimeSlot,
                  formattedPrice: booking.formattedPrice,
                  status: booking.status,
                  isManual: booking.isManual,
                  onTap: () {
                    onBookingTap?.call(booking);
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
