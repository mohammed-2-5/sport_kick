import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/super_admin/domain/entities/day_hours_entity.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Operating Hours Quick Actions Widget
///
/// Provides quick actions for bulk hour updates.
class OperatingHoursQuickActions extends StatelessWidget {
  final VoidCallback onApplyToWeekdays;
  final VoidCallback onApplyToWeekend;
  final DayHoursEntity currentHours;

  const OperatingHoursQuickActions({
    super.key,
    required this.onApplyToWeekdays,
    required this.onApplyToWeekend,
    required this.currentHours,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.bolt,
                size: 20,
                color: Theme.of(
                  context,
                ).colorScheme.tertiary.withValues(alpha: 0.8),
              ),
              const SizedBox(width: 8),
              Text(
                context.l10n.quickActions,
                style: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  label: context.l10n.applyToWeekdays,
                  icon: Icons.work,
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    onApplyToWeekdays();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionButton(
                  label: context.l10n.applyToWeekend,
                  icon: Icons.weekend,
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    onApplyToWeekend();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.usingCurrentHours(currentHours.displayString),
            style: AppTextStyles.bodySmall.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

/// Action button widget.
class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).colorScheme.outline),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
