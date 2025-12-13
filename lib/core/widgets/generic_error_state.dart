import 'package:flutter/material.dart';

/// Generic error state widget for list views.
///
/// Displays error icon, title, message and retry button.
/// Can be reused across all features for consistent error handling UI.
class GenericErrorState extends StatelessWidget {
  /// Error message to display (optional if only title is needed)
  final String message;

  /// Callback when retry button is pressed (null hides the retry button)
  final VoidCallback? onRetry;

  /// Title to display (defaults to 'Error')
  final String title;

  /// Icon to display (defaults to Icons.error_outline)
  final IconData icon;

  /// Icon color (defaults to Colors.red)
  final Color iconColor;

  /// Retry button text (defaults to 'Retry')
  final String retryText;

  const GenericErrorState({
    this.message = '',
    this.onRetry,
    this.title = 'Error',
    this.icon = Icons.error_outline,
    this.iconColor = Colors.red,
    this.retryText = 'Retry',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: iconColor),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          if (message.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
          if (onRetry != null) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(retryText),
            ),
          ],
        ],
      ),
    );
  }
}
