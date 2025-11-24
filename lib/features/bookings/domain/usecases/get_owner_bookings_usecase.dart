import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/repositories/booking_repository.dart';

/// Use case for getting all bookings for fields owned by the current user.
///
/// This is used by field owners to view all bookings made for their fields
/// in the owner dashboard.
class GetOwnerBookingsUseCase {
  final BookingRepository repository;

  GetOwnerBookingsUseCase(this.repository);

  Future<Either<Failure, List<BookingEntity>>> call() async {
    return await repository.getOwnerBookings();
  }
}
