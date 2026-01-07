import 'package:flutter/material.dart';
import 'package:spo_kick/features/fields/presentation/widgets/shared/field_card_new_badge.dart';
import 'package:spo_kick/features/fields/presentation/widgets/shared/field_card_rating_badge.dart';

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
      return FieldCardRatingBadge(
        ratingDisplay: ratingDisplay,
        totalReviews: totalReviews,
      );
    } else {
      return const FieldCardNewBadge();
    }
  }
}
