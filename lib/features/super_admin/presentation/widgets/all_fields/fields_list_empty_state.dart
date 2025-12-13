import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/generic_empty_state.dart';

class FieldsListEmptyState extends StatelessWidget {
  final bool hasFilters;

  const FieldsListEmptyState({required this.hasFilters, super.key});

  @override
  Widget build(BuildContext context) {
    return GenericEmptyState(
      hasFilters: hasFilters,
      icon: hasFilters ? null : Icons.sports_soccer_outlined,
      emptyTitle: 'No Fields Yet',
      filteredTitle: 'No Results Found',
      emptySubtitle: 'Fields will appear here once created',
      filteredSubtitle: 'Try adjusting your filters',
    );
  }
}
