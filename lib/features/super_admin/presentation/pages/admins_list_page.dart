import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/admins_list/super_admin_admins_list_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/admins_list/premium_super_admin_admins_list_view.dart';

/// Admins List Page - Premium Design
///
/// Features:
/// - Gold-themed premium header with glassmorphism
/// - Search functionality with blur effect
/// - Stats chips showing admin counts
/// - Filter chips (All, Active, Inactive)
/// - Selection mode for bulk actions
/// - Bulk activate/deactivate with confirmation
/// - Premium admin cards with status indicators
/// - Responsive grid layout with staggered animations
/// - Pull-to-refresh
/// - Empty states with icons
/// - Loading shimmer effect
/// - All logic handled by SuperAdminAdminsListCubit
class AdminsListPage extends StatelessWidget {
  const AdminsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SuperAdminAdminsListCubit>(),
      child: const PremiumSuperAdminAdminsListView(),
    );
  }
}
