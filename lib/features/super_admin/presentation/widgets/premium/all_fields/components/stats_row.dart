import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/theme/theme_extensions.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/all_fields/components/stat_chip.dart';

/// Stats row widget displaying total, active, and inactive field counts.
class AllFieldsStatsRow extends StatelessWidget {
  final int totalCount;
  final int activeCount;
  final int inactiveCount;

  const AllFieldsStatsRow({
    super.key,
    required this.totalCount,
    required this.activeCount,
    required this.inactiveCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AllFieldsStatChip(
          label: context.l10n.total,
          count: totalCount,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 12),
        AllFieldsStatChip(
          label: context.l10n.active,
          count: activeCount,
          color: Theme.of(context).colorScheme.success,
        ),
        const SizedBox(width: 12),
        AllFieldsStatChip(
          label: context.l10n.inactive,
          count: inactiveCount,
          color: Theme.of(context).colorScheme.error,
        ),
      ],
    );
  }
}
