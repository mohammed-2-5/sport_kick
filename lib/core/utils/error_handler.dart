import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Global error handler utility.
///
/// Provides standardized error handling and user-friendly error messages
/// throughout the application.
class ErrorHandler {
  // Prevent instantiation
  ErrorHandler._();

  /// Show error snackbar with user-friendly message.
  static void showErrorSnackbar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onRetry,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        action: onRetry != null
            ? SnackBarAction(
                label: 'Retry',
                textColor: Colors.white,
                onPressed: onRetry,
              )
            : null,
      ),
    );
  }

  /// Show success snackbar.
  static void showSuccessSnackbar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        duration: duration,
      ),
    );
  }

  /// Show info snackbar.
  static void showInfoSnackbar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
        duration: duration,
      ),
    );
  }

  /// Show warning snackbar.
  static void showWarningSnackbar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_amber_outlined, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: AppColors.warning,
        behavior: SnackBarBehavior.floating,
        duration: duration,
      ),
    );
  }

  /// Convert exception to user-friendly message.
  static String getUserFriendlyMessage(dynamic error) {
    if (error == null) return 'An unknown error occurred';

    final errorString = error.toString().toLowerCase();

    // Network errors
    if (errorString.contains('socket') ||
        errorString.contains('network') ||
        errorString.contains('connection')) {
      return 'Unable to connect. Please check your internet connection.';
    }

    // Timeout errors
    if (errorString.contains('timeout')) {
      return 'Request timed out. Please try again.';
    }

    // Server errors
    if (errorString.contains('500') ||
        errorString.contains('server') ||
        errorString.contains('internal')) {
      return 'Server error. Please try again later.';
    }

    // Authentication errors
    if (errorString.contains('auth') ||
        errorString.contains('unauthorized') ||
        errorString.contains('401')) {
      return 'Authentication failed. Please log in again.';
    }

    // Not found errors
    if (errorString.contains('404') || errorString.contains('not found')) {
      return 'The requested resource was not found.';
    }

    // Permission errors
    if (errorString.contains('403') ||
        errorString.contains('forbidden') ||
        errorString.contains('permission')) {
      return 'You do not have permission to perform this action.';
    }

    // Default error message
    return error.toString();
  }

  /// Show error dialog with details.
  static Future<void> showErrorDialog(
    BuildContext context, {
    required String title,
    required String message,
    VoidCallback? onRetry,
    String? retryButtonText,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Text(message),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          if (onRetry != null)
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onRetry();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text(retryButtonText ?? 'Retry'),
            ),
        ],
      ),
    );
  }

  /// Log error for debugging (in development mode).
  static void logError(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
  }) {
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('ERROR: $message');
    if (error != null) {
      debugPrint('Details: $error');
    }
    if (stackTrace != null) {
      debugPrint('Stack trace:');
      debugPrint(stackTrace.toString());
    }
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }
}
