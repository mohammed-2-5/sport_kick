import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/payment_method.dart';

/// Field model for data layer.
///
/// Extends [FieldEntity] with JSON serialization.
/// Used for converting between JSON (from Supabase) and domain entities.
class FieldModel extends FieldEntity {
  const FieldModel({
    required super.id,
    super.ownerId,
    required super.sportCategoryId,
    required super.name,
    super.description,
    required super.address,
    required super.city,
    super.latitude,
    super.longitude,
    required super.pricePerHour,
    super.currency,
    super.surfaceType,
    super.capacity,
    super.isIndoor,
    super.images,
    super.videoUrl,
    super.facilities,
    super.sportSpecificData,
    super.isActive,
    super.isVerified,
    super.averageRating,
    super.totalReviews,
    super.totalBookings,
    required super.createdAt,
    required super.updatedAt,
    super.paymentPhone,
    super.paymentMethod,
    super.paymentInstructions,
  });

  /// Create model from JSON (from Supabase response).
  ///
  /// Handles Supabase's snake_case naming convention and data types.
  factory FieldModel.fromJson(Map<String, dynamic> json) {
    // Map amenities to facilities
    final facilitiesList = json['facilities'] ?? json['amenities'];

    // Map size to capacity if capacity is null
    int? capacity = json['capacity'] as int?;
    if (capacity == null && json['size'] != null) {
      final size = json['size'] as String;
      if (size == '5-a-side') {
        capacity = 10;
      } else if (size == '7-a-side') {
        capacity = 14;
      } else if (size == '11-a-side') {
        capacity = 22;
      }
    }

    // Handle city: could be direct string, or from joined cities table
    String cityName = 'Unknown City';
    if (json['city'] is String) {
      cityName = json['city'];
    } else if (json['cities'] != null && json['cities'] is Map) {
      cityName = json['cities']['name'] ?? 'Unknown City';
    }

    return FieldModel(
      id: json['id'] as String,
      ownerId: json['owner_id'] as String?,
      sportCategoryId: json['sport_category_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      address: json['address'] as String,
      city: cityName,
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
      pricePerHour: (json['price_per_hour'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'EGP',
      surfaceType: json['surface_type'] as String?,
      capacity: capacity,
      isIndoor: json['is_indoor'] as bool? ?? false,
      images: json['images'] != null
          ? List<String>.from(json['images'] as List)
          : const [],
      videoUrl: json['video_url'] as String?,
      facilities: facilitiesList != null
          ? List<String>.from(facilitiesList as List)
          : const [],
      sportSpecificData: json['sport_specific_data'] != null
          ? Map<String, dynamic>.from(json['sport_specific_data'] as Map)
          : null,
      isActive: json['is_active'] as bool? ?? true,
      isVerified: json['is_verified'] as bool? ?? false,
      averageRating: json['average_rating'] != null
          ? (json['average_rating'] as num).toDouble()
          : null,
      totalReviews: json['total_reviews'] as int? ?? 0,
      totalBookings: json['total_bookings'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Convert model to JSON (for Supabase requests).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_id': ownerId,
      'sport_category_id': sportCategoryId,
      'name': name,
      'description': description,
      'address': address,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
      'price_per_hour': pricePerHour,
      'currency': currency,
      'surface_type': surfaceType,
      'capacity': capacity,
      'is_indoor': isIndoor,
      'images': images,
      'video_url': videoUrl,
      'facilities': facilities,
      'sport_specific_data': sportSpecificData,
      'is_active': isActive,
      'is_verified': isVerified,
      'average_rating': averageRating,
      'total_reviews': totalReviews,
      'total_bookings': totalBookings,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Create a copy with modified fields.
  FieldModel copyWith({
    String? id,
    String? ownerId,
    String? sportCategoryId,
    String? name,
    String? description,
    String? address,
    String? city,
    double? latitude,
    double? longitude,
    double? pricePerHour,
    String? currency,
    String? surfaceType,
    int? capacity,
    bool? isIndoor,
    List<String>? images,
    String? videoUrl,
    List<String>? facilities,
    Map<String, dynamic>? sportSpecificData,
    bool? isActive,
    bool? isVerified,
    double? averageRating,
    int? totalReviews,
    int? totalBookings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FieldModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      sportCategoryId: sportCategoryId ?? this.sportCategoryId,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      city: city ?? this.city,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      pricePerHour: pricePerHour ?? this.pricePerHour,
      currency: currency ?? this.currency,
      surfaceType: surfaceType ?? this.surfaceType,
      capacity: capacity ?? this.capacity,
      isIndoor: isIndoor ?? this.isIndoor,
      images: images ?? this.images,
      videoUrl: videoUrl ?? this.videoUrl,
      facilities: facilities ?? this.facilities,
      sportSpecificData: sportSpecificData ?? this.sportSpecificData,
      isActive: isActive ?? this.isActive,
      isVerified: isVerified ?? this.isVerified,
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
      totalBookings: totalBookings ?? this.totalBookings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Convert entity to model.
  factory FieldModel.fromEntity(FieldEntity entity) {
    return FieldModel(
      id: entity.id,
      ownerId: entity.ownerId,
      sportCategoryId: entity.sportCategoryId,
      name: entity.name,
      description: entity.description,
      address: entity.address,
      city: entity.city,
      latitude: entity.latitude,
      longitude: entity.longitude,
      pricePerHour: entity.pricePerHour,
      currency: entity.currency,
      surfaceType: entity.surfaceType,
      capacity: entity.capacity,
      isIndoor: entity.isIndoor,
      images: entity.images,
      videoUrl: entity.videoUrl,
      facilities: entity.facilities,
      sportSpecificData: entity.sportSpecificData,
      isActive: entity.isActive,
      isVerified: entity.isVerified,
      averageRating: entity.averageRating,
      totalReviews: entity.totalReviews,
      totalBookings: entity.totalBookings,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
