import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/theme/theme_extensions.dart';
import 'package:spo_kick/features/fields/presentation/widgets/shared/field_card_verified_badge.dart';

/// Field information section displaying name, location, and verified badge.
///
/// Shows the field name with optional verified badge, and location details
/// including city and field size.
class FieldCardInfo extends StatelessWidget {
  /// The name of the field
  final String fieldName;

  /// The city where the field is located
  final String city;

  /// The size of the field (e.g., "5v5", "7v7", "11v11")
  final String fieldSize;

  /// Whether the field is verified
  final bool isVerified;

  const FieldCardInfo({
    super.key,
    required this.fieldName,
    required this.city,
    required this.fieldSize,
    required this.isVerified,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                fieldName,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isVerified) ...[
              const SizedBox(width: 8),
              const FieldCardVerifiedBadge(),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 14,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                '$city - $fieldSize',
                style: AppTextStyles.bodySmall.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
