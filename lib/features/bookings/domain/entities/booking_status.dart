/// Booking status enum
enum BookingStatus { pending, confirmed, canceled, completed }

/// Extension to convert string to BookingStatus
extension BookingStatusExtension on String {
  BookingStatus toBookingStatus() {
    switch (toLowerCase()) {
      case 'pending':
        return BookingStatus.pending;
      case 'confirmed':
        return BookingStatus.confirmed;
      case 'canceled':
        return BookingStatus.canceled;
      case 'completed':
        return BookingStatus.completed;
      default:
        return BookingStatus.pending;
    }
  }
}

/// Extension to convert BookingStatus to string
extension BookingStatusStringExtension on BookingStatus {
  /// Raw string value (e.g. 'pending')
  String toShortString() {
    return toString().split('.').last;
  }

  /// User-friendly display name
  String get displayName {
    switch (this) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.canceled:
        return 'Canceled';
      case BookingStatus.completed:
        return 'Completed';
    }
  }
}
