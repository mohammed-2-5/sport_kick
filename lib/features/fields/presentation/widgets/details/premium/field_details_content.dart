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

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        // Hero Image
        SliverToBoxAdapter(
          child: PremiumFieldHero(
            images: field.images,
            fieldId: field.id,
            isVerified: field.isVerified,
            isPopular: field.isPopular,
            onImageTap: onImageTap,
          ),
        ),

        // Content Sections
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              _buildInfoSection(),
              const SizedBox(height: 20),
              if (_hasDescription) _buildDescriptionSection(),
              if (_hasDescription) const SizedBox(height: 20),
              if (field.hasFacilities) _buildAmenitiesSection(),
              if (field.hasFacilities) const SizedBox(height: 20),
              _buildLocationSection(),
              const SizedBox(height: 20),
              _buildReviewsSection(),
              // Extra bottom spacing for floating buttons (increased to prevent overlap)
              const SizedBox(height: 200),
            ],
          ),
        ),
      ],
    );
  }

  bool get _hasDescription =>
      field.description != null && field.description!.isNotEmpty;

  Widget _buildInfoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: PremiumFieldInfoCard(field: field, category: category),
    );
  }

  Widget _buildDescriptionSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: PremiumDescriptionCard(description: field.description!),
    );
  }

  Widget _buildAmenitiesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: PremiumAmenitiesGrid(facilities: field.facilities),
    );
  }

  Widget _buildLocationSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: PremiumLocationCard(field: field),
    );
  }

  Widget _buildReviewsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: PremiumReviewsPreview(field: field),
    );
  }
}
