import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

class CitySelectionFeedback {
  CitySelectionFeedback._();

  static void showSuccess(BuildContext context, String message) {
    final text = message.isNotEmpty ? message : context.l10n.somethingWentWrong;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), backgroundColor: AppColors.success),
    );
  }

  static void showError(BuildContext context, String message) {
    final text = message.isNotEmpty ? message : context.l10n.somethingWentWrong;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), backgroundColor: AppColors.error),
    );
  }
}
