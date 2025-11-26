import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/owner/domain/repositories/owner_repository.dart';

/// Use case to approve a pending booking
class ApproveBookingUseCase {
  final OwnerRepository repository;

  ApproveBookingUseCase(this.repository);

  /// Execute the use case
  ///
  /// Approves a booking by changing its status to 'confirmed'
  Future<Either<Failure, void>> call({required String bookingId}) async {
    return await repository.approveBooking(bookingId);
  }
}
