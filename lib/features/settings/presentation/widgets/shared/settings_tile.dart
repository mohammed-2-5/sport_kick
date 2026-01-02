import 'package:flutter/material.dart';
import 'package:spo_kick/features/settings/presentation/constants/settings_constants.dart';

/// Settings Tile Widget
///
/// A clickable tile with leading icon, title, subtitle, and trailing widget.
/// Uses theme colors for proper dark mode support.
class SettingsTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsTile({
    required this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(SettingsConstants.tileBorderRadius),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: SettingsConstants.tileVerticalPadding,
        ),
        child: Row(
          children: [
            SizedBox(width: SettingsConstants.leadingIconSize, child: leading),
            const SizedBox(width: SettingsConstants.iconSpacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: textTheme.bodyLarge),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
