import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/generic_empty_state.dart';

class CitiesEmptyState extends StatelessWidget {
  const CitiesEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericEmptyState(
      hasFilters: true,
      icon: Icons.location_city_outlined,
      emptyTitle: 'No Cities Found',
      filteredTitle: 'No Cities Found',
      emptySubtitle: 'Cities will appear here once added',
      filteredSubtitle: 'Try changing the filter',
    );
  }
}
