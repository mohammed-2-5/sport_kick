import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/generic_loading_state.dart';

/// Loading state widget for bookings list.
class BookingsListLoadingState extends StatelessWidget {
  final String message;

  const BookingsListLoadingState({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return GenericLoadingState(message: message);
  }
}
