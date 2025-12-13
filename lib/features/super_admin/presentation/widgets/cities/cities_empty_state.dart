import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/generic_empty_state.dart';

class CitiesEmptyState extends StatelessWidget {
  const CitiesEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericEmptyState(
      hasFilters: false,
      icon: Icons.location_city_outlined,
      emptyTitle: 'No Cities Found',
      filteredTitle: 'No Cities Found',
      emptySubtitle: 'Try changing the filter',
      filteredSubtitle: 'Try changing the filter',
    );
  }
}
