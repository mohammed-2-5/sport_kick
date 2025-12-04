import 'package:flutter/material.dart';

/// Rating stars widget for displaying ratings (read-only).
///
/// Displays star icons to represent a rating value.
/// Supports full stars, half stars, and empty stars.
///
/// Usage:
/// ```dart
/// RatingStars(
///   rating: 4.5,
///   size: 20,
///   color: Colors.amber,
/// )
/// ```
class RatingStars extends StatelessWidget {
  /// Current rating value (0-5)
  final double rating;

  /// Maximum rating value (default: 5)
  final int maxRating;

  /// Star size
  final double size;

  /// Star color when filled
  final Color color;

  /// Star color when empty
  final Color unratedColor;

  /// Spacing between stars
  final double spacing;

  const RatingStars({
    required this.rating,
    this.maxRating = 5,
    this.size = 20,
    this.color = Colors.amber,
    this.unratedColor = Colors.grey,
    this.spacing = 4,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxRating, (index) {
        final starIndex = index + 1;
        final IconData iconData;

        // Determine which icon to show
        if (rating >= starIndex) {
          iconData = Icons.star;
        } else if (rating >= starIndex - 0.5) {
          iconData = Icons.star_half;
        } else {
          iconData = Icons.star_border;
        }

        return Padding(
          padding: EdgeInsets.only(right: index < maxRating - 1 ? spacing : 0),
          child: Icon(
            iconData,
            size: size,
            color: rating > index ? color : unratedColor,
          ),
        );
      }),
    );
  }
}
