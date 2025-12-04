import 'package:spo_kick/features/city/domain/entities/city_entity.dart';

/// City Model
///
/// Data Transfer Object for City.
/// Converts between JSON and CityEntity.
class CityModel extends CityEntity {
  const CityModel({
    required super.id,
    required super.name,
    super.arabicName,
    required super.isActive,
    super.fieldsCount,
    required super.createdAt,
  });

  /// Create CityModel from JSON
  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'] as String,
      name: json['name'] as String,
      arabicName: json['name_ar'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      fieldsCount: json['fields_count'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Convert CityModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_ar': arabicName,
      'is_active': isActive,
      'fields_count': fieldsCount,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Create CityModel from Entity
  factory CityModel.fromEntity(CityEntity entity) {
    return CityModel(
      id: entity.id,
      name: entity.name,
      arabicName: entity.arabicName,
      isActive: entity.isActive,
      fieldsCount: entity.fieldsCount,
      createdAt: entity.createdAt,
    );
  }

  /// Convert to Entity
  CityEntity toEntity() {
    return CityEntity(
      id: id,
      name: name,
      arabicName: arabicName,
      isActive: isActive,
      fieldsCount: fieldsCount,
      createdAt: createdAt,
    );
  }
}
