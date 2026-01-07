/// Use case for calculating total booking price.
///
/// Calculates the total price by multiplying the price per hour by the duration.
class CalculateBookingPriceUseCase {
  /// Calculate total booking price.
  ///
  /// [pricePerHour] - Price per hour for the field
  /// [durationHours] - Duration in hours (1 or 2)
  ///
  /// Returns the total price.
  double call({required double pricePerHour, required int durationHours}) {
    return pricePerHour * durationHours;
  }
}
