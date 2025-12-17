import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/usecases/upload_payment_proof_usecase.dart';

part 'payment_proof_state.dart';

/// Cubit for managing payment proof upload flow.
///
/// Handles:
/// - Image selection from gallery or camera
/// - Upload to Supabase Storage
/// - State management during upload process
class PaymentProofCubit extends Cubit<PaymentProofState> {
  final UploadPaymentProofUseCase _uploadPaymentProofUseCase;

  PaymentProofCubit({
    required UploadPaymentProofUseCase uploadPaymentProofUseCase,
  }) : _uploadPaymentProofUseCase = uploadPaymentProofUseCase,
       super(const PaymentProofInitial());

  /// Select an image with bytes (for cross-platform support).
  void selectImage({required Uint8List imageBytes, required String fileName}) {
    emit(PaymentProofSelected(imageBytes: imageBytes, fileName: fileName));
  }

  /// Clear the current selection.
  void clearSelection() {
    emit(const PaymentProofInitial());
  }

  /// Upload the selected proof image.
  Future<void> uploadProof(String bookingId) async {
    final currentState = state;
    if (currentState is! PaymentProofSelected) return;

    emit(const PaymentProofUploading());

    final result = await _uploadPaymentProofUseCase(
      bookingId: bookingId,
      imageBytes: currentState.imageBytes,
      fileName: currentState.fileName,
    );

    result.fold(
      (failure) {
        debugPrint('❌ Payment proof upload failed: ${failure.message}');
        emit(PaymentProofError(message: failure.message));
      },
      (booking) {
        debugPrint('✅ Payment proof uploaded successfully');
        emit(
          PaymentProofSuccess(
            proofUrl: booking.paymentProofUrl ?? '',
            uploadedAt: booking.paymentUploadedAt ?? DateTime.now(),
            updatedBooking: booking,
          ),
        );
      },
    );
  }

  /// Reset to initial state.
  void reset() {
    emit(const PaymentProofInitial());
  }
}
