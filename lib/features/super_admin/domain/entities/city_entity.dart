import 'package:equatable/equatable.dart';

/// City entity representing a supported location.
///
/// Cities are used to filter fields by location.
/// Users select their city to browse available fields.
///
/// Usage:
/// ```dart
/// final city = CityEntity(
///   id: '123',
///   name: 'Minya',
///   fieldsCount: 15,
/// );
/// ```
class CityEntity extends Equatable {
  /// Unique city ID
  final String id;

  /// City name in English
  final String name;

  /// City name in Arabic (optional, for future i18n)
  final String? nameAr;

  /// Whether this city is active and can be selected
  final bool isActive;

  /// Cached count of active fields in this city
  final int fieldsCount;

  /// When the city was added to the system
  final DateTime createdAt;

  /// When the city was last updated
  final DateTime updatedAt;

  const CityEntity({
    required this.id,
    required this.name,
    this.nameAr,
    required this.isActive,
    required this.fieldsCount,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Returns true if city has fields available
  bool get hasFields => fieldsCount > 0;

  /// Get display name based on locale (for future use)
  /// Currently returns English name
  String getDisplayName({String locale = 'en'}) {
    if (locale == 'ar' && nameAr != null) {
      return nameAr!;
    }
    return name;
  }

  /// Create a copy with updated fields
  CityEntity copyWith({
    String? id,
    String? name,
    String? nameAr,
    bool? isActive,
    int? fieldsCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CityEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      isActive: isActive ?? this.isActive,
      fieldsCount: fieldsCount ?? this.fieldsCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    nameAr,
    isActive,
    fieldsCount,
    createdAt,
    updatedAt,
  ];

  @override
  String toString() {
    return 'CityEntity('
        'id: $id, '
        'name: $name, '
        'fields: $fieldsCount, '
        'active: $isActive'
        ')';
  }
}
