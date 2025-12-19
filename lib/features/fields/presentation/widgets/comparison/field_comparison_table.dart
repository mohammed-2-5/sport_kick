import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/features/fields/presentation/utils/facility_localizer.dart';

class FieldComparisonTable extends StatelessWidget {
  final List<FieldEntity> fields;

  const FieldComparisonTable({super.key, required this.fields});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columnSpacing: 20,
      headingRowColor: WidgetStateProperty.all(
        AppColors.primaryLight.withValues(alpha: 0.1),
      ),
      columns: [
        DataColumn(
          label: Text(
            context.l10n.feature,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        ...fields.map(
          (field) => DataColumn(
            label: SizedBox(
              width: 150,
              child: Text(
                field.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ],
      rows: [
        // Image Row
        DataRow(
          cells: [
            DataCell(
              Text(
                context.l10n.image,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            ...fields.map(
              (field) => DataCell(
                field.hasImages
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          field.mainImage!,
                          width: 100,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        width: 100,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.sports_soccer),
                      ),
              ),
            ),
          ],
        ),

        // Price Row
        DataRow(
          cells: [
            DataCell(
              Text(
                context.l10n.pricePerHour,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            ...fields.map(
              (field) => DataCell(
                Text(
                  '${LocaleFormatters.formatPrice(context, amount: field.pricePerHour, currency: field.currency, decimalDigits: 0)}/${context.l10n.perHour}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),

        // Rating Row
        DataRow(
          cells: [
            DataCell(
              Text(
                context.l10n.rating,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            ...fields.map(
              (field) => DataCell(
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: AppColors.warning),
                    const SizedBox(width: 4),
                    Text(
                      field.hasReviews
                          ? LocaleFormatters.formatNumber(
                              context,
                              field.averageRating ?? 0,
                              decimalDigits: 1,
                            )
                          : context.l10n.noReviews,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // Reviews Row
        DataRow(
          cells: [
            DataCell(
              Text(
                context.l10n.reviews,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            ...fields.map(
              (field) => DataCell(
                Text(
                  field.hasReviews
                      ? LocaleFormatters.formatNumber(
                          context,
                          field.totalReviews,
                        )
                      : context.l10n.noReviews,
                ),
              ),
            ),
          ],
        ),

        // Capacity Row
        DataRow(
          cells: [
            DataCell(
              Text(
                context.l10n.fieldSize,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            ...fields.map((field) => DataCell(Text(field.fieldSize))),
          ],
        ),

        // Surface Type Row
        DataRow(
          cells: [
            DataCell(
              Text(
                context.l10n.surface,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            ...fields.map(
              (field) =>
                  DataCell(Text(field.surfaceType ?? context.l10n.noneListed)),
            ),
          ],
        ),

        // Location Type Row
        DataRow(
          cells: [
            DataCell(
              Text(
                context.l10n.location,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            ...fields.map(
              (field) => DataCell(
                Row(
                  children: [
                    Icon(
                      field.isIndoor ? Icons.home : Icons.wb_sunny,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      field.isIndoor
                          ? context.l10n.indoor
                          : context.l10n.outdoor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // City Row
        DataRow(
          cells: [
            DataCell(
              Text(
                context.l10n.city,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            ...fields.map(
              (field) => DataCell(
                Row(
                  children: [
                    const Icon(
                      Icons.location_city,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(field.city),
                  ],
                ),
              ),
            ),
          ],
        ),

        // Verified Row
        DataRow(
          cells: [
            DataCell(
              Text(
                context.l10n.verified,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            ...fields.map(
              (field) => DataCell(
                Icon(
                  field.isVerified ? Icons.verified : Icons.cancel,
                  color: field.isVerified ? AppColors.success : AppColors.error,
                  size: 20,
                ),
              ),
            ),
          ],
        ),

        // Facilities Row
        DataRow(
          cells: [
            DataCell(
              Text(
                context.l10n.facilities,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            ...fields.map(
              (field) => DataCell(
                SizedBox(
                  width: 150,
                  child: Text(
                    field.hasFacilities
                        ? field.facilities
                              .take(3)
                              .map(
                                (f) => FacilityLocalizer.localize(context, f),
                              )
                              .join(', ')
                        : context.l10n.noneListed,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ),
          ],
        ),

        // Total Bookings Row
        DataRow(
          cells: [
            DataCell(
              Text(
                context.l10n.popularity,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            ...fields.map(
              (field) => DataCell(
                Text(
                  '${LocaleFormatters.formatNumber(context, field.totalBookings)} ${context.l10n.bookings}',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
