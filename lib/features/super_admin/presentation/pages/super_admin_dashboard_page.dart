import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_dashboard/super_admin_dashboard_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/dashboard/premium_super_admin_dashboard_view.dart';

/// Super Admin Dashboard Page - Premium Design
///
/// Features:
/// - Gold-themed premium header
/// - Platform statistics grid
/// - Revenue card with breakdown
/// - Quick actions (8 management shortcuts)
/// - Today's activity overview
/// - Navigation drawer
/// - All logic handled by SuperAdminDashboardCubit
class SuperAdminDashboardPage extends StatelessWidget {
  const SuperAdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SuperAdminDashboardCubit>(),
      child: const PremiumSuperAdminDashboardView(),
    );
  }
}
