import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_cubit.dart';
import 'package:spo_kick/features/owner/presentation/widgets/analytics/owner_revenue_view.dart';

/// Owner Revenue Analytics Page
///
/// Displays comprehensive revenue analytics for field owners:
/// - Revenue trends over time
/// - Revenue breakdown by field
/// - Booking status distribution
/// - Key performance metrics
/// - Date range filtering
class OwnerRevenuePage extends StatelessWidget {
  const OwnerRevenuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final authState = context.read<AuthCubit>().state;
        if (authState is Authenticated) {
          return sl<OwnerCubit>()..loadOwnerRevenue(authState.user.id);
        }
        return sl<OwnerCubit>();
      },
      child: const OwnerRevenueView(),
    );
  }
}
