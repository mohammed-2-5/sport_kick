import 'package:equatable/equatable.dart';

/// Time slot entity representing an available booking slot.
///
/// Used for displaying and selecting available time slots
/// for field bookings.
class TimeSlotEntity extends Equatable {
  final String startTime; // Format: "09:00"
  final String endTime; // Format: "10:00"
  final bool isAvailable;
  final double price;
  final String currency;

  /// Whether this slot is on the next day (for cross-midnight hours)
  final bool isNextDay;

  const TimeSlotEntity({
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
    required this.price,
    required this.currency,
    this.isNextDay = false,
  });

  @override
  List<Object?> get props => [
    startTime,
    endTime,
    isAvailable,
    price,
    currency,
    isNextDay,
  ];

  /// Get formatted time slot (e.g., "09:00 - 10:00" or "01:00 - 02:00 (+1)")
  String get formattedTime {
    final suffix = isNextDay ? ' (+1)' : '';
    return '$startTime - $endTime$suffix';
  }

  /// Get formatted time range (alias for formattedTime)
  String get formattedTimeRange => formattedTime;

  /// Get the actual date for this slot based on base date
  DateTime getActualDate(DateTime baseDate) {
    if (isNextDay) {
      return baseDate.add(const Duration(days: 1));
    }
    return baseDate;
  }

  /// Get formatted price (e.g., "200 EGP")
  String get formattedPrice => '${price.toStringAsFixed(0)} $currency';

  /// Get hour value from start time
  int get startHour => int.parse(startTime.split(':')[0]);

  /// Get hour value from end time
  int get endHour => int.parse(endTime.split(':')[0]);

  /// Get duration in hours
  int get durationInHours => endHour - startHour;

  /// Check if slot is in the morning (before 12 PM)
  bool get isMorning => startHour < 12;

  /// Check if slot is in the afternoon (12 PM - 6 PM)
  bool get isAfternoon => startHour >= 12 && startHour < 18;

  /// Check if slot is in the evening (6 PM - 12 AM)
  bool get isEvening => startHour >= 18 && !isNextDay;

  /// Check if slot is late night (after midnight, next day)
  bool get isLateNight => isNextDay;

  /// Get period of day (Morning/Afternoon/Evening/Late Night)
  String get periodOfDay {
    if (isLateNight) return 'Late Night';
    if (isMorning) return 'Morning';
    if (isAfternoon) return 'Afternoon';
    return 'Evening';
  }

  /// Get period (alias for periodOfDay)
  String get period => periodOfDay;

  /// Create a copy with updated fields
  TimeSlotEntity copyWith({
    String? startTime,
    String? endTime,
    bool? isAvailable,
    double? price,
    String? currency,
    bool? isNextDay,
  }) {
    return TimeSlotEntity(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isAvailable: isAvailable ?? this.isAvailable,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      isNextDay: isNextDay ?? this.isNextDay,
    );
  }

  /// Generate default time slots for a day (8 AM - 11 PM)
  static List<TimeSlotEntity> generateDefaultSlots({
    required double hourlyRate,
    required String currency,
  }) {
    final slots = <TimeSlotEntity>[];

    for (int hour = 8; hour < 23; hour++) {
      final startTime = '${hour.toString().padLeft(2, '0')}:00';
      final endTime = '${(hour + 1).toString().padLeft(2, '0')}:00';

      slots.add(
        TimeSlotEntity(
          startTime: startTime,
          endTime: endTime,
          isAvailable: true, // Default to available
          price: hourlyRate,
          currency: currency,
        ),
      );
    }

    return slots;
  }

  /// Group slots by period of day
  static Map<String, List<TimeSlotEntity>> groupSlotsByPeriod(
    List<TimeSlotEntity> slots,
  ) {
    final Map<String, List<TimeSlotEntity>> grouped = {
      'Morning': [],
      'Afternoon': [],
      'Evening': [],
      'Late Night': [],
    };

    for (final slot in slots) {
      grouped[slot.periodOfDay]!.add(slot);
    }

    // Remove empty periods
    grouped.removeWhere((key, value) => value.isEmpty);

    return grouped;
  }
}
