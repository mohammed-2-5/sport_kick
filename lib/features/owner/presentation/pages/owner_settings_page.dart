import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_settings/owner_settings_cubit.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/premium_owner_settings_view.dart';
import 'package:spo_kick/features/settings/presentation/cubit/settings_cubit.dart';

/// Owner Settings Page - Premium Design
///
/// Features:
/// - Navy gradient header
/// - Account settings (change password)
/// - Notification preferences (email, push, booking)
/// - Booking settings (auto-approve)
/// - Appearance section (theme and language)
/// - About section (terms, privacy, version)
/// - Logout
/// - All logic handled by OwnerSettingsCubit
class OwnerSettingsPage extends StatefulWidget {
  const OwnerSettingsPage({super.key});

  @override
  State<OwnerSettingsPage> createState() => _OwnerSettingsPageState();
}

class _OwnerSettingsPageState extends State<OwnerSettingsPage> {
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
        BlocProvider(create: (_) => sl<OwnerSettingsCubit>()),
        BlocProvider(
          create: (_) => sl<SettingsCubit>()
            ..loadPreferences(
              (context.read<AuthCubit>().state as Authenticated).user.id,
            ),
        ),
      ],
      child: const PremiumOwnerSettingsView(),
    );
  }
}
