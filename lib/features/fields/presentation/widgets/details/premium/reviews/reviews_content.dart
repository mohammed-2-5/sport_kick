import 'package:flutter/material.dart';
import 'package:spo_kick/core/theme/theme_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/premium/reviews/overall_rating_card.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/premium/reviews/reviews_header.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/premium/reviews/reviews_list.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/premium/reviews/write_review_button.dart';

/// Internal widget to handle reviews content with BlocBuilder.
///
/// This widget builds the main reviews section card with:
/// - Header with title and "View All" button
/// - Overall rating card (if reviews exist)
/// - Reviews list (shows loading/error/empty/loaded states)
/// - Write review button (for authenticated users)
class ReviewsContent extends StatelessWidget {
  final FieldEntity field;

  const ReviewsContent({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PremiumCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReviewsHeader(field: field, colorScheme: colorScheme),
          const SizedBox(height: 20),
          if (field.hasReviews) ...[
            OverallRatingCard(field: field),
            const SizedBox(height: 20),
          ],
          ReviewsList(field: field, colorScheme: colorScheme, isDark: isDark),
          const SizedBox(height: 16),
          WriteReviewButton(field: field, colorScheme: colorScheme),
        ],
      ),
    );
  }
}
