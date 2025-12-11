import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/all_fields/premium_all_fields_view.dart';

/// All Fields Management Page - Premium Design
///
/// Features:
/// - Premium curved header with navy gradient
/// - Search bar with blur effect
/// - Stats row showing total, active, inactive counts
/// - Filter chips for quick filtering
/// - Premium field cards with images and badges
/// - Staggered entrance animations
/// - Pull-to-refresh
/// - Empty and error states
/// - All logic handled by SuperAdminCubit
class AllFieldsPage extends StatelessWidget {
  const AllFieldsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SuperAdminCubit>()..loadAllFields(),
      child: const PremiumAllFieldsView(),
    );
  }
}
