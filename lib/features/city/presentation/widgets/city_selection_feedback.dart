import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// City Selection Feedback
///
/// Shows success/error snackbars with theme-aware colors.
class CitySelectionFeedback {
  CitySelectionFeedback._();

  static void showSuccess(BuildContext context, String message) {
    final text = message.isNotEmpty ? message : context.l10n.somethingWentWrong;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: isDark ? AppColors.darkSuccess : AppColors.success,
      ),
    );
  }

  static void showError(BuildContext context, String message) {
    final text = message.isNotEmpty ? message : context.l10n.somethingWentWrong;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }
}
