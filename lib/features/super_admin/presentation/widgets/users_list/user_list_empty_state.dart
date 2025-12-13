import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/generic_empty_state.dart';

class UserListEmptyState extends StatelessWidget {
  final bool hasFilters;

  const UserListEmptyState({required this.hasFilters, super.key});

  @override
  Widget build(BuildContext context) {
    return GenericEmptyState(
      hasFilters: hasFilters,
      icon: hasFilters ? null : Icons.people_outlined,
      emptyTitle: 'No Users Yet',
      filteredTitle: 'No Results Found',
      emptySubtitle: 'Users will appear here once they register',
      filteredSubtitle: 'Try adjusting your filters',
    );
  }
}
