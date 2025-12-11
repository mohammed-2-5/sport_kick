import 'package:flutter/material.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/field_description_section.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/field_facilities_section.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/field_info_section.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/field_location_section.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/field_reviews_section.dart';

/// Body content sections for field details.
///
/// Contains all field information sections stacked vertically.
class FieldDetailsBody extends StatelessWidget {
  final FieldEntity field;
  final dynamic category;

  const FieldDetailsBody({super.key, required this.field, this.category});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FieldInfoSection(field: field, category: category),
          const Divider(height: 32),
          FieldDescriptionSection(field: field),
          const Divider(height: 32),
          FieldLocationSection(field: field),
          const Divider(height: 32),
          FieldFacilitiesSection(field: field),
          const Divider(height: 32),
          FieldReviewsSection(field: field),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
