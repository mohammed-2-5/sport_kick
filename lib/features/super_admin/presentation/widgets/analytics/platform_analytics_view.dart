import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/analytics/analytics_content.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/analytics/analytics_error_content.dart';

/// Main view widget for platform analytics page.
///
/// Handles BlocBuilder state management and displays:
/// - Loading indicator
/// - Error state with retry
/// - Analytics content with charts
class PlatformAnalyticsView extends StatelessWidget {
  const PlatformAnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: BlocBuilder<SuperAdminCubit, SuperAdminState>(
        builder: (context, state) {
          return RefreshIndicator(
            color: AppColors.goldAccent,
            onRefresh: () async {
              context.read<SuperAdminCubit>().loadAnalyticsData();
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: PremiumCurvedHeader(
                    title: context.l10n.analytics,
                    subtitle: context.l10n.platformPerformanceMetrics,
                    showBackButton: true,
                    actions: [
                      IconButton(
                        icon: const Icon(
                          Icons.refresh_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          context.read<SuperAdminCubit>().loadAnalyticsData();
                        },
                      ),
                    ],
                  ),
                ),
                if (state is SuperAdminLoading)
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.goldAccent,
                      ),
                    ),
                  )
                else if (state is SuperAdminError)
                  SliverFillRemaining(
                    child: AnalyticsErrorContent(
                      message: state.message,
                      onRetry: () =>
                          context.read<SuperAdminCubit>().loadAnalyticsData(),
                    ),
                  )
                else if (state is AnalyticsDataLoaded)
                  AnalyticsContent(
                    bookings: state.bookings,
                    fields: state.fields,
                    statistics: state.statistics,
                  )
                else
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.goldAccent,
                      ),
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
