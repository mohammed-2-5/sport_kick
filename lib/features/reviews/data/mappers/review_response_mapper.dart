import 'package:spo_kick/features/reviews/data/models/review_model.dart';

/// Mapper utility for converting Supabase review responses to models.
///
/// Handles complex nested object parsing from Supabase joins.
class ReviewResponseMapper {
  /// Parse a review response from Supabase to ReviewModel.
  ///
  /// Handles both nested profile objects (from joins) and direct fields.
  ///
  /// Supabase query with join:
  /// ```dart
  /// select('''
  ///   *,
  ///   user_name:profiles!user_id(full_name),
  ///   user_avatar:profiles!user_id(avatar_url)
  /// ''')
  /// ```
  ///
  /// This results in nested objects that need special parsing:
  /// - `user_name` can be a Map or a String
  /// - `user_avatar` can be a Map or a String
  static ReviewModel fromSupabaseResponse(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      fieldId: json['field_id'] as String,
      userId: json['user_id'] as String,
      bookingId: json['booking_id'] as String?,
      rating: json['rating'] as int,
      comment: json['comment'] as String?,
      userName: _extractUserName(json),
      userAvatar: _extractUserAvatar(json),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Extract user name from nested profile join or direct field.
  ///
  /// Handles two formats:
  /// - Nested: `{"user_name": {"full_name": "John Doe"}}`
  /// - Direct: `{"user_name": "John Doe"}`
  static String? _extractUserName(Map<String, dynamic> json) {
    if (json['user_name'] == null) return null;

    if (json['user_name'] is Map) {
      final profile = json['user_name'] as Map<String, dynamic>;
      return profile['full_name'] as String?;
    } else if (json['user_name'] is String) {
      return json['user_name'] as String;
    }

    return null;
  }

  /// Extract user avatar from nested profile join or direct field.
  ///
  /// Handles two formats:
  /// - Nested: `{"user_avatar": {"avatar_url": "https://..."}}`
  /// - Direct: `{"user_avatar": "https://..."}`
  static String? _extractUserAvatar(Map<String, dynamic> json) {
    if (json['user_avatar'] == null) return null;

    if (json['user_avatar'] is Map) {
      final profile = json['user_avatar'] as Map<String, dynamic>;
      return profile['avatar_url'] as String?;
    } else if (json['user_avatar'] is String) {
      return json['user_avatar'] as String;
    }

    return null;
  }

  /// Parse multiple review responses.
  static List<ReviewModel> fromSupabaseResponseList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => fromSupabaseResponse(json as Map<String, dynamic>))
        .toList();
  }
}
