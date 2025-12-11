import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/all_bookings/premium_all_bookings_view.dart';

/// All Bookings Management Page - Premium Design
///
/// Features:
/// - Premium curved header with navy gradient
/// - Tab-based status filtering (All, Pending, Confirmed, Completed, Canceled)
/// - Search bar with blur effect
/// - Stats row showing booking counts per status
/// - Premium booking cards with status indicators
/// - Staggered entrance animations
/// - Pull-to-refresh
/// - Empty and error states
/// - All logic handled by SuperAdminCubit
class AllBookingsPage extends StatelessWidget {
  const AllBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SuperAdminCubit>()..loadAllBookings(),
      child: const PremiumAllBookingsView(),
    );
  }
}
