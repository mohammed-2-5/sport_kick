import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/reports/reports_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/reports/reports_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/reports/export_section.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/reports/report_card.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/reports/stats_overview_section.dart';

/// Super Admin Reports View - Premium Design
///
/// Main view widget that displays:
/// - Premium curved header
/// - Reports overview with real data
/// - Export functionality (CSV/PDF)/// Managed by ReportsCubit with BlocConsumer for state handling
class SuperAdminReportsView extends StatelessWidget {
  const SuperAdminReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: BlocConsumer<ReportsCubit, ReportsState>(
        listener: (context, state) {
          if (state is ReportsExportSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: isDark
                    ? AppColors.darkSuccess
                    : AppColors.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          } else if (state is ReportsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: isDark ? AppColors.darkError : AppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<ReportsCubit>();

          return RefreshIndicator(
            color: AppColors.goldAccent,
            onRefresh: () async {
              cubit.loadReportsData();
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: PremiumCurvedHeader(
                    title: context.l10n.reports,
                    subtitle: context.l10n.platformAnalyticsAndExports,
                    showBackButton: true,
                  ),
                ),
                if (state is ReportsLoading)
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.goldAccent,
                      ),
                    ),
                  )
                else if (state is ReportsExporting)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(
                            color: AppColors.goldAccent,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            context.l10n.exportingReport(state.exportType),
                            style: AppTextStyles.withColor(
                              AppTextStyles.bodyMedium,
                              AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        if (state is ReportsDataLoaded) ...[
                          StatsOverviewSection(state: state),
                          const SizedBox(height: 24),
                        ],
                        ReportCard(
                          title: context.l10n.userActivityReport,
                          description:
                              context.l10n.userRegistrationsAndEngagement,
                          icon: Icons.people_rounded,
                          color: const Color(0xFF6366F1),
                          count: state is ReportsDataLoaded
                              ? context.l10n.usersCount(state.users.length)
                              : null,
                          onTap: () => context.pushNamed('superAdminUsers'),
                        ),
                        const SizedBox(height: 12),
                        ReportCard(
                          title: context.l10n.revenueReport,
                          description:
                              context.l10n.platformWideRevenueAndTransactions,
                          icon: Icons.account_balance_wallet_rounded,
                          color: const Color(0xFF10B981),
                          count: state is ReportsDataLoaded
                              ? context.l10n.currencyEgp
                              : null,
                          onTap: () => context.pushNamed('superAdminAnalytics'),
                        ),
                        const SizedBox(height: 12),
                        ReportCard(
                          title: context.l10n.bookingAnalytics,
                          description:
                              context.l10n.bookingTrendsAndFieldUtilization,
                          icon: Icons.calendar_month_rounded,
                          color: const Color(0xFFF59E0B),
                          count: state is ReportsDataLoaded
                              ? context.l10n.bookingsCount(
                                  state.bookings.length,
                                  state.bookings.length.toString(),
                                )
                              : null,
                          onTap: () => context.pushNamed('superAdminBookings'),
                        ),
                        const SizedBox(height: 12),
                        ReportCard(
                          title: context.l10n.fieldPerformance,
                          description:
                              context.l10n.fieldRatingsAndReviewAnalysis,
                          icon: Icons.sports_soccer_rounded,
                          color: const Color(0xFF8B5CF6),
                          count: state is ReportsDataLoaded
                              ? context.l10n.fieldsCount(state.fields.length)
                              : null,
                          onTap: () => context.pushNamed('superAdminFields'),
                        ),
                        const SizedBox(height: 24),
                        ExportSection(cubit: cubit, state: state),
                        const SizedBox(height: 32),
                      ]),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
