import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/owner/domain/repositories/owner_repository.dart';

/// Use case to get all bookings for owner's fields
class GetOwnerBookingsUseCase {
  final OwnerRepository repository;

  GetOwnerBookingsUseCase(this.repository);

  /// Execute the use case
  ///
  /// Returns a list of [BookingEntity] for all fields owned by the owner
  /// Optionally filter by [status] (pending, confirmed, canceled, completed)
  Future<Either<Failure, List<BookingEntity>>> call({
    required String ownerId,
    String? status,
  }) async {
    return await repository.getOwnerBookings(ownerId: ownerId, status: status);
  }
}
