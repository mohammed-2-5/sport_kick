import 'package:flutter/material.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/premium/premium_amenities_grid.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/premium/premium_description_card.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/premium/premium_field_hero.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/premium/premium_field_info_card.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/premium/premium_location_card.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/premium/premium_reviews_preview.dart';

/// Main scrollable content for field details page.
///
/// Contains all sections: Hero, Info, Description, Amenities, Location, Reviews.
class FieldDetailsContent extends StatelessWidget {
  final FieldEntity field;
  final dynamic category;
  final VoidCallback onImageTap;
  final ScrollController scrollController;

  const FieldDetailsContent({
    super.key,
    required this.field,
    required this.category,
    required this.onImageTap,
    required this.scrollController,
  });

  bool get _hasDescription =>
      field.description != null && field.description!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: PremiumFieldHero(
            images: field.images,
            fieldId: field.id,
            isVerified: field.isVerified,
            isPopular: field.isPopular,
            onImageTap: onImageTap,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                PremiumFieldInfoCard(field: field, category: category),
                const SizedBox(height: 20),
                if (_hasDescription) ...[
                  PremiumDescriptionCard(description: field.description!),
                  const SizedBox(height: 20),
                ],
                if (field.hasFacilities) ...[
                  PremiumAmenitiesGrid(facilities: field.facilities),
                  const SizedBox(height: 20),
                ],
                PremiumLocationCard(field: field),
                const SizedBox(height: 20),
                PremiumReviewsPreview(field: field),
                const SizedBox(height: 200),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
