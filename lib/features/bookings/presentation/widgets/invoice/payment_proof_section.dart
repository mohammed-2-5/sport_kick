import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/payment_proof_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/invoice/payment_proof/existing_payment_proof_card.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/invoice/payment_proof/image_source_bottom_sheet.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/invoice/payment_proof/selected_proof_card.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/invoice/payment_proof/upload_proof_card.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/invoice/payment_proof/uploading_card.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/invoice/payment_proof/verified_payment_card.dart';

/// Section for uploading and viewing payment proof.
class PaymentProofSection extends StatelessWidget {
  final BookingEntity booking;

  const PaymentProofSection({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentProofCubit, PaymentProofState>(
      builder: (context, state) {
        // If payment is verified, show success message
        if (booking.paymentStatus.isComplete) {
          return VerifiedPaymentCard(booking: booking);
        }

        // If user is currently selecting/uploading, show that state first
        if (state is PaymentProofSelected) {
          return SelectedProofCard(
            imageBytes: state.imageBytes,
            onUpload: () =>
                context.read<PaymentProofCubit>().uploadProof(booking.id),
            onCancel: () => context.read<PaymentProofCubit>().clearSelection(),
          );
        }

        if (state is PaymentProofUploading) {
          return const UploadingCard();
        }

        // If upload was successful, show the existing proof card with updated booking
        if (state is PaymentProofSuccess) {
          return ExistingPaymentProofCard(booking: state.updatedBooking);
        }

        // If payment proof is already uploaded (existing), show the proof
        if (booking.hasPaymentProof) {
          return ExistingPaymentProofCard(booking: booking);
        }

        if (state is PaymentProofError) {
          return UploadProofCard(
            errorMessage: state.message,
            onPickImage: () => _showImageSourceSheet(context),
          );
        }

        // Default: show upload prompt
        return UploadProofCard(
          onPickImage: () => _showImageSourceSheet(context),
        );
      },
    );
  }

  Future<void> _showImageSourceSheet(BuildContext context) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (context) => const ImageSourceBottomSheet(),
    );

    if (!context.mounted || source == null) return;

    // Delegate image picking to cubit
    context.read<PaymentProofCubit>().pickAndSelectImage(source);
  }
}
