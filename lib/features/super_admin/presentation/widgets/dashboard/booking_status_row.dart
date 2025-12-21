import 'package:flutter/material.dart';
import 'package:spo_kick/features/super_admin/domain/entities/platform_statistics_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/dashboard/mini_stat_card.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

class BookingStatusRow extends StatelessWidget {
  final PlatformStatisticsEntity statistics;

  const BookingStatusRow({required this.statistics, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: MiniStatCard(
            label: context.l10n.statusConfirmed,
            value: statistics.confirmedBookings.toString(),
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: MiniStatCard(
            label: context.l10n.statusCompleted,
            value: statistics.completedBookings.toString(),
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: MiniStatCard(
            label: context.l10n.statusCancelled,
            value: statistics.canceledBookings.toString(),
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}
