import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/admin_details/components/field_status_badge.dart';

/// Field card widget.
class FieldCard extends StatelessWidget {
  final FieldEntity field;
  final VoidCallback onTap;

  const FieldCard({required this.field, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: PremiumCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Field image/icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.accentCyan.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                image: field.images.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(field.images.first),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: field.images.isEmpty
                  ? const Icon(
                      Icons.sports_soccer,
                      size: 24,
                      color: AppColors.accentCyan,
                    )
                  : null,
            ),
            const SizedBox(width: 14),
            // Field info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    field.name,
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: AppColors.textSecondary.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          field.city,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant
                                .withValues(alpha: 0.8),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Status and rating
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FieldStatusBadge(isActive: field.isActive),
                if ((field.averageRating ?? 0) > 0) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(
                        field.averageRating!.toStringAsFixed(1),
                        style: AppTextStyles.labelMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
