import 'package:flutter/material.dart';
import 'package:spo_kick/features/owner/presentation/constants/analytics_constants.dart';

/// Error state widget for analytics pages.
/// Displays error icon, message, and retry button.
class AnalyticsErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const AnalyticsErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: AnalyticsConstants.emptyStateIconSize,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: AnalyticsConstants.sectionSpacing),
          Text(
            'Error loading analytics',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AnalyticsConstants.metricCardSpacing),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AnalyticsConstants.sectionSpacing),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
