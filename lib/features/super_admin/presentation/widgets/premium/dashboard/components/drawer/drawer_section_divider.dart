import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Section divider with title for drawer menu.
///
/// Displays a title with a horizontal line separator.
class DrawerSectionDivider extends StatelessWidget {
  final String title;

  const DrawerSectionDivider({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
      child: Row(
        children: [
          Text(
            title.toUpperCase(),
            style: AppTextStyles.withColor(
              AppTextStyles.labelSmallBold,
              colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 1,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }
}
