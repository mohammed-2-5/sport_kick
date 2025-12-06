import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Utility class for showing consistent snackbar messages across the app.
///
/// This centralizes all snackbar display logic to ensure consistent styling
/// and removes the need for `_showError` helper functions in UI files.
class SnackbarHelper {
  SnackbarHelper._();

  /// Show an error snackbar with red background
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Show a success snackbar with green background
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Show an info snackbar with primary color background
  static void showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Show a warning snackbar with amber/orange background
  static void showWarning(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.amber.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
