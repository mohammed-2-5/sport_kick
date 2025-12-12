import 'package:spo_kick/features/business_hours/domain/entities/business_hours_entity.dart';

/// Data model for business hours.
///
/// Extends [BusinessHoursEntity] and provides JSON serialization/deserialization
/// for communication with the data layer (Supabase).
class BusinessHoursModel extends BusinessHoursEntity {
  const BusinessHoursModel({
    required super.id,
    required super.fieldId,
    required super.dayOfWeek,
    required super.isOpen,
    super.openingTime,
    super.closingTime,
    super.closesNextDay,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Creates a model from JSON data received from Supabase.
  factory BusinessHoursModel.fromJson(Map<String, dynamic> json) {
    return BusinessHoursModel(
      id: json['id'] as String,
      fieldId: json['field_id'] as String,
      dayOfWeek: json['day_of_week'] as int,
      isOpen: json['is_open'] as bool,
      openingTime: json['opening_time'] as String?,
      closingTime: json['closing_time'] as String?,
      closesNextDay: json['closes_next_day'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Converts the model to JSON for sending to Supabase.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'field_id': fieldId,
      'day_of_week': dayOfWeek,
      'is_open': isOpen,
      'opening_time': openingTime,
      'closing_time': closingTime,
      'closes_next_day': closesNextDay,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Creates a model from an entity.
  factory BusinessHoursModel.fromEntity(BusinessHoursEntity entity) {
    return BusinessHoursModel(
      id: entity.id,
      fieldId: entity.fieldId,
      dayOfWeek: entity.dayOfWeek,
      isOpen: entity.isOpen,
      openingTime: entity.openingTime,
      closingTime: entity.closingTime,
      closesNextDay: entity.closesNextDay,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Converts the model to an entity.
  BusinessHoursEntity toEntity() {
    return BusinessHoursEntity(
      id: id,
      fieldId: fieldId,
      dayOfWeek: dayOfWeek,
      isOpen: isOpen,
      openingTime: openingTime,
      closingTime: closingTime,
      closesNextDay: closesNextDay,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Creates a copy of this model with updated fields.
  @override
  BusinessHoursModel copyWith({
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
    return BusinessHoursModel(
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
}
