/// Payment Method Enum
///
/// Represents available payment methods for field bookings.
enum PaymentMethod {
  /// Vodafone Cash mobile wallet
  vodafoneCash,

  /// InstaPay bank transfer
  instapay;

  /// Get display name for the payment method
  String get displayName {
    switch (this) {
      case PaymentMethod.vodafoneCash:
        return 'Vodafone Cash';
      case PaymentMethod.instapay:
        return 'InstaPay';
    }
  }

  /// Get icon name for UI
  String get iconName {
    switch (this) {
      case PaymentMethod.vodafoneCash:
        return 'phone_android';
      case PaymentMethod.instapay:
        return 'account_balance';
    }
  }

  /// Get instructions template
  String get instructionsTemplate {
    switch (this) {
      case PaymentMethod.vodafoneCash:
        return 'Send the booking amount to the Vodafone Cash number above. '
            'After completing the transfer, upload a screenshot of the transaction.';
      case PaymentMethod.instapay:
        return 'Transfer the booking amount to the InstaPay number above. '
            'After completing the transfer, upload a screenshot of the transaction.';
    }
  }

  /// Get database value
  String get dbValue {
    switch (this) {
      case PaymentMethod.vodafoneCash:
        return 'vodafone_cash';
      case PaymentMethod.instapay:
        return 'instapay';
    }
  }

  /// Create from database string value
  static PaymentMethod fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'vodafone_cash':
        return PaymentMethod.vodafoneCash;
      case 'instapay':
        return PaymentMethod.instapay;
      default:
        return PaymentMethod.vodafoneCash;
    }
  }
}
