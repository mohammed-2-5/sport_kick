import 'package:flutter/material.dart';

/// Generic loading state widget for list views.
///
/// Displays a centered loading indicator with customizable message.
/// Can be reused across all features for consistent loading UI.
class GenericLoadingState extends StatelessWidget {
  /// Loading message to display
  final String message;

  const GenericLoadingState({
    this.message = 'Loading...',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(message, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
