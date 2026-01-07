import 'package:flutter/material.dart';
import 'package:spo_kick/features/fields/presentation/widgets/shared/field_card_facility_chip.dart';

/// Facilities display widget for field card.
///
/// Shows up to 3 facility chips with colored gradients and icons.
/// Each facility has a unique color scheme for better visual distinction.
class FieldCardFacilities extends StatelessWidget {
  /// List of facility names to display
  final List<String> facilities;

  /// Maximum number of facilities to show (default: 3)
  final int maxFacilities;

  const FieldCardFacilities({
    super.key,
    required this.facilities,
    this.maxFacilities = 3,
  });

  @override
  Widget build(BuildContext context) {
    if (facilities.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: facilities
          .take(maxFacilities)
          .map((facility) => FieldCardFacilityChip(facility: facility))
          .toList(),
    );
  }
}
