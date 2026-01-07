import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';

/// Header section for the reviews preview with title and "View All" button.
///
/// Shows:
/// - Star icon + "Reviews" title
/// - "View All" button (only if field has reviews)
class ReviewsHeader extends StatelessWidget {
  final FieldEntity field;
  final ColorScheme colorScheme;

  const ReviewsHeader({
    super.key,
    required this.field,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.star, color: Colors.orange, size: 24),
            const SizedBox(width: 12),
            Text(
              context.l10n.reviews,
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        if (field.hasReviews)
          TextButton(
            onPressed: () {
              context.pushNamed(
                'allReviews',
                extra: {'fieldId': field.id, 'fieldName': field.name},
              );
            },
            child: Text(
              context.l10n.viewAll,
              style: AppTextStyles.labelLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.primary,
              ),
            ),
          ),
      ],
    );
  }
}
