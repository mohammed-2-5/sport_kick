import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/all_fields/components/field_card_image_placeholder.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/all_fields/components/field_card_rating_badge.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/all_fields/components/field_card_sport_badge.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/all_fields/components/field_card_status_badge.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/all_fields/components/field_card_verified_badge.dart';

/// Image section with overlays for field card.
class FieldCardImageSection extends StatelessWidget {
  final String? imageUrl;
  final String sportType;
  final bool isActive;
  final bool isVerified;
  final double rating;
  final int reviewCount;

  const FieldCardImageSection({
    super.key,
    required this.imageUrl,
    required this.sportType,
    required this.isActive,
    required this.isVerified,
    required this.rating,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image
          if (imageUrl != null && imageUrl!.isNotEmpty)
            CachedNetworkImage(
              imageUrl: imageUrl!,
              fit: BoxFit.cover,
              placeholder: (_, _) => const FieldCardImagePlaceholder(),
              errorWidget: (_, _, _) => const FieldCardImagePlaceholder(),
            )
          else
            const FieldCardImagePlaceholder(),

          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.6),
                ],
              ),
            ),
          ),

          // Top badges
          Positioned(
            top: 12,
            left: 12,
            child: Row(
              children: [
                // Sport type badge
                FieldCardSportBadge(sportType: sportType),
                if (isVerified) ...[
                  const SizedBox(width: 8),
                  const FieldCardVerifiedBadge(),
                ],
              ],
            ),
          ),

          // Status badge
          Positioned(
            top: 12,
            right: 12,
            child: FieldCardStatusBadge(isActive: isActive),
          ),

          // Rating badge
          if (rating > 0)
            Positioned(
              bottom: 12,
              right: 12,
              child: FieldCardRatingBadge(
                rating: rating,
                reviewCount: reviewCount,
              ),
            ),
        ],
      ),
    );
  }
}
