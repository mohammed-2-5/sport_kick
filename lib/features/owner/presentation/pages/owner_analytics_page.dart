import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_gradients.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/owner/domain/constants/owner_constants.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_cubit.dart';
import 'package:spo_kick/features/owner/presentation/widgets/analytics/booking_stats_card.dart';
import 'package:spo_kick/features/owner/presentation/widgets/analytics/performance_metrics_card.dart';
import 'package:spo_kick/features/owner/presentation/widgets/analytics/period_selector_widget.dart';
import 'package:spo_kick/features/owner/presentation/widgets/analytics/revenue_overview_card.dart';
import 'package:spo_kick/features/owner/presentation/widgets/analytics/top_fields_card.dart';

/// Owner Analytics Page
///
/// Displays analytics and insights for field owners:
/// - Revenue statistics
/// - Booking trends
/// - Popular fields
/// - Performance metrics
class OwnerAnalyticsPage extends StatefulWidget {
  const OwnerAnalyticsPage({super.key});

  @override
  State<OwnerAnalyticsPage> createState() => _OwnerAnalyticsPageState();
}

class _OwnerAnalyticsPageState extends State<OwnerAnalyticsPage> {
  String _selectedPeriod = OwnerConstants.analyticsPeriods[1]; // 'This Month'

  @override
  void initState() {
    super.initState();
    // Load analytics data using cubit
    final authState = context.read<AuthCubit>().state;
    if (authState is Authenticated) {
      context.read<OwnerCubit>().loadDashboardData(authState.user.id);
    }
    context.read<FieldsCubit>().loadAllFields();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppGradients.primary),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final authState = context.read<AuthCubit>().state;
          if (authState is Authenticated) {
            context.read<OwnerCubit>().loadDashboardData(authState.user.id);
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Period Selector
              PeriodSelectorWidget(
                selectedPeriod: _selectedPeriod,
                onPeriodChanged: (period) {
                  setState(() => _selectedPeriod = period);
                },
              ),

              const SizedBox(height: 24),

              // Revenue Overview
              const RevenueOverviewCard(),

              const SizedBox(height: 24),

              // Booking Statistics
              const BookingStatsCard(),

              const SizedBox(height: 24),

              // Performance Metrics
              const PerformanceMetricsCard(),

              const SizedBox(height: 24),

              // Top Performing Fields
              const TopFieldsCard(),
            ],
          ),
        ),
      ),
    );
  }
}
