import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Empty state widget for bookings list.
class BookingsListEmptyState extends StatelessWidget {
  final bool hasFilters;

  const BookingsListEmptyState({required this.hasFilters, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hasFilters ? Icons.search_off : Icons.event_note_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            hasFilters
                ? context.l10n.noResultsFound
                : context.l10n.noBookingsFound,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            hasFilters
                ? context.l10n.tryAdjustingYourSearchOrFilters
                : 'Bookings will appear here once made',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
