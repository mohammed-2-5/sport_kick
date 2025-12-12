/// Payment Status Enum
///
/// Represents the status of payment for a booking.
enum PaymentStatus {
  /// Payment is pending - user has not yet uploaded proof
  pending,

  /// Payment proof has been uploaded by user
  uploaded,

  /// Payment has been verified by field owner
  verified,

  /// Payment was rejected by field owner
  rejected;

  /// Get display name for the status
  String get displayName {
    switch (this) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.uploaded:
        return 'Awaiting Verification';
      case PaymentStatus.verified:
        return 'Verified';
      case PaymentStatus.rejected:
        return 'Rejected';
    }
  }

  /// Get color name for UI styling
  String get colorName {
    switch (this) {
      case PaymentStatus.pending:
        return 'warning';
      case PaymentStatus.uploaded:
        return 'info';
      case PaymentStatus.verified:
        return 'success';
      case PaymentStatus.rejected:
        return 'error';
    }
  }

  /// Check if payment needs action from user
  bool get needsUserAction =>
      this == PaymentStatus.pending || this == PaymentStatus.rejected;

  /// Check if payment needs action from owner
  bool get needsOwnerAction => this == PaymentStatus.uploaded;

  /// Check if payment is complete
  bool get isComplete => this == PaymentStatus.verified;

  /// Create from string value
  static PaymentStatus fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'pending':
        return PaymentStatus.pending;
      case 'uploaded':
        return PaymentStatus.uploaded;
      case 'verified':
        return PaymentStatus.verified;
      case 'rejected':
        return PaymentStatus.rejected;
      default:
        return PaymentStatus.pending;
    }
  }
}
