import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/widgets/custom_button.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Error display widget with retry functionality.
///
/// Shows error states with appropriate icons and messages.
/// Supports retry actions and different error types.
///
/// Usage:
/// ```dart
/// AppErrorWidget(
///   message: context.l10n.failedToLoadFields,
///   onRetry: () => _loadFields(),
/// )
/// ```
class AppErrorWidget extends StatelessWidget {
  /// Error message to display
  final String message;

  /// Callback when retry button is pressed
  final VoidCallback? onRetry;

  /// Error type (determines icon and styling)
  final ErrorType errorType;

  /// Custom icon to display
  final IconData? icon;

  /// Custom title
  final String? title;

  /// Whether to show retry button
  final bool showRetryButton;

  const AppErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.errorType = ErrorType.general,
    this.icon,
    this.title,
    this.showRetryButton = true,
  });

  /// Network error constructor
  const AppErrorWidget.network({
    super.key,
    this.message = 'No internet connection',
    this.onRetry,
  }) : errorType = ErrorType.network,
       icon = null,
       title = null,
       showRetryButton = true;

  /// Server error constructor
  const AppErrorWidget.server({
    super.key,
    this.message = 'Something went wrong',
    this.onRetry,
  }) : errorType = ErrorType.server,
       icon = null,
       title = null,
       showRetryButton = true;

  /// Not found error constructor
  const AppErrorWidget.notFound({
    super.key,
    this.message = 'Content not found',
    this.onRetry,
  }) : errorType = ErrorType.notFound,
       icon = null,
       title = null,
       showRetryButton = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _getErrorColor().withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ?? _getErrorIcon(),
                size: 40,
                color: _getErrorColor(),
              ),
            ),

            const SizedBox(height: 24),

            // Error Title
            if (title != null)
              Text(
                title!,
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              )
            else
              Text(
                _getErrorTitle(),
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),

            const SizedBox(height: 12),

            // Error Message
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),

            // Retry Button
            if (showRetryButton && onRetry != null) ...[
              const SizedBox(height: 32),
              CustomButton(
                text: context.l10n.tryAgain,
                onPressed: onRetry,
                variant: ButtonVariant.outline,
                icon: Icons.refresh,
                width: 200,
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getErrorIcon() {
    switch (errorType) {
      case ErrorType.network:
        return Icons.wifi_off_rounded;
      case ErrorType.server:
        return Icons.error_outline_rounded;
      case ErrorType.notFound:
        return Icons.search_off_rounded;
      case ErrorType.general:
        return Icons.warning_amber_rounded;
    }
  }

  String _getErrorTitle() {
    switch (errorType) {
      case ErrorType.network:
        return 'No Connection';
      case ErrorType.server:
        return 'Server Error';
      case ErrorType.notFound:
        return 'Not Found';
      case ErrorType.general:
        return 'Oops!';
    }
  }

  Color _getErrorColor() {
    switch (errorType) {
      case ErrorType.network:
        return AppColors.warning;
      case ErrorType.server:
      case ErrorType.general:
        return AppColors.error;
      case ErrorType.notFound:
        return AppColors.textSecondary;
    }
  }
}

/// Error type enum
enum ErrorType {
  /// General error
  general,

  /// Network/connectivity error
  network,

  /// Server error
  server,

  /// Not found error
  notFound,
}
