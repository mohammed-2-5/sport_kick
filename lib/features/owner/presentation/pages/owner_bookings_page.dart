import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_bookings/owner_bookings_cubit.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/bookings/premium_owner_bookings_view.dart';

/// Owner Bookings Management Page - Premium Design
///
/// Features:
/// - Navy-themed premium header with glassmorphism
/// - Search functionality with blur effect
/// - Stats chips showing booking counts
/// - Tab-based filtering (All, Pending, Confirmed, Canceled)
/// - Pull-to-refresh
/// - Approve/Reject actions with confirmation dialogs
/// - Premium booking cards with gradients
/// - Empty states with icons
/// - All logic handled by OwnerBookingsCubit
class OwnerBookingsPage extends StatelessWidget {
  const OwnerBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OwnerBookingsCubit>(),
      child: const PremiumOwnerBookingsView(),
    );
  }
}
