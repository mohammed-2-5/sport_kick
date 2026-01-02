import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/business_hours/presentation/constants/business_hours_constants.dart';

/// Status badge widget showing open/closed status.
///
/// Displays an icon and text indicating whether the facility is open or closed.
class BusinessHoursStatusBadge extends StatelessWidget {
  /// Whether the facility is open
  final bool isOpen;

  const BusinessHoursStatusBadge({super.key, required this.isOpen});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final successColor = isDark ? AppColors.darkSuccess : AppColors.success;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isOpen
            ? successColor.withValues(alpha: 0.1)
            : colorScheme.onSurface.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOpen ? Icons.check_circle : Icons.cancel,
            size: 12,
            color: isOpen ? successColor : colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: BusinessHoursConstants.tinySpacing),
          Text(
            isOpen ? context.l10n.open : context.l10n.closed,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isOpen ? successColor : colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
