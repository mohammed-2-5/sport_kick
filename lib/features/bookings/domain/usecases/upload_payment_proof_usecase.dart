import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/repositories/booking_repository.dart';

/// Use case for uploading payment proof for a booking.
///
/// Validates the image bytes and delegates to repository for upload.
/// Uses bytes for cross-platform support (web and mobile).
class UploadPaymentProofUseCase {
  final BookingRepository repository;

  UploadPaymentProofUseCase(this.repository);

  Future<Either<Failure, BookingEntity>> call({
    required String bookingId,
    required Uint8List imageBytes,
    required String fileName,
  }) async {
    // Validate booking ID
    if (bookingId.isEmpty) {
      return const Left(ValidationFailure('Booking ID is required'));
    }

    // Validate image bytes
    if (imageBytes.isEmpty) {
      return const Left(ValidationFailure('Image data is required'));
    }

    // Validate file size (max 10MB)
    const maxSize = 10 * 1024 * 1024; // 10MB
    if (imageBytes.length > maxSize) {
      return const Left(
        ValidationFailure('Image file is too large. Maximum size is 10MB'),
      );
    }

    // Validate file type (basic check by extension)
    final extension = fileName.toLowerCase().split('.').last;
    final validExtensions = ['jpg', 'jpeg', 'png', 'webp'];
    if (!validExtensions.contains(extension)) {
      return const Left(
        ValidationFailure('Invalid image format. Please use JPG, PNG, or WebP'),
      );
    }

    return await repository.uploadPaymentProof(
      bookingId: bookingId,
      imageBytes: imageBytes,
      fileName: fileName,
    );
  }
}
