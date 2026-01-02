import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/constants/admin_ui_constants.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Field card widget for admin details page
class AdminFieldCard extends StatelessWidget {
  final FieldEntity field;
  final VoidCallback onTap;

  const AdminFieldCard({required this.field, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: AdminUIConstants.cardMarginBottom),
      shape: RoundedRectangleBorder(
        borderRadius: AdminUIConstants.borderRadiusMedium,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AdminUIConstants.borderRadiusMedium,
        child: Padding(
          padding: AdminUIConstants.paddingCard,
          child: Row(
            children: [
              // Field Image
              Container(
                width: AdminUIConstants.cardImageSize,
                height: AdminUIConstants.cardImageSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    AdminUIConstants.radiusSmall,
                  ),
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
                        size: 30,
                        color: colorScheme.onSurfaceVariant,
                      )
                    : null,
              ),
              const SizedBox(width: AdminUIConstants.listItemSpacing),

              // Field Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      field.name,
                      style: AppTextStyles.bold(AppTextStyles.titleMedium),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_city,
                          size: AdminUIConstants.fontSizeMedium,
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 4),
                        Text(field.city, style: AppTextStyles.bodySmall),
                        const SizedBox(width: AdminUIConstants.listItemSpacing),
                        Icon(
                          Icons.event,
                          size: AdminUIConstants.fontSizeMedium,
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          context.l10n.bookingsCount(
                            field.totalBookings,
                            LocaleFormatters.formatNumber(
                              context,
                              field.totalBookings,
                            ),
                          ),
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Status Badge
              Container(
                padding: AdminUIConstants.badgePadding,
                decoration: BoxDecoration(
                  color: field.isActive
                      ? Colors.green.withValues(
                          alpha: AdminUIConstants.opacityLight,
                        )
                      : Colors.orange.withValues(
                          alpha: AdminUIConstants.opacityLight,
                        ),
                  borderRadius: BorderRadius.circular(
                    AdminUIConstants.radiusSmall,
                  ),
                  border: Border.all(
                    color: field.isActive ? Colors.green : Colors.orange,
                  ),
                ),
                child: Text(
                  field.isActive ? context.l10n.active : context.l10n.inactive,
                  style: field.isActive
                      ? AppTextStyles.statusBadgeActive
                      : AppTextStyles.statusBadgeInactive,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
