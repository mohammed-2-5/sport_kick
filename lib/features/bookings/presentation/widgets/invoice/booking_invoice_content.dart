import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/payment_proof_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/invoice/invoice_action_buttons.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/invoice/invoice_details_card.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/invoice/invoice_status_banner.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/invoice/payment_info_card.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/invoice/payment_proof_section.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';

/// Content widget for booking invoice page.
///
/// Displays invoice details, payment info, and payment proof section.
/// Handles payment proof upload state updates.
class BookingInvoiceContent extends StatefulWidget {
  final BookingEntity booking;
  final FieldEntity field;

  const BookingInvoiceContent({
    super.key,
    required this.booking,
    required this.field,
  });

  @override
  State<BookingInvoiceContent> createState() => _BookingInvoiceContentState();
}

class _BookingInvoiceContentState extends State<BookingInvoiceContent> {
  late BookingEntity _currentBooking;

  @override
  void initState() {
    super.initState();
    _currentBooking = widget.booking;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentProofCubit, PaymentProofState>(
      listener: (context, state) {
        if (state is PaymentProofSuccess) {
          setState(() => _currentBooking = state.updatedBooking);
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            PremiumCurvedHeader(
              title: context.l10n.invoiceTitle,
              subtitle:
                  _currentBooking.invoiceNumber ?? context.l10n.paymentRequired,
              showBackButton: true,
              onBackPressed: () => context.pop(),
              height: 140,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InvoiceStatusBanner(booking: _currentBooking),
                    const SizedBox(height: 20),
                    InvoiceDetailsCard(
                      booking: _currentBooking,
                      field: widget.field,
                    ),
                    const SizedBox(height: 16),
                    PaymentInfoCard(field: widget.field),
                    const SizedBox(height: 16),
                    PaymentProofSection(booking: _currentBooking),
                    const SizedBox(height: 24),
                    InvoiceActionButtons(booking: _currentBooking),
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
