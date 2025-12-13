import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/generic_error_state.dart';

/// Error state widget for bookings list.
class BookingsListErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const BookingsListErrorState({
    required this.message,
    required this.onRetry,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GenericErrorState(
      message: message,
      onRetry: onRetry,
      title: 'Error loading bookings',
    );
  }
}
