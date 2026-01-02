import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/theme/theme_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/payment_status.dart';
import 'package:spo_kick/features/bookings/domain/usecases/upload_payment_proof_usecase.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/payment_proof_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/invoice/invoice_details_card.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/invoice/payment_info_card.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/invoice/payment_proof_section.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';

/// Page displaying booking invoice with payment instructions.
///
/// Shows:
/// - Invoice number and booking details
/// - Payment method (Vodafone Cash / InstaPay)
/// - Payment phone number to send money to
/// - Payment instructions
/// - Option to upload payment proof screenshot
class BookingInvoicePage extends StatelessWidget {
  final BookingEntity booking;
  final FieldEntity field;

  const BookingInvoicePage({
    super.key,
    required this.booking,
    required this.field,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentProofCubit(
        uploadPaymentProofUseCase: sl<UploadPaymentProofUseCase>(),
      ),
      child: _BookingInvoiceView(booking: booking, field: field),
    );
  }
}

class _BookingInvoiceView extends StatefulWidget {
  final BookingEntity booking;
  final FieldEntity field;

  const _BookingInvoiceView({required this.booking, required this.field});

  @override
  State<_BookingInvoiceView> createState() => _BookingInvoiceViewState();
}

class _BookingInvoiceViewState extends State<_BookingInvoiceView> {
  late BookingEntity _currentBooking;

  @override
  void initState() {
    super.initState();
    _currentBooking = widget.booking;
  }

  void _onBookingUpdated(BookingEntity updatedBooking) {
    setState(() {
      _currentBooking = updatedBooking;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentProofCubit, PaymentProofState>(
      listener: (context, state) {
        if (state is PaymentProofSuccess) {
          _onBookingUpdated(state.updatedBooking);
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            // Header
            PremiumCurvedHeader(
              title: context.l10n.invoiceTitle,
              subtitle:
                  _currentBooking.invoiceNumber ?? context.l10n.paymentRequired,
              showBackButton: true,
              onBackPressed: () => context.pop(),
              height: 140,
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Invoice Status Banner
                    _InvoiceStatusBanner(booking: _currentBooking),
                    const SizedBox(height: 20),

                    // Invoice Details Card
                    InvoiceDetailsCard(
                      booking: _currentBooking,
                      field: widget.field,
                    ),
                    const SizedBox(height: 16),

                    // Payment Info Card
                    PaymentInfoCard(field: widget.field),
                    const SizedBox(height: 16),

                    // Payment Proof Section
                    PaymentProofSection(booking: _currentBooking),
                    const SizedBox(height: 24),

                    // Actions
                    _ActionButtons(booking: _currentBooking),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Status banner showing payment status.
class _InvoiceStatusBanner extends StatelessWidget {
  final BookingEntity booking;

  const _InvoiceStatusBanner({required this.booking});

  @override
  Widget build(BuildContext context) {
    final status = booking.paymentStatus;
    final l10n = context.l10n;
    final colorScheme = context.colors;
    final textTheme = context.textTheme;

    final Color backgroundColor;
    final Color textColor;
    final IconData icon;
    final String message;

    switch (status) {
      case PaymentStatus.verified:
        backgroundColor = colorScheme.success.withAlpha(26);
        textColor = colorScheme.success;
        icon = Icons.check_circle_rounded;
        message = l10n.paymentVerified;
      case PaymentStatus.uploaded:
        backgroundColor = colorScheme.info.withAlpha(26);
        textColor = colorScheme.info;
        icon = Icons.hourglass_empty_rounded;
        message = l10n.paymentAwaitingVerification;
      case PaymentStatus.rejected:
        backgroundColor = colorScheme.error.withAlpha(26);
        textColor = colorScheme.error;
        icon = Icons.error_rounded;
        message = booking.paymentRejectionReason ?? l10n.paymentRejected;
      case PaymentStatus.pending:
        backgroundColor = colorScheme.warning.withAlpha(26);
        textColor = colorScheme.warning;
        icon = Icons.payment_rounded;
        message = l10n.paymentRequired;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: textColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _statusLabel(context),
                  style: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: textTheme.bodySmall?.copyWith(
                    color: textColor.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _statusLabel(BuildContext context) {
    final l10n = context.l10n;
    switch (booking.paymentStatus) {
      case PaymentStatus.pending:
        return l10n.paymentStatusPending;
      case PaymentStatus.uploaded:
        return l10n.paymentStatusUploaded;
      case PaymentStatus.verified:
        return l10n.paymentStatusVerified;
      case PaymentStatus.rejected:
        return l10n.paymentStatusRejected;
    }
  }
}

/// Action buttons based on payment status.
class _ActionButtons extends StatelessWidget {
  final BookingEntity booking;

  const _ActionButtons({required this.booking});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colors;
    final textTheme = context.textTheme;

    // If payment is verified, show "View My Bookings" button
    if (booking.paymentStatus.isComplete) {
      return Column(
        children: [
          PremiumButton(
            label: context.l10n.viewMyBookings,
            onPressed: () => context.goNamed(context.l10n.mybookings),
            fullWidth: true,
            icon: Icons.list_alt_rounded,
          ),
          const SizedBox(height: 12),
          PremiumButton(
            label: context.l10n.backToHome,
            onPressed: () => context.go('/'),
            fullWidth: true,
            style: PremiumButtonStyle.outline,
          ),
        ],
      );
    }

    // If payment proof is uploaded, show waiting message
    if (booking.paymentStatus.needsOwnerAction) {
      return Column(
        children: [
          PremiumCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.info.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.info_outline_rounded,
                    color: colorScheme.info,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    context.l10n.paymentProofSubmittedMessage,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          PremiumButton(
            label: context.l10n.viewMyBookings,
            onPressed: () => context.goNamed(context.l10n.mybookings),
            fullWidth: true,
            icon: Icons.list_alt_rounded,
          ),
        ],
      );
    }

    // Payment required or rejected - show upload instructions
    return Column(
      children: [
        PremiumButton(
          label: context.l10n.viewMyBookings,
          onPressed: () => context.goNamed(context.l10n.mybookings),
          fullWidth: true,
          icon: Icons.list_alt_rounded,
        ),
        const SizedBox(height: 12),
        PremiumButton(
          label: context.l10n.backToHome,
          onPressed: () => context.go('/'),
          fullWidth: true,
          style: PremiumButtonStyle.outline,
        ),
      ],
    );
  }
}
