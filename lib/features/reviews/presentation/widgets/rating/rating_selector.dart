import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Interactive rating selector widget.
///
/// Allows users to select a rating value by tapping on stars.
/// Displays rating labels (Poor, Fair, Good, Very Good, Excellent).
///
/// Usage:
/// ```dart
/// RatingSelector(
///   initialRating: 0,
///   onRatingChanged: (rating) => print('Selected: $rating'),
///   label: context.l10n.yourRating,
/// )
/// ```
class RatingSelector extends StatefulWidget {
  /// Initial rating value
  final int initialRating;

  /// Maximum rating value (default: 5)
  final int maxRating;

  /// Star size
  final double size;

  /// Star color
  final Color color;

  /// Callback when rating changes
  final ValueChanged<int> onRatingChanged;

  /// Label text to display above stars
  final String? label;

  const RatingSelector({
    this.initialRating = 0,
    this.maxRating = 5,
    this.size = 32,
    this.color = Colors.amber,
    required this.onRatingChanged,
    this.label,
    super.key,
  });

  @override
  State<RatingSelector> createState() => _RatingSelectorState();
}

class _RatingSelectorState extends State<RatingSelector> {
  late int _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  void _updateRating(int rating) {
    setState(() {
      _currentRating = rating;
    });
    widget.onRatingChanged(rating);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.maxRating, (index) {
            final starIndex = index + 1;
            return GestureDetector(
              onTap: () => _updateRating(starIndex),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  _currentRating >= starIndex ? Icons.star : Icons.star_border,
                  size: widget.size,
                  color: _currentRating >= starIndex
                      ? widget.color
                      : Colors.grey[400],
                ),
              ),
            );
          }),
        ),
        if (_currentRating > 0) ...[
          const SizedBox(height: 8),
          Center(
            child: Text(
              _getRatingLabel(context, _currentRating),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }

  String _getRatingLabel(BuildContext context, int rating) {
    switch (rating) {
      case 1:
        return context.l10n.ratingPoor;
      case 2:
        return context.l10n.ratingFair;
      case 3:
        return context.l10n.ratingGood;
      case 4:
        return context.l10n.ratingVeryGood;
      case 5:
        return context.l10n.ratingExcellent;
      default:
        return '';
    }
  }
}
