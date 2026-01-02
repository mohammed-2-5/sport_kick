import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/all_fields/field_status_badge.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/all_fields/metric_chip.dart';

/// Field card widget for displaying field information
class FieldCard extends StatelessWidget {
  final FieldEntity field;
  final VoidCallback? onLongPress;

  const FieldCard({super.key, required this.field, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Navigate to field details
          context.pushNamed(
            'fieldDetails',
            pathParameters: {'fieldId': field.id},
          );
        },
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  // Field image or placeholder
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: colorScheme.surfaceContainerHighest,
                      image: field.mainImage != null
                          ? DecorationImage(
                              image: NetworkImage(field.mainImage!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: field.mainImage == null
                        ? Icon(
                            Icons.sports_soccer,
                            size: 40,
                            color: colorScheme.onSurfaceVariant,
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  // Field info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name and status
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                field.name,
                                style: AppTextStyles.titleMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            FieldStatusBadge(isActive: field.isActive),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // City and price
                        Row(
                          children: [
                            Icon(
                              Icons.location_city,
                              size: 14,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              field.city,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          field.formattedPrice,
                          style: AppTextStyles.titleSmall.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Metrics Row
              Row(
                children: [
                  MetricChip(
                    icon: Icons.event,
                    label: context.l10n.bookingsCount(
                      field.totalBookings,
                      field.totalBookings,
                    ),
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  if (field.averageRating != null)
                    MetricChip(
                      icon: Icons.star,
                      label: field.ratingDisplay,
                      color: Colors.amber,
                    ),
                  const SizedBox(width: 8),
                  if (field.isVerified)
                    MetricChip(
                      icon: Icons.verified,
                      label: context.l10n.verified,
                      color: Colors.green,
                    ),
                ],
              ),
              if (field.ownerId != null) ...[
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      context.l10n.ownerIdShort(field.ownerId!.substring(0, 8)),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
