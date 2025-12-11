import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_dashboard/owner_dashboard_cubit.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/dashboard/premium_owner_dashboard_view.dart';

/// Owner Dashboard - Main hub for field owners
///
/// Features:
/// - Premium header with greeting
/// - Stats row with gradient cards
/// - Quick actions grid
/// - Recent bookings section
/// - Navigation drawer
/// - All logic handled by OwnerDashboardCubit
class OwnerDashboardPage extends StatelessWidget {
  const OwnerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OwnerDashboardCubit>(),
      child: const PremiumOwnerDashboardView(),
    );
  }
}
