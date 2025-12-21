import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/dashboard/statistics_card.dart';

/// Revenue statistics row for dashboard.
class DashboardRevenueRow extends StatelessWidget {
  final dynamic statistics;

  const DashboardRevenueRow({required this.statistics, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatisticsCard(
            title: context.l10n.totalRevenue,
            value: '${context.l10n.currencyEgp} ${statistics.formattedRevenue}',
            subtitle: context.l10n.allTimeEarnings,
            icon: Icons.monetization_on,
            color: AppColors.premiumGold,
            trend: statistics.revenueGrowthRate,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StatisticsCard(
            title: context.l10n.avgRevenue,
            value: LocaleFormatters.formatPrice(
              context,
              amount: statistics.averageRevenuePerBooking,
              currency: context.l10n.currencyEgp,
              decimalDigits: 0,
            ),
            subtitle: context.l10n.perBooking,
            icon: Icons.analytics,
            color: Colors.indigo,
          ),
        ),
      ],
    );
  }
}
