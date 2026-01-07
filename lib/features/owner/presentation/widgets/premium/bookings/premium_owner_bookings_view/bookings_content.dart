import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/theme/theme_extensions.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_bookings/owner_bookings_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_bookings/owner_bookings_state.dart';
import 'package:spo_kick/features/owner/presentation/widgets/booking/payment_proof_viewer.dart';
import 'package:spo_kick/features/owner/presentation/widgets/booking/payment_verification_dialog.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/bookings/premium_owner_bookings_list.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/bookings/premium_owner_bookings_view/bookings_error_state.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/bookings/premium_owner_bookings_view/confirm_dialog.dart';

/// Content area for owner bookings view.
///
/// Handles loading, error, and loaded states with appropriate UI.
/// Manages booking actions like approve, reject, and payment verification.
class BookingsContent extends StatelessWidget {
  final OwnerBookingsState state;
  final OwnerBookingsCubit cubit;

  const BookingsContent({required this.state, required this.cubit, super.key});

  @override
  Widget build(BuildContext context) {
    if (state is OwnerBookingsLoading) {
      return PremiumOwnerBookingsList(
        bookings: const [],
        isLoading: true,
        isRefreshing: false,
        onRefresh: () {},
        onApprove: (_) {},
        onReject: (_) {},
      );
    }

    if (state is OwnerBookingsLoaded) {
      final loadedState = state as OwnerBookingsLoaded;
      final filteredBookings = loadedState.filteredBookings;

      return PremiumOwnerBookingsList(
        bookings: filteredBookings,
        isLoading: false,
        isRefreshing: loadedState.isRefreshing,
        onRefresh: () => cubit.refresh(),
        onTap: (booking) => _handleBookingTap(context, booking),
        onApprove: (id) => _handleApprove(context, id),
        onReject: (id) => _handleReject(context, id),
        onViewPaymentProof: (booking) =>
            _handleViewPaymentProof(context, booking),
        onVerifyPayment: (id) => _handleVerifyPayment(context, id),
        onRejectPayment: (id) => _handleRejectPayment(context, id),
        emptyMessage: _getEmptyMessage(context, loadedState),
      );
    }

    return BookingsErrorState(onRetry: () => cubit.loadBookings());
  }

  Future<void> _handleBookingTap(
    BuildContext context,
    BookingEntity booking,
  ) async {
    final result = await context.pushNamed<bool>(
      'ownerBookingDetail',
      extra: booking,
    );
    if (result == true && context.mounted) {
      cubit.refresh();
    }
  }

  String _getEmptyMessage(BuildContext context, OwnerBookingsLoaded state) {
    if (state.searchQuery.isNotEmpty) {
      return context.l10n.noBookingsMatchYourSearch;
    }
    switch (state.selectedTabIndex) {
      case 1:
        return context.l10n.noPendingBookings;
      case 2:
        return context.l10n.noConfirmedBookings;
      case 3:
        return context.l10n.noCanceledBookings;
      default:
        return context.l10n.noBookingsYet;
    }
  }

  Future<void> _handleApprove(BuildContext context, String bookingId) async {
    final confirmed = await showBookingConfirmDialog(
      context,
      title: context.l10n.approveBooking,
      message: context.l10n.ownerApproveBookingConfirm,
      confirmText: context.l10n.approve,
      confirmColor: Colors.green,
    );
    if (confirmed) {
      await cubit.approveBooking(bookingId);
    }
  }

  Future<void> _handleReject(BuildContext context, String bookingId) async {
    final confirmed = await showBookingConfirmDialog(
      context,
      title: context.l10n.rejectBooking,
      message: context.l10n.ownerRejectBookingConfirm,
      confirmText: context.l10n.reject,
      confirmColor: Colors.red,
    );
    if (confirmed) {
      await cubit.rejectBooking(bookingId);
    }
  }

  void _handleViewPaymentProof(BuildContext context, BookingEntity booking) {
    if (booking.paymentProofUrl != null) {
      PaymentProofViewer.show(
        context,
        imageUrl: booking.paymentProofUrl!,
        bookingId: booking.id,
      );
    }
  }

  Future<void> _handleVerifyPayment(
    BuildContext context,
    String bookingId,
  ) async {
    final confirmed = await PaymentVerificationDialog.showVerifyDialog(context);
    if (confirmed == true) {
      await cubit.verifyPayment(bookingId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.paymentVerifiedSuccess),
            backgroundColor: Theme.of(context).colorScheme.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  Future<void> _handleRejectPayment(
    BuildContext context,
    String bookingId,
  ) async {
    final reason = await PaymentVerificationDialog.showRejectDialog(context);
    if (reason != null && reason.isNotEmpty) {
      await cubit.rejectPayment(bookingId, reason);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.paymentRejectedSuccess),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }
}
