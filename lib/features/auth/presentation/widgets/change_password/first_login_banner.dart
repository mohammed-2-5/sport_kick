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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.infoLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.info),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.info),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              context.l10n.firstLoginMessage,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.info),
            ),
          ),
        ],
      ),
    );
  }
}
