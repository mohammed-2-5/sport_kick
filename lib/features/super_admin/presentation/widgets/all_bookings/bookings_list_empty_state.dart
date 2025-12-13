import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/generic_empty_state.dart';

/// Empty state widget for bookings list.
class BookingsListEmptyState extends StatelessWidget {
  final bool hasFilters;

  const BookingsListEmptyState({required this.hasFilters, super.key});

  @override
  Widget build(BuildContext context) {
    return GenericEmptyState(
      hasFilters: hasFilters,
      icon: hasFilters ? null : Icons.event_note_outlined,
      emptyTitle: 'No bookings found',
      filteredTitle: 'No Results Found',
      emptySubtitle: 'Bookings will appear here once made',
      filteredSubtitle: 'Try adjusting your search or filters',
      iconSize: 64.0,
    );
  }
}
