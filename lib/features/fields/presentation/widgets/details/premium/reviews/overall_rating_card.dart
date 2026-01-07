import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';

/// Overall rating card displaying the average rating and total review count.
///
/// Features:
/// - Orange gradient background with shadow
/// - Large rating number display
/// - 5-star rating visualization
/// - Review count text
class OverallRatingCard extends StatelessWidget {
  final FieldEntity field;

  const OverallRatingCard({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.orange, Colors.deepOrange],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            field.averageRating!.toStringAsFixed(1),
            style: AppTextStyles.displayMedium.copyWith(
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.star, color: Colors.white, size: 18),
                    Icon(Icons.star, color: Colors.white, size: 18),
                    Icon(Icons.star, color: Colors.white, size: 18),
                    Icon(Icons.star, color: Colors.white, size: 18),
                    Icon(Icons.star, color: Colors.white, size: 18),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  context.l10n.basedOnReviews(field.totalReviews),
                  style: AppTextStyles.labelSmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
