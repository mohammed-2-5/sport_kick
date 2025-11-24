import 'package:spo_kick/features/super_admin/domain/entities/city_entity.dart';

/// Data model for city.
///
/// Maps database table `cities` to/from JSON.
/// Extends domain entity for use in data layer.
class CityModel extends CityEntity {
  const CityModel({
    required super.id,
    required super.name,
    super.nameAr,
    required super.isActive,
    required super.fieldsCount,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Create model from JSON (database response).
  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'] as String,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      fieldsCount: _parseInt(json['fields_count']),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Convert model to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (nameAr != null) 'name_ar': nameAr,
      'is_active': isActive,
      'fields_count': fieldsCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Helper: Parse integer from dynamic type
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  @override
  String toString() {
    return 'CityModel(${super.toString()})';
  }
}
