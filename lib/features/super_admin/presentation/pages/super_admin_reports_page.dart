import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/reports/reports_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/reports/super_admin_reports_view.dart';

/// Super Admin Reports Page - Premium Design
///
/// Features:
/// - Premium curved header
/// - Reports overview with real data
/// - Export functionality (CSV/PDF)
/// - Managed by ReportsCubit
///
/// This page serves as the entry point and BlocProvider wrapper.
/// The actual view is delegated to [SuperAdminReportsView].
class SuperAdminReportsPage extends StatelessWidget {
  const SuperAdminReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ReportsCubit>()..loadReportsData(),
      child: const SuperAdminReportsView(),
    );
  }
}
