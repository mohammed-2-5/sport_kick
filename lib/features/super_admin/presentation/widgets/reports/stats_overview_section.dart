import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/reports/reports_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/reports/stat_item_card.dart';

/// Stats Overview Section Widget
///
/// Displays a summary of key statistics:
/// - Total Users
/// - Total Admins
/// - Total Bookings
/// - Total Fields
///
/// Takes [ReportsDataLoaded] state to display formatted statistics
class StatsOverviewSection extends StatelessWidget {
  /// The loaded reports data containing statistics
  final ReportsDataLoaded state;

  const StatsOverviewSection({required this.state, super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.quickOverview,
            style: AppTextStyles.bold(AppTextStyles.titleMedium),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              StatItemCard(
                label: context.l10n.users,
                value: LocaleFormatters.formatNumber(
                  context,
                  state.users.length,
                ),
                icon: Icons.person_rounded,
                color: const Color(0xFF6366F1),
              ),
              StatItemCard(
                label: context.l10n.admins,
                value: LocaleFormatters.formatNumber(
                  context,
                  state.admins.length,
                ),
                icon: Icons.admin_panel_settings_rounded,
                color: const Color(0xFF10B981),
              ),
              StatItemCard(
                label: context.l10n.bookings,
                value: LocaleFormatters.formatNumber(
                  context,
                  state.bookings.length,
                ),
                icon: Icons.calendar_month_rounded,
                color: const Color(0xFFF59E0B),
              ),
              StatItemCard(
                label: context.l10n.fields,
                value: LocaleFormatters.formatNumber(
                  context,
                  state.fields.length,
                ),
                icon: Icons.sports_soccer_rounded,
                color: const Color(0xFF8B5CF6),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
