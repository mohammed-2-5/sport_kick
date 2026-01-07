import 'package:flutter/material.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/premium_owner_booking_card.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/bookings/premium_owner_bookings_list/bookings_loading_shimmer.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/bookings/premium_owner_bookings_list/bookings_empty_state.dart';

/// Premium list view for owner bookings.
///
/// Features:
/// - Smooth animations
/// - Pull-to-refresh
/// - Empty state
/// - Loading shimmer
/// - Payment verification actions
class PremiumOwnerBookingsList extends StatelessWidget {
  final List<BookingEntity> bookings;
  final bool isLoading;
  final bool isRefreshing;
  final VoidCallback onRefresh;
  final Function(String) onApprove;
  final Function(String) onReject;
  final Function(BookingEntity)? onTap;
  final Function(BookingEntity)? onViewPaymentProof;
  final Function(String)? onVerifyPayment;
  final Function(String)? onRejectPayment;
  final String emptyMessage;

  const PremiumOwnerBookingsList({
    super.key,
    required this.bookings,
    required this.isLoading,
    required this.isRefreshing,
    required this.onRefresh,
    required this.onApprove,
    required this.onReject,
    this.onTap,
    this.onViewPaymentProof,
    this.onVerifyPayment,
    this.onRejectPayment,
    this.emptyMessage = 'No bookings found',
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (isLoading && !isRefreshing) {
      return const BookingsLoadingShimmer();
    }

    if (bookings.isEmpty) {
      return BookingsEmptyState(message: emptyMessage);
    }

    return RefreshIndicator(
      onRefresh: () async {
        onRefresh();
        await Future.delayed(const Duration(milliseconds: 500));
      },
      color: colorScheme.secondary,
      backgroundColor: colorScheme.surface,
      child: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: bookings.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 300 + (index * 50)),
            tween: Tween(begin: 0.0, end: 1.0),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: Opacity(opacity: value, child: child),
              );
            },
            child: PremiumOwnerBookingCard(
              booking: booking,
              onTap: onTap != null ? () => onTap!(booking) : null,
              onApprove: () => onApprove(booking.id),
              onReject: () => onReject(booking.id),
              onViewPaymentProof: onViewPaymentProof != null
                  ? () => onViewPaymentProof!(booking)
                  : null,
              onVerifyPayment: onVerifyPayment != null
                  ? () => onVerifyPayment!(booking.id)
                  : null,
              onRejectPayment: onRejectPayment != null
                  ? () => onRejectPayment!(booking.id)
                  : null,
            ),
          );
        },
      ),
    );
  }
}
