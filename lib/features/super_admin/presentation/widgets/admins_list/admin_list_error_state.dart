import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/generic_error_state.dart';

/// Error state widget for admins list.
///
/// Displays error icon, message and retry button.
class AdminListErrorState extends StatelessWidget {
  /// Error message to display
  final String message;

  /// Callback when retry button is pressed
  final VoidCallback onRetry;

  const AdminListErrorState({
    required this.message,
    required this.onRetry,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GenericErrorState(
      message: message,
      onRetry: onRetry,
      title: 'Error loading admins',
    );
  }
}
