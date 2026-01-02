import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_shadows.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/presentation/constants/field_constants.dart';
import 'package:spo_kick/features/fields/presentation/widgets/shared/field_card_facilities.dart';
import 'package:spo_kick/features/fields/presentation/widgets/shared/field_card_image.dart';
import 'package:spo_kick/features/fields/presentation/widgets/shared/field_card_info.dart';
import 'package:spo_kick/features/fields/presentation/widgets/shared/field_card_price.dart';
import 'package:spo_kick/features/fields/presentation/widgets/shared/field_card_rating.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Card widget for displaying a field in a list.
///
/// Shows field image, name, location, price, rating, and amenities.
/// Tapping the card navigates to field details.
///
/// This widget is now modularized with extracted components:
/// - [FieldCardImage]: Image section with hero animation and badges
/// - [FieldCardInfo]: Field name, location, and verified badge
/// - [FieldCardRating]: Rating display with star icon or "New" badge
/// - [FieldCardPrice]: Price display with gradient background
/// - [FieldCardFacilities]: Facility chips with icons
class FieldCard extends StatelessWidget {
  final FieldEntity field;
  final VoidCallback onTap;

  const FieldCard({super.key, required this.field, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final priceText =
        '${LocaleFormatters.formatPrice(context, amount: field.pricePerHour, currency: field.currency, decimalDigits: 0)}/${context.l10n.perHour}';
    final ratingText = LocaleFormatters.formatNumber(
      context,
      field.averageRating ?? 0,
      decimalDigits: 1,
    );
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          FieldConstants.cardBorderRadius + 8,
        ),
        boxShadow: isDark ? null : AppShadows.large,
        gradient: LinearGradient(
          colors: [
            colorScheme.surface,
            colorScheme.primary.withValues(alpha: 0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            FieldConstants.cardBorderRadius + 8,
          ),
          border: Border.all(
            color: colorScheme.primary.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(
              FieldConstants.cardBorderRadius + 8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Field Image with hero animation and popular badge
                FieldCardImage(
                  fieldId: field.id,
                  mainImageUrl: field.mainImage,
                  hasImages: field.hasImages,
                  isPopular: field.isPopular,
                ),

                // Field Info Section
                Padding(
                  padding: const EdgeInsets.all(FieldConstants.standardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name, location, and verified badge
                      FieldCardInfo(
                        fieldName: field.name,
                        city: field.city,
                        fieldSize: field.fieldSize,
                        isVerified: field.isVerified,
                      ),

                      const SizedBox(height: FieldConstants.smallPadding),

                      // Rating and Price Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Rating badge or "New" badge
                          FieldCardRating(
                            hasReviews: field.hasReviews,
                            ratingDisplay: ratingText,
                            totalReviews: field.totalReviews,
                          ),

                          // Price badge
                          FieldCardPrice(formattedPrice: priceText),
                        ],
                      ),

                      // Facilities (show first 3)
                      if (field.hasFacilities) ...[
                        const SizedBox(height: FieldConstants.itemSpacing),
                        FieldCardFacilities(
                          facilities: field.facilities,
                          maxFacilities: 3,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
