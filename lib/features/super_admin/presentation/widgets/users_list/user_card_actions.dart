import 'package:flutter/material.dart';

/// Action buttons for user/admin cards.
class UserCardActions extends StatelessWidget {
  final VoidCallback? onViewDetails;
  final VoidCallback? onViewBookings;

  const UserCardActions({super.key, this.onViewDetails, this.onViewBookings});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton.icon(
            onPressed: onViewDetails,
            icon: const Icon(Icons.visibility_outlined, size: 18),
            label: const Text('View Details'),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextButton.icon(
            onPressed: onViewBookings,
            icon: const Icon(Icons.event_note, size: 18),
            label: const Text('Bookings'),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
      ],
    );
  }
}
