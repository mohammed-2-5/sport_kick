import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/settings/super_admin_settings_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/settings/super_admin_settings_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/settings/premium_logout_dialog.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/settings/premium_system_preferences_section.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/settings/sections/super_admin_about_section.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/settings/sections/super_admin_appearance_section.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/settings/sections/super_admin_loading_overlay.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/settings/sections/super_admin_logout_button.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/settings/sections/super_admin_notifications_section.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/settings/sections/super_admin_platform_section.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/settings/sections/super_admin_security_section.dart';

/// Premium super admin settings view.
///
/// Features:
/// - Premium curved header
/// - Platform configuration section
/// - Notification preferences section
/// - Security settings section
/// - About section
/// - Logout with confirmation
/// - All logic handled by SuperAdminSettingsCubit
class PremiumSuperAdminSettingsView extends StatelessWidget {
  const PremiumSuperAdminSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          context.goNamed('login');
        }
      },
      child: BlocConsumer<SuperAdminSettingsCubit, SuperAdminSettingsState>(
        listener: (context, state) {
          if (state is SuperAdminSettingsError) {
            SnackbarHelper.showError(context, state.message);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Scaffold(
                backgroundColor: Theme.of(context).colorScheme.surface,
                body: _buildBody(context, state),
              ),

              // Logout dialog
              if (state is SuperAdminSettingsLoaded && state.showLogoutDialog)
                PremiumLogoutDialog(
                  onConfirm: () {
                    context.read<SuperAdminSettingsCubit>().hideLogoutDialog();
                    context.read<AuthCubit>().logout();
                  },
                  onCancel: () => context
                      .read<SuperAdminSettingsCubit>()
                      .hideLogoutDialog(),
                ),

              // Loading overlay (Optional: could also listen to AuthCubit loading)
              if (state is SuperAdminSettingsLoaded && state.isLoggingOut)
                const SuperAdminLoadingOverlay(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, SuperAdminSettingsState state) {
    if (state is! SuperAdminSettingsLoaded) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.premiumGold),
      );
    }

    final cubit = context.read<SuperAdminSettingsCubit>();

    return CustomScrollView(
      slivers: [
        // Premium Header
        SliverToBoxAdapter(
          child: PremiumCurvedHeader(
            title: context.l10n.settings,
            subtitle: context.l10n.platformConfiguration,
            showBackButton: true,
          ),
        ),

        // Content
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Platform Configuration
              SuperAdminPlatformSection(state: state, cubit: cubit),
              const SizedBox(height: 24),

              // System Preferences (Date Format & Currency)
              const PremiumSystemPreferencesSection(),
              const SizedBox(height: 24),

              // Appearance (Theme & Language)
              const SuperAdminAppearanceSection(),
              const SizedBox(height: 24),

              // Notifications
              SuperAdminNotificationsSection(state: state, cubit: cubit),
              const SizedBox(height: 24),

              // Security
              SuperAdminSecuritySection(state: state, cubit: cubit),
              const SizedBox(height: 24),

              // About
              SuperAdminAboutSection(cubit: cubit),
              const SizedBox(height: 24),

              // Logout Button
              SuperAdminLogoutButton(onTap: () => cubit.showLogoutDialog()),
              const SizedBox(height: 32),
            ]),
          ),
        ),
      ],
    );
  }
}
