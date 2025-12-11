import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_settings/owner_settings_cubit.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/premium_owner_settings_view.dart';

/// Owner Settings Page - Premium Design
///
/// Features:
/// - Navy gradient header
/// - Account settings (change password)
/// - Notification preferences (email, push, booking)
/// - Booking settings (auto-approve)
/// - About section (terms, privacy, version)
/// - Logout
/// - All logic handled by OwnerSettingsCubit
class OwnerSettingsPage extends StatelessWidget {
  const OwnerSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OwnerSettingsCubit>(),
      child: const PremiumOwnerSettingsView(),
    );
  }
}
