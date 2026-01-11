import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/settings/super_admin_settings_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/settings/premium_super_admin_settings_view.dart';

/// Super Admin Settings Page - Premium Design
///
/// Features:
/// - Premium curved header
/// - Platform configuration section
/// - System preferences section
/// - Appearance section (theme and language)
/// - Notification preferences section
/// - Security settings section
/// - About section
/// - Logout with confirmation
/// - All logic handled by SuperAdminSettingsCubit
class SuperAdminSettingsPage extends StatefulWidget {
  const SuperAdminSettingsPage({super.key});

  @override
  State<SuperAdminSettingsPage> createState() => _SuperAdminSettingsPageState();
}

class _SuperAdminSettingsPageState extends State<SuperAdminSettingsPage> {
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    final authState = context.read<AuthCubit>().state;
    if (authState is Authenticated) {
      context.read<SettingsCubit>().loadPreferences(authState.user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<SuperAdminSettingsCubit>()),
        BlocProvider(
          create: (_) => sl<SettingsCubit>()
            ..loadPreferences(
              (context.read<AuthCubit>().state as Authenticated).user.id,
            ),
        ),
      ],
      child: const PremiumSuperAdminSettingsView(),
    );
  }
}
