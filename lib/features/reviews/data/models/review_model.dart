import 'package:spo_kick/features/reviews/domain/entities/review_entity.dart';

/// Review data model for API/database operations.
///
/// Extends [ReviewEntity] and adds JSON serialization.
class ReviewModel extends ReviewEntity {
  const ReviewModel({
    required super.id,
    required super.fieldId,
    required super.userId,
    super.bookingId,
    required super.rating,
    super.comment,
    super.userName,
    super.userAvatar,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Create ReviewModel from JSON
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      fieldId: json['field_id'] as String,
      userId: json['user_id'] as String,
      bookingId: json['booking_id'] as String?,
      rating: json['rating'] as int,
      comment: json['comment'] as String?,
      userName: json['user_name'] as String?,
      userAvatar: json['user_avatar'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Convert ReviewModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'field_id': fieldId,
      'user_id': userId,
      'booking_id': bookingId,
      'rating': rating,
      'comment': comment,
      'user_name': userName,
      'user_avatar': userAvatar,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Create ReviewModel from ReviewEntity
  factory ReviewModel.fromEntity(ReviewEntity entity) {
    return ReviewModel(
      id: entity.id,
      fieldId: entity.fieldId,
      userId: entity.userId,
      bookingId: entity.bookingId,
      rating: entity.rating,
      comment: entity.comment,
      userName: entity.userName,
      userAvatar: entity.userAvatar,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Convert to ReviewEntity
  ReviewEntity toEntity() {
    return ReviewEntity(
      id: id,
      fieldId: fieldId,
      userId: userId,
      bookingId: bookingId,
      rating: rating,
      comment: comment,
      userName: userName,
      userAvatar: userAvatar,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Create a copy with updated fields
  ReviewModel copyWith({
    String? id,
    String? fieldId,
    String? userId,
    String? bookingId,
    int? rating,
    String? comment,
    String? userName,
    String? userAvatar,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      fieldId: fieldId ?? this.fieldId,
      userId: userId ?? this.userId,
      bookingId: bookingId ?? this.bookingId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
