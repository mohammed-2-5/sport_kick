import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
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
  final ImagePicker _imagePicker;

  PaymentProofCubit({
    required UploadPaymentProofUseCase uploadPaymentProofUseCase,
    ImagePicker? imagePicker,
  }) : _uploadPaymentProofUseCase = uploadPaymentProofUseCase,
       _imagePicker = imagePicker ?? ImagePicker(),
       super(const PaymentProofInitial());

  /// Pick image from given source and select it.
  Future<void> pickAndSelectImage(ImageSource source) async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      // Read bytes from XFile (works on both web and mobile)
      final bytes = await pickedFile.readAsBytes();
      final fileName = pickedFile.name;

      HapticFeedback.selectionClick();
      emit(PaymentProofSelected(imageBytes: bytes, fileName: fileName));
    } catch (e) {
      debugPrint('❌ Error picking image: $e');
      emit(PaymentProofError(message: e.toString()));
    }
  }

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
