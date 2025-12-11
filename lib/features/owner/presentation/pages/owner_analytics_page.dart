import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_cubit.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/analytics/premium_owner_analytics_view.dart';

/// Owner Analytics Page - Premium Design
///
/// Features:
/// - Premium curved header
/// - Period selector chips (Today, This Week, This Month, etc.)
/// - Revenue cards with growth indicators
/// - Booking stats grid (Total, Confirmed, Pending, Canceled)
/// - Performance metrics carousel (Rating, Completion, Response, Satisfaction)
/// - Top fields ranking with medal icons
/// - Pull-to-refresh
/// - All logic handled by OwnerCubit
class OwnerAnalyticsPage extends StatelessWidget {
  const OwnerAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<OwnerCubit>()),
        BlocProvider.value(value: context.read<AuthCubit>()),
      ],
      child: const PremiumOwnerAnalyticsView(),
    );
  }
}
