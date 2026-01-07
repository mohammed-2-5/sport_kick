import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/usecases/upload_payment_proof_usecase.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/payment_proof_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/invoice/booking_invoice_content.dart';
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
      child: BookingInvoiceContent(booking: booking, field: field),
    );
  }
}
