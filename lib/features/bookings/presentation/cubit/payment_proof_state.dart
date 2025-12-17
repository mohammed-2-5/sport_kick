part of 'payment_proof_cubit.dart';

/// Base state for payment proof upload flow.
sealed class PaymentProofState extends Equatable {
  const PaymentProofState();

  @override
  List<Object?> get props => [];
}

/// Initial state - no image selected.
class PaymentProofInitial extends PaymentProofState {
  const PaymentProofInitial();
}

/// Image has been selected, ready to upload.
class PaymentProofSelected extends PaymentProofState {
  final Uint8List imageBytes;
  final String fileName;

  const PaymentProofSelected({
    required this.imageBytes,
    required this.fileName,
  });

  @override
  List<Object?> get props => [imageBytes, fileName];
}

/// Upload in progress.
class PaymentProofUploading extends PaymentProofState {
  const PaymentProofUploading();
}

/// Upload completed successfully.
class PaymentProofSuccess extends PaymentProofState {
  final String proofUrl;
  final DateTime uploadedAt;
  final BookingEntity updatedBooking;

  const PaymentProofSuccess({
    required this.proofUrl,
    required this.uploadedAt,
    required this.updatedBooking,
  });

  @override
  List<Object?> get props => [proofUrl, uploadedAt, updatedBooking];
}

/// Upload failed with error.
class PaymentProofError extends PaymentProofState {
  final String message;

  const PaymentProofError({required this.message});

  @override
  List<Object?> get props => [message];
}
