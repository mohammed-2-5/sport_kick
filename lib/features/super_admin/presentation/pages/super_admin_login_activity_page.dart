import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/auth/presentation/cubit/login_activity_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/login_activity/premium_login_activity_view.dart';

/// Super admin login activity page.
///
/// Displays all login activity across the platform
/// with filtering and statistics.
class SuperAdminLoginActivityPage extends StatelessWidget {
  const SuperAdminLoginActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginActivityCubit>(
      create: (_) => sl<LoginActivityCubit>(),
      child: const PremiumLoginActivityView(),
    );
  }
}
