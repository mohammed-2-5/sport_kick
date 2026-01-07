import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/analytics/platform_analytics_view.dart';

/// Platform Analytics Page
///
/// Comprehensive analytics dashboard for super admin showing:
/// - Revenue trends over time
/// - Booking status distribution
/// - City performance comparison
/// - Top performing fields
/// - Monthly booking trends
class PlatformAnalyticsPage extends StatelessWidget {
  const PlatformAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SuperAdminCubit>()..loadAnalyticsData(),
      child: const PlatformAnalyticsView(),
    );
  }
}
