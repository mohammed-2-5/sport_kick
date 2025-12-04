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

  const TimeSlotEntity({
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
    required this.price,
    required this.currency,
  });

  @override
  List<Object?> get props => [startTime, endTime, isAvailable, price, currency];

  /// Get formatted time slot (e.g., "09:00 - 10:00")
  String get formattedTime => '$startTime - $endTime';

  /// Get formatted time range (alias for formattedTime)
  String get formattedTimeRange => formattedTime;

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

  /// Check if slot is in the evening (after 6 PM)
  bool get isEvening => startHour >= 18;

  /// Get period of day (Morning/Afternoon/Evening)
  String get periodOfDay {
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
  }) {
    return TimeSlotEntity(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isAvailable: isAvailable ?? this.isAvailable,
      price: price ?? this.price,
      currency: currency ?? this.currency,
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
    };

    for (final slot in slots) {
      grouped[slot.periodOfDay]!.add(slot);
    }

    return grouped;
  }
}
