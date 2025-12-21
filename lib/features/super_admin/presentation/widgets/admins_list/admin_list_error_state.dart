import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            context.l10n.errorLoadingAdmins,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: Text(context.l10n.retry),
          ),
        ],
      ),
    );
  }
}
