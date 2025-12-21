import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Error state widget for dashboard.
class DashboardErrorState extends StatelessWidget {
  final VoidCallback onRetry;
  final String? errorMessage;

  const DashboardErrorState({
    required this.onRetry,
    this.errorMessage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: AppColors.error),
          const SizedBox(height: 16),
          Text(
            context.l10n.errorLoadingDashboard(errorMessage ?? ''),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.premiumTextPrimary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.premiumGold,
              foregroundColor: AppColors.black,
            ),
            icon: const Icon(Icons.refresh),
            label: Text(context.l10n.retry),
          ),
        ],
      ),
    );
  }
}
