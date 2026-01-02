import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// First login banner widget.
///
/// Displays an information banner for first-time users who need
/// to change their password.
class FirstLoginBanner extends StatelessWidget {
  const FirstLoginBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final infoColor = isDark ? AppColors.darkInfo : AppColors.info;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: infoColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: infoColor),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: infoColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              context.l10n.firstLoginMessage,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: infoColor),
            ),
          ),
        ],
      ),
    );
  }
}
