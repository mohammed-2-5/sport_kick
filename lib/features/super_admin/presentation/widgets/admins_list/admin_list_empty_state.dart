import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/generic_empty_state.dart';

class AdminListEmptyState extends StatelessWidget {
  final bool isSearchEmpty;

  const AdminListEmptyState({required this.isSearchEmpty, super.key});

  @override
  Widget build(BuildContext context) {
    return GenericEmptyState(
      hasFilters: !isSearchEmpty,
      icon: isSearchEmpty ? Icons.admin_panel_settings_outlined : null,
      emptyTitle: 'No Admins Yet',
      filteredTitle: 'No Results Found',
      emptySubtitle: 'Create your first field owner account',
      filteredSubtitle: 'Try adjusting your filters',
    );
  }
}
