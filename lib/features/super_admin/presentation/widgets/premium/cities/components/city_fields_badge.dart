import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Badge showing field count.
class CityFieldsBadge extends StatelessWidget {
  final int count;

  const CityFieldsBadge({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.sports_soccer,
            size: 12,
            color: Theme.of(
              context,
            ).colorScheme.secondary.withValues(alpha: 0.8),
          ),
          const SizedBox(width: 4),
          Text(
            context.l10n.fieldsCount(count),
            style: AppTextStyles.labelSmallBold.copyWith(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
