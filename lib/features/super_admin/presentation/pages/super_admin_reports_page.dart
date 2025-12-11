import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/reports/reports_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/reports/reports_state.dart';

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
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: BlocConsumer<ReportsCubit, ReportsState>(
        listener: (context, state) {
          if (state is ReportsExportSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
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
                backgroundColor: Colors.red,
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
                const SliverToBoxAdapter(
                  child: PremiumCurvedHeader(
                    title: 'Reports',
                    subtitle: 'Platform analytics & exports',
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
                            'Exporting ${state.exportType}...',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
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
                          _buildStatsOverview(state),
                          const SizedBox(height: 24),
                        ],
                        _buildReportCard(
                          context,
                          title: 'User Activity Report',
                          description: 'User registrations and engagement',
                          icon: Icons.people_rounded,
                          color: const Color(0xFF6366F1),
                          count: state is ReportsDataLoaded
                              ? '${state.users.length} users'
                              : null,
                          onTap: () => context.pushNamed('superAdminUsers'),
                        ),
                        const SizedBox(height: 12),
                        _buildReportCard(
                          context,
                          title: 'Revenue Report',
                          description: 'Platform-wide revenue and transactions',
                          icon: Icons.account_balance_wallet_rounded,
                          color: const Color(0xFF10B981),
                          count: state is ReportsDataLoaded
                              ? 'EGP ${state.statistics?.totalRevenue.toStringAsFixed(0) ?? '0'}'
                              : null,
                          onTap: () => context.pushNamed('superAdminAnalytics'),
                        ),
                        const SizedBox(height: 12),
                        _buildReportCard(
                          context,
                          title: 'Booking Analytics',
                          description: 'Booking trends and field utilization',
                          icon: Icons.calendar_month_rounded,
                          color: const Color(0xFFF59E0B),
                          count: state is ReportsDataLoaded
                              ? '${state.bookings.length} bookings'
                              : null,
                          onTap: () => context.pushNamed('superAdminBookings'),
                        ),
                        const SizedBox(height: 12),
                        _buildReportCard(
                          context,
                          title: 'Field Performance',
                          description: 'Field ratings and review analysis',
                          icon: Icons.sports_soccer_rounded,
                          color: const Color(0xFF8B5CF6),
                          count: state is ReportsDataLoaded
                              ? '${state.fields.length} fields'
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

  Widget _buildStatsOverview(ReportsDataLoaded state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Overview',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatItem(
                'Users',
                '${state.users.length}',
                Icons.person_rounded,
                const Color(0xFF6366F1),
              ),
              _buildStatItem(
                'Admins',
                '${state.admins.length}',
                Icons.admin_panel_settings_rounded,
                const Color(0xFF10B981),
              ),
              _buildStatItem(
                'Bookings',
                '${state.bookings.length}',
                Icons.calendar_month_rounded,
                const Color(0xFFF59E0B),
              ),
              _buildStatItem(
                'Fields',
                '${state.fields.length}',
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
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
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
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
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
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
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
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
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
          const Row(
            children: [
              Icon(Icons.download_rounded, color: AppColors.goldAccent),
              SizedBox(width: 12),
              Text(
                'Export Data',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Generate and download detailed reports in CSV or PDF format.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textOnNavySecondary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: PremiumButton(
                  label: 'CSV',
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
                  label: 'PDF',
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
