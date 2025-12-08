import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/premium/empty_states.dart';

/// Empty state widget shown when user has no bookings.
///
/// Uses [EmptyStates.noBookings] for consistent premium styling.
class MyBookingsEmptyState extends StatelessWidget {
  final String message;
  final VoidCallback onBrowseFields;

  const MyBookingsEmptyState({
    super.key,
    required this.message,
    required this.onBrowseFields,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStates.noBookings(onBook: onBrowseFields);
  }
}
