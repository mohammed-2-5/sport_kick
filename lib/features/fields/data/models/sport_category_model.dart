import 'package:spo_kick/features/fields/domain/entities/sport_category_entity.dart';

/// Sport category model for data layer.
///
/// Extends [SportCategoryEntity] with JSON serialization.
/// Used for converting between JSON (from Supabase) and domain entities.
class SportCategoryModel extends SportCategoryEntity {
  const SportCategoryModel({
    required super.id,
    required super.name,
    super.slug,
    super.icon,
    super.color,
    super.description,
    super.isActive,
    super.displayOrder,
    required super.createdAt,
  });

  /// Create model from JSON (from Supabase response).
  ///
  /// Example JSON:
  /// ```json
  /// {
  ///   "id": "uuid-123",
  ///   "name": "Football",
  ///   "slug": "football",
  ///   "icon": "⚽",
  ///   "color": "#4CAF50",
  ///   "description": "Football fields and pitches",
  ///   "is_active": true,
  ///   "display_order": 1,
  ///   "created_at": "2024-01-15T10:30:00Z"
  /// }
  /// ```
  factory SportCategoryModel.fromJson(Map<String, dynamic> json) {
    return SportCategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String?,
      icon: json['icon'] as String?,
      color: json['color'] as String?,
      description: json['description'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      displayOrder: json['display_order'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Convert model to JSON (for Supabase requests).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'icon': icon,
      'color': color,
      'description': description,
      'is_active': isActive,
      'display_order': displayOrder,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Create a copy with modified fields.
  SportCategoryModel copyWith({
    String? id,
    String? name,
    String? slug,
    String? icon,
    String? color,
    String? description,
    bool? isActive,
    int? displayOrder,
    DateTime? createdAt,
  }) {
    return SportCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      displayOrder: displayOrder ?? this.displayOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Convert entity to model.
  factory SportCategoryModel.fromEntity(SportCategoryEntity entity) {
    return SportCategoryModel(
      id: entity.id,
      name: entity.name,
      slug: entity.slug,
      icon: entity.icon,
      color: entity.color,
      description: entity.description,
      isActive: entity.isActive,
      displayOrder: entity.displayOrder,
      createdAt: entity.createdAt,
    );
  }
}
