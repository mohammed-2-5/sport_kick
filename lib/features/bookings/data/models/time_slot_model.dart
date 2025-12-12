import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';

/// Time slot data model (DTO) for JSON serialization.
///
/// Maps between database JSON and domain entity.
class TimeSlotModel extends TimeSlotEntity {
  const TimeSlotModel({
    required super.startTime,
    required super.endTime,
    required super.isAvailable,
    required super.price,
    required super.currency,
    super.isNextDay,
  });

  /// Create model from JSON.
  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      isAvailable: json['is_available'] as bool? ?? true,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'EGP',
      isNextDay: json['is_next_day'] as bool? ?? false,
    );
  }

  /// Convert model to JSON.
  Map<String, dynamic> toJson() {
    return {
      'start_time': startTime,
      'end_time': endTime,
      'is_available': isAvailable,
      'price': price,
      'currency': currency,
      'is_next_day': isNextDay,
    };
  }

  /// Convert from entity to model.
  factory TimeSlotModel.fromEntity(TimeSlotEntity entity) {
    return TimeSlotModel(
      startTime: entity.startTime,
      endTime: entity.endTime,
      isAvailable: entity.isAvailable,
      price: entity.price,
      currency: entity.currency,
      isNextDay: entity.isNextDay,
    );
  }

  /// Convert model to entity.
  TimeSlotEntity toEntity() {
    return TimeSlotEntity(
      startTime: startTime,
      endTime: endTime,
      isAvailable: isAvailable,
      price: price,
      currency: currency,
      isNextDay: isNextDay,
    );
  }

  /// Create a copy with updated fields.
  @override
  TimeSlotModel copyWith({
    String? startTime,
    String? endTime,
    bool? isAvailable,
    double? price,
    String? currency,
    bool? isNextDay,
  }) {
    return TimeSlotModel(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isAvailable: isAvailable ?? this.isAvailable,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      isNextDay: isNextDay ?? this.isNextDay,
    );
  }
}
