import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/settings/super_admin_settings_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/settings/premium_super_admin_settings_view.dart';

/// Super Admin Settings Page - Premium Design
///
/// Features:
/// - Premium curved header
/// - Platform configuration section
/// - Notification preferences section
/// - Security settings section
/// - About section
/// - Logout with confirmation
/// - All logic handled by SuperAdminSettingsCubit
class SuperAdminSettingsPage extends StatelessWidget {
  const SuperAdminSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SuperAdminSettingsCubit>(),
      child: const PremiumSuperAdminSettingsView(),
    );
  }
}
