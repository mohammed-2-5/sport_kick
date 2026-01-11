import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Stat chip widget for user card.
class UserCardStatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const UserCardStatChip({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.withColor(
              AppTextStyles.labelSmall,
              colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
