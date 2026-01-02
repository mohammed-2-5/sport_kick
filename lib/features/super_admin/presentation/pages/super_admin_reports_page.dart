import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/reports/reports_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/reports/reports_state.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Super Admin Reports Page - Premium Design
///
/// Features:
/// - Premium curved header
/// - Reports overview with real data
/// - Export functionality (CSV/PDF)
/// - Managed by ReportsCubit
class SuperAdminReportsPage extends StatelessWidget {
  const SuperAdminReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ReportsCubit>()..loadReportsData(),
      child: const _SuperAdminReportsView(),
    );
  }
}

class _SuperAdminReportsView extends StatelessWidget {
  const _SuperAdminReportsView();

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
                          _buildStatsOverview(context, state),
                          const SizedBox(height: 24),
                        ],
                        _buildReportCard(
                          context,
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
                        _buildReportCard(
                          context,
                          title: context.l10n.revenueReport,
                          description:
                              context.l10n.platformWideRevenueAndTransactions,
                          icon: Icons.account_balance_wallet_rounded,
                          color: const Color(0xFF10B981),
                          count: state is ReportsDataLoaded
                              ? LocaleFormatters.formatPrice(
                                  context,
                                  amount: state.statistics?.totalRevenue ?? 0,
                                  currency: context.l10n.currencyEgp,
                                  decimalDigits: 0,
                                )
                              : null,
                          onTap: () => context.pushNamed('superAdminAnalytics'),
                        ),
                        const SizedBox(height: 12),
                        _buildReportCard(
                          context,
                          title: context.l10n.bookingAnalytics,
                          description:
                              context.l10n.bookingTrendsAndFieldUtilization,
                          icon: Icons.calendar_month_rounded,
                          color: const Color(0xFFF59E0B),
                          count: state is ReportsDataLoaded
                              ? context.l10n.bookingsCount(
                                  state.bookings.length,
                                  LocaleFormatters.formatNumber(
                                    context,
                                    state.bookings.length,
                                  ),
                                )
                              : null,
                          onTap: () => context.pushNamed('superAdminBookings'),
                        ),
                        const SizedBox(height: 12),
                        _buildReportCard(
                          context,
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
                        _buildExportSection(context, cubit, state),
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

  Widget _buildStatsOverview(BuildContext context, ReportsDataLoaded state) {
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
              _buildStatItem(
                context.l10n.users,
                LocaleFormatters.formatNumber(context, state.users.length),
                Icons.person_rounded,
                const Color(0xFF6366F1),
              ),
              _buildStatItem(
                context.l10n.admins,
                LocaleFormatters.formatNumber(context, state.admins.length),
                Icons.admin_panel_settings_rounded,
                const Color(0xFF10B981),
              ),
              _buildStatItem(
                context.l10n.bookings,
                LocaleFormatters.formatNumber(context, state.bookings.length),
                Icons.calendar_month_rounded,
                const Color(0xFFF59E0B),
              ),
              _buildStatItem(
                context.l10n.fields,
                LocaleFormatters.formatNumber(context, state.fields.length),
                Icons.sports_soccer_rounded,
                const Color(0xFF8B5CF6),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.bold(AppTextStyles.titleMedium)),
          Text(label, style: AppTextStyles.labelSmall),
        ],
      ),
    );
  }

  Widget _buildReportCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    String? count,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Builder(
        builder: (context) {
          final cardColor = Theme.of(context).colorScheme.surface;
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.bold(AppTextStyles.titleMedium),
                      ),
                      const SizedBox(height: 4),
                      Text(description, style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
                if (count != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      count,
                      style: AppTextStyles.bold(
                        AppTextStyles.withColor(
                          AppTextStyles.labelMedium,
                          color,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right_rounded,
                  color: color.withValues(alpha: 0.5),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildExportSection(
    BuildContext context,
    ReportsCubit cubit,
    ReportsState state,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.navyGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.download_rounded, color: AppColors.goldAccent),
              const SizedBox(width: 12),
              Text(
                context.l10n.exportData,
                style: AppTextStyles.bold(AppTextStyles.headlineSmallWhite),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            context.l10n.generateAndDownloadDetailedReportsIn,
            style: AppTextStyles.withColor(
              AppTextStyles.bodyMedium,
              AppColors.textOnNavySecondary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: PremiumButton(
                  label: context.l10n.csv,
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    cubit.exportAllDataToCSV();
                  },
                  icon: Icons.table_chart_rounded,
                  style: PremiumButtonStyle.outline,
                  height: 44,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PremiumButton(
                  label: context.l10n.pdf,
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    cubit.exportStatisticsToPDF();
                  },
                  icon: Icons.picture_as_pdf_rounded,
                  style: PremiumButtonStyle.secondary,
                  height: 44,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
