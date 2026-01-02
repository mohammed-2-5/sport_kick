import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:spo_kick/features/settings/presentation/widgets/layout/user_settings_body.dart';

/// User Settings Page
///
/// Settings page for regular users.
/// Uses [PremiumCurvedHeader] and delegates content to [UserSettingsBody].
class UserSettingsPage extends StatefulWidget {
  const UserSettingsPage({super.key});

  @override
  State<UserSettingsPage> createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
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
    return Scaffold(
      body: Column(
        children: [
          PremiumCurvedHeader(
            title: context.l10n.settings,
            showBackButton: false,
            height: 160,
          ),
          const Expanded(child: UserSettingsBody()),
        ],
      ),
    );
  }
}
