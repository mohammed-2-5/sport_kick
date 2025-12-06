import 'package:flutter/material.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/dashboard/super_admin_dashboard_view.dart';

/// Super Admin Dashboard Page - Premium Design
///
/// Displays comprehensive platform statistics:
/// - User & Admin counts
/// - Field statistics
/// - Booking metrics & status breakdown
/// - Revenue analytics with trends chart
/// - 8 Quick action shortcuts
class SuperAdminDashboardPage extends StatelessWidget {
  const SuperAdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SuperAdminDashboardView();
  }
}
