import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/theme/theme_extensions.dart';

/// Status badge widget for user card.
class UserCardStatusBadge extends StatelessWidget {
  final bool isActive;

  const UserCardStatusBadge({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusColor = isActive
        ? colorScheme.success
        : colorScheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isActive ? context.l10n.active : context.l10n.inactive,
        style: AppTextStyles.withColor(
          AppTextStyles.labelSmallBold,
          statusColor,
        ),
      ),
    );
  }
}
