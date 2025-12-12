import 'package:equatable/equatable.dart';

/// Business hours entity representing operating hours for a field on a specific day.
///
/// This entity follows clean architecture principles and is independent
/// of any data layer implementation details.
class BusinessHoursEntity extends Equatable {
  /// Unique identifier for the business hours record
  final String id;

  /// ID of the field these hours belong to
  final String fieldId;

  /// Day of week (0=Sunday, 1=Monday, ..., 6=Saturday)
  final int dayOfWeek;

  /// Whether the field is open on this day
  final bool isOpen;

  /// Opening time (null if closed)
  final String? openingTime;

  /// Closing time (null if closed)
  final String? closingTime;

  /// Whether the closing time is on the next day (for late-night hours like 12 PM - 2 AM)
  final bool closesNextDay;

  /// When this record was created
  final DateTime createdAt;

  /// When this record was last updated
  final DateTime updatedAt;

  const BusinessHoursEntity({
    required this.id,
    required this.fieldId,
    required this.dayOfWeek,
    required this.isOpen,
    this.openingTime,
    this.closingTime,
    this.closesNextDay = false,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Returns true if the field is open 24 hours on this day
  bool get isOpen24Hours {
    if (!isOpen) return false;
    if (openingTime == null || closingTime == null) return false;
    return openingTime == '00:00:00' && closingTime == '23:59:59';
  }

  /// Returns a formatted time range string (e.g., "08:00 - 22:00")
  String get timeRange {
    if (!isOpen) return 'Closed';
    if (isOpen24Hours) return '24 Hours';
    if (openingTime == null || closingTime == null) return 'Closed';

    final suffix = closesNextDay ? ' (+1)' : '';
    return '${_formatTime(openingTime!)} - ${_formatTime(closingTime!)}$suffix';
  }

  /// Returns true if this day has late-night hours that cross midnight
  bool get isCrossMidnight => closesNextDay;

  /// Formats time from HH:mm:ss to HH:mm
  String _formatTime(String time) {
    if (time.length >= 5) {
      return time.substring(0, 5);
    }
    return time;
  }

  /// Creates a copy of this entity with updated fields
  BusinessHoursEntity copyWith({
    String? id,
    String? fieldId,
    int? dayOfWeek,
    bool? isOpen,
    String? openingTime,
    String? closingTime,
    bool? closesNextDay,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BusinessHoursEntity(
      id: id ?? this.id,
      fieldId: fieldId ?? this.fieldId,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      isOpen: isOpen ?? this.isOpen,
      openingTime: openingTime ?? this.openingTime,
      closingTime: closingTime ?? this.closingTime,
      closesNextDay: closesNextDay ?? this.closesNextDay,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    fieldId,
    dayOfWeek,
    isOpen,
    openingTime,
    closingTime,
    closesNextDay,
    createdAt,
    updatedAt,
  ];

  @override
  bool get stringify => true;
}
