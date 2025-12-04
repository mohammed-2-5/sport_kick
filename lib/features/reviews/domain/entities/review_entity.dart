import 'package:equatable/equatable.dart';

/// Review entity representing a field review in the domain layer.
///
/// This is the core business entity for reviews, independent of external
/// data sources or presentation logic.
class ReviewEntity extends Equatable {
  /// Unique identifier for the review
  final String id;

  /// Field ID this review belongs to
  final String fieldId;

  /// User ID who created the review
  final String userId;

  /// Booking ID associated with this review (optional)
  final String? bookingId;

  /// Rating (1-5 stars)
  final int rating;

  /// Review comment/text
  final String? comment;

  /// User's full name (for display purposes)
  final String? userName;

  /// User's avatar URL (for display purposes)
  final String? userAvatar;

  /// Creation timestamp
  final DateTime createdAt;

  /// Last update timestamp
  final DateTime updatedAt;

  const ReviewEntity({
    required this.id,
    required this.fieldId,
    required this.userId,
    this.bookingId,
    required this.rating,
    this.comment,
    this.userName,
    this.userAvatar,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Check if review has a comment
  bool get hasComment => comment != null && comment!.isNotEmpty;

  /// Check if review has user info
  bool get hasUserInfo => userName != null;

  /// Get rating as double for star display
  double get ratingAsDouble => rating.toDouble();

  /// Get formatted date string
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '${weeks}w ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '${months}mo ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '${years}y ago';
    }
  }

  /// Get initials from user name for avatar placeholder
  String get userInitials {
    if (userName == null || userName!.isEmpty) return '?';

    final parts = userName!.trim().split(' ');
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  /// Check if review is recent (within last 7 days)
  bool get isRecent {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    return difference.inDays < 7;
  }

  /// Check if review was updated
  bool get wasEdited {
    return updatedAt.difference(createdAt).inMinutes > 1;
  }

  @override
  List<Object?> get props => [
    id,
    fieldId,
    userId,
    bookingId,
    rating,
    comment,
    userName,
    userAvatar,
    createdAt,
    updatedAt,
  ];
}
