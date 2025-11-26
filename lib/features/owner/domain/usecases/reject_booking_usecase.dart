import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/owner/domain/repositories/owner_repository.dart';

/// Use case to reject a booking with a reason
class RejectBookingUseCase {
  final OwnerRepository repository;

  RejectBookingUseCase(this.repository);

  /// Execute the use case
  ///
  /// Rejects a booking by changing its status to 'canceled'
  /// and stores the [reason] for rejection
  Future<Either<Failure, void>> call({
    required String bookingId,
    required String reason,
  }) async {
    return await repository.rejectBooking(bookingId, reason);
  }
}
