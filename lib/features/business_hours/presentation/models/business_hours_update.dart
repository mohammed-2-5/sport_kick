/// Update data class for business hours changes.
///
/// Used to pass updated business hours data from editor widgets
/// to parent components or state management.
class BusinessHoursUpdate {
  /// Whether the field is open on this day
  final bool isOpen;

  /// Opening time in HH:MM:SS format
  final String openingTime;

  /// Closing time in HH:MM:SS format
  final String closingTime;

  const BusinessHoursUpdate({
    required this.isOpen,
    required this.openingTime,
    required this.closingTime,
  });

  /// Creates a copy with updated fields
  BusinessHoursUpdate copyWith({
    bool? isOpen,
    String? openingTime,
    String? closingTime,
  }) {
    return BusinessHoursUpdate(
      isOpen: isOpen ?? this.isOpen,
      openingTime: openingTime ?? this.openingTime,
      closingTime: closingTime ?? this.closingTime,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BusinessHoursUpdate &&
        other.isOpen == isOpen &&
        other.openingTime == openingTime &&
        other.closingTime == closingTime;
  }

  @override
  int get hashCode =>
      isOpen.hashCode ^ openingTime.hashCode ^ closingTime.hashCode;
}
