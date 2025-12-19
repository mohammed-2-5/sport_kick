import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/bookings/domain/entities/payment_status.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_bookings/owner_bookings_cubit.dart';
import 'package:spo_kick/features/owner/presentation/widgets/booking/payment_proof_viewer.dart';
import 'package:spo_kick/features/owner/presentation/widgets/booking/payment_verification_dialog.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/bookings/detail/booking_detail_widgets.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';

/// View for owner booking detail page.
///
/// Displays comprehensive booking information with premium styling.
///
/// Updated: 2025-12-13
class OwnerBookingDetailView extends StatelessWidget {
  final BookingEntity booking;

  const OwnerBookingDetailView({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          PremiumCurvedHeader(
            title: context.l10n.bookingDetails,
            showBackButton: true,
            height: 140,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OwnerBookingStatusCard(booking: booking),
                  const SizedBox(height: 16),
                  OwnerBookingCustomerCard(booking: booking),
                  const SizedBox(height: 16),
                  OwnerBookingDateTimeCard(booking: booking),
                  const SizedBox(height: 16),
                  OwnerBookingPaymentCard(
                    booking: booking,
                    onViewProof: () => _viewPaymentProof(context),
                    onVerifyPayment: () => _verifyPayment(context),
                    onRejectPayment: () => _rejectPayment(context),
                  ),
                  const SizedBox(height: 16),
                  OwnerBookingPriceCard(booking: booking),
                  if (booking.notes != null && booking.notes!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    OwnerBookingNotesCard(notes: booking.notes!),
                  ],
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _BottomActions(
        booking: booking,
        onApprove: () => _approveBooking(context),
        onReject: () => _rejectBooking(context),
      ),
    );
  }

  void _viewPaymentProof(BuildContext context) {
    if (booking.paymentProofUrl != null) {
      PaymentProofViewer.show(
        context,
        imageUrl: booking.paymentProofUrl!,
        bookingId: booking.id,
      );
    }
  }

  Future<void> _verifyPayment(BuildContext context) async {
    final confirmed = await PaymentVerificationDialog.showVerifyDialog(context);
    if (confirmed == true && context.mounted) {
      await context.read<OwnerBookingsCubit>().verifyPayment(booking.id);
      if (context.mounted) {
        HapticFeedback.mediumImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.paymentVerifiedSuccess),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        Navigator.of(context).pop(true);
      }
    }
  }

  Future<void> _rejectPayment(BuildContext context) async {
    final reason = await PaymentVerificationDialog.showRejectDialog(context);
    if (reason != null && reason.isNotEmpty && context.mounted) {
      await context.read<OwnerBookingsCubit>().rejectPayment(
        booking.id,
        reason,
      );
      if (context.mounted) {
        HapticFeedback.mediumImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.paymentRejectedSuccess),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        Navigator.of(context).pop(true);
      }
    }
  }

  Future<void> _approveBooking(BuildContext context) async {
    final confirmed = await _showConfirmDialog(
      context,
      title: 'Approve Booking',
      message: context.l10n.ownerApproveBookingConfirm,
      confirmText: context.l10n.approve,
      confirmColor: AppColors.success,
    );
    if (confirmed && context.mounted) {
      await context.read<OwnerBookingsCubit>().approveBooking(booking.id);
      if (context.mounted) {
        HapticFeedback.mediumImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.bookingApprovedSuccess),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        Navigator.of(context).pop(true);
      }
    }
  }

  Future<void> _rejectBooking(BuildContext context) async {
    final confirmed = await _showConfirmDialog(
      context,
      title: 'Reject Booking',
      message: context.l10n.ownerRejectBookingConfirm,
      confirmText: context.l10n.reject,
      confirmColor: AppColors.error,
    );
    if (confirmed && context.mounted) {
      await context.read<OwnerBookingsCubit>().rejectBooking(booking.id);
      if (context.mounted) {
        HapticFeedback.mediumImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.bookingRejectedSuccess),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        Navigator.of(context).pop(true);
      }
    }
  }

  Future<bool> _showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmText,
    required Color confirmColor,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          title,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          message,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              context.l10n.cancel,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              confirmText,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}

/// Bottom action buttons for booking management.
class _BottomActions extends StatelessWidget {
  final BookingEntity booking;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const _BottomActions({
    required this.booking,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final showActions =
        booking.status == BookingStatus.pending &&
        booking.paymentStatus != PaymentStatus.uploaded;

    if (!showActions) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onReject,
                icon: const Icon(Icons.close_rounded, size: 18),
                label: Text(context.l10n.reject),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onApprove,
                icon: const Icon(Icons.check_rounded, size: 18),
                label: Text(context.l10n.approve),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
