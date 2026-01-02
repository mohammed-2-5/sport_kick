import 'package:flutter/material.dart';
import 'package:spo_kick/features/super_admin/presentation/constants/admin_ui_constants.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Empty state widget for when no bookings are found
class UserEmptyBookingsState extends StatelessWidget {
  const UserEmptyBookingsState({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AdminUIConstants.emptyStatePadding),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: AdminUIConstants.borderRadiusMedium,
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.event_busy,
            size: AdminUIConstants.emptyStateIconSize,
            color: colorScheme.outline,
          ),
          const SizedBox(height: AdminUIConstants.listItemSpacing),
          Text(
            context.l10n.noBookingsYet2,
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AdminUIConstants.spacingSmall),
          Text(
            context.l10n.thisUserHasntMadeAnyBookingsYet,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
