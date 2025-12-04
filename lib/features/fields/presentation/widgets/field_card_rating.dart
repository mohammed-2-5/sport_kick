import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Rating display widget for field card.
///
/// Shows the field's rating with star icon and review count if reviews exist,
/// or displays a "New" badge if the field has no reviews yet.
class FieldCardRating extends StatelessWidget {
  /// Whether the field has any reviews
  final bool hasReviews;

  /// The formatted rating value (e.g., "4.5")
  final String ratingDisplay;

  /// The total number of reviews
  final int totalReviews;

  const FieldCardRating({
    super.key,
    required this.hasReviews,
    required this.ratingDisplay,
    required this.totalReviews,
  });

  @override
  Widget build(BuildContext context) {
    if (hasReviews) {
      return _buildRatingBadge();
    } else {
      return _buildNewBadge();
    }
  }

  /// Builds the rating badge with gradient background when reviews exist
  Widget _buildRatingBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFA726),
            Color(0xFFFFB74D),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star_rounded,
            size: 16,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            ratingDisplay,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 3),
          Text(
            '($totalReviews)',
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the "New" badge when no reviews exist
  Widget _buildNewBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_outline_rounded,
            size: 14,
            color: AppColors.textSecondary,
          ),
          SizedBox(width: 4),
          Text(
            'New',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
