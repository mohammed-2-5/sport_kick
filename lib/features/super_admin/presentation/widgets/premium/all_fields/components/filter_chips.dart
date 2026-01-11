import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/all_fields/components/filter_chip.dart';

/// Filter chips widget for selecting field status (All, Active, Inactive).
class AllFieldsFilterChips extends StatelessWidget {
  final String selectedFilter;
  final int allCount;
  final int activeCount;
  final int inactiveCount;
  final ValueChanged<String> onFilterChanged;

  const AllFieldsFilterChips({
    super.key,
    required this.selectedFilter,
    required this.allCount,
    required this.activeCount,
    required this.inactiveCount,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AllFieldsFilterChip(
          label: context.l10n.all,
          isSelected: selectedFilter == context.l10n.all2,
          onTap: () => onFilterChanged(context.l10n.all2),
        ),
        const SizedBox(width: 10),
        AllFieldsFilterChip(
          label: context.l10n.active,
          isSelected: selectedFilter == context.l10n.active2,
          onTap: () => onFilterChanged(context.l10n.active2),
        ),
        const SizedBox(width: 10),
        AllFieldsFilterChip(
          label: context.l10n.inactive,
          isSelected: selectedFilter == context.l10n.inactive2,
          onTap: () => onFilterChanged(context.l10n.inactive2),
        ),
      ],
    );
  }
}
