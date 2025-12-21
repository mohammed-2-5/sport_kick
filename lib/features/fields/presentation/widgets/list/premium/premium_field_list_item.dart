import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/features/fields/presentation/utils/facility_localizer.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Premium field list item with enhanced animations and styling.
///
/// Features:
/// - Hero image animation
/// - Gradient overlays
/// - Premium badges
/// - Tap scale animation
/// - Status indicators
class PremiumFieldListItem extends StatefulWidget {
  final FieldEntity field;

  const PremiumFieldListItem({super.key, required this.field});

  @override
  State<PremiumFieldListItem> createState() => _PremiumFieldListItemState();
}

class _PremiumFieldListItemState extends State<PremiumFieldListItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final priceText =
        '${LocaleFormatters.formatPrice(context, amount: widget.field.pricePerHour, currency: widget.field.currency, decimalDigits: 0)}/${context.l10n.perHour}';
    return AnimatedScale(
      scale: _isPressed ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 100),
      child: PremiumCard(
        onTap: () => context.pushNamed('fieldDetails', extra: widget.field.id),
        padding: EdgeInsets.zero,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              _ImageSection(field: widget.field),

              // Content Section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and Verified Badge
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.field.name,
                            style: AppTextStyles.titleMedium.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (widget.field.isVerified)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.accentCyan.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.verified,
                                  size: 14,
                                  color: AppColors.accentCyan,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  context.l10n.verified,
                                  style: AppTextStyles.labelSmall.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.accentCyan,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Location
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${widget.field.city} - ${widget.field.address}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Rating and Price Row
                    Row(
                      children: [
                        // Rating
                        if (widget.field.hasReviews)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.orange, Colors.deepOrange],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 14,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  LocaleFormatters.formatNumber(
                                    context,
                                    widget.field.averageRating ?? 0,
                                    decimalDigits: 1,
                                  ),
                                  style: AppTextStyles.labelSmall.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.accentCyan.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              context.l10n.newLabel,
                              style: AppTextStyles.labelSmall.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.accentCyan,
                              ),
                            ),
                          ),

                        const Spacer(),

                        // Price
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.accentCyan,
                                AppColors.accentCyanDark,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accentCyan.withValues(
                                  alpha: 0.3,
                                ),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            priceText,
                            style: AppTextStyles.titleMedium.copyWith(
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Facilities (max 3)
                    if (widget.field.hasFacilities)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.field.facilities
                            .take(3)
                            .map(
                              (facility) => _FacilityChip(
                                facility: FacilityLocalizer.localize(
                                  context,
                                  facility,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Image section with badges.
class _ImageSection extends StatelessWidget {
  final FieldEntity field;

  const _ImageSection({required this.field});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Stack(
        children: [
          // Image
          Hero(
            tag: 'field_${field.id}',
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: field.hasImages && field.mainImage != null
                  ? CachedNetworkImage(
                      imageUrl: field.mainImage!,
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.backgroundLight,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.accentCyan,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.backgroundLight,
                        child: const Icon(
                          Icons.sports_soccer,
                          size: 48,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    )
                  : Container(
                      color: AppColors.backgroundLight,
                      child: const Icon(
                        Icons.sports_soccer,
                        size: 48,
                        color: AppColors.textSecondary,
                      ),
                    ),
            ),
          ),

          // Gradient Overlay
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.3),
                  ],
                ),
              ),
            ),
          ),

          // Popular Badge
          if (field.isPopular)
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.orange, Colors.deepOrange],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withValues(alpha: 0.4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      size: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      context.l10n.popular,
                      style: AppTextStyles.labelSmall.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Facility chip.
class _FacilityChip extends StatelessWidget {
  final String facility;

  const _FacilityChip({required this.facility});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.accentCyan.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.3)),
      ),
      child: Text(
        facility,
        style: AppTextStyles.labelSmall.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.accentCyan,
        ),
      ),
    );
  }
}
