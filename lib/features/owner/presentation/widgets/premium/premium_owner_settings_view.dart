import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_settings/owner_settings_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_settings/owner_settings_state.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/sections/owner_about_section.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/sections/owner_account_section.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/sections/owner_appearance_section.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/sections/owner_booking_preferences_section.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/sections/owner_business_hours_sheet.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/sections/owner_notifications_section.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/sections/owner_security_section.dart';

/// Premium owner settings view with enhanced UI.
///
/// Features:
/// - Premium curved header
/// - Settings sections with toggles and tiles
/// - Notification preferences
/// - Booking preferences
/// - Appearance settings (theme and language)
/// - About section
/// - Logout button
class PremiumOwnerSettingsView extends StatefulWidget {
  const PremiumOwnerSettingsView({super.key});

  @override
  State<PremiumOwnerSettingsView> createState() =>
      _PremiumOwnerSettingsViewState();
}

class _PremiumOwnerSettingsViewState extends State<PremiumOwnerSettingsView> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          context.goNamed('login');
        }
      },
      child: BlocBuilder<OwnerSettingsCubit, OwnerSettingsState>(
        builder: (context, settingsState) {
          final cubit = context.read<OwnerSettingsCubit>();

          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            body: CustomScrollView(
              slivers: [
                // Premium Header
                SliverToBoxAdapter(
                  child: PremiumCurvedHeader(
                    title: context.l10n.settingsTitle,
                    subtitle: context.l10n.settingsSubtitle,
                    showBackButton: true,
                  ),
                ),

                // Settings Content
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Account Section
                      OwnerAccountSection(
                        onBusinessHoursTap: () =>
                            OwnerBusinessHoursSheet.show(context),
                      ),
                      const SizedBox(height: 16),

                      // Notifications Section
                      OwnerNotificationsSection(
                        state: settingsState,
                        cubit: cubit,
                      ),
                      const SizedBox(height: 16),

                      // Booking Preferences Section
                      OwnerBookingPreferencesSection(
                        state: settingsState,
                        cubit: cubit,
                      ),
                      const SizedBox(height: 16),

                      // Appearance Section
                      const OwnerAppearanceSection(),
                      const SizedBox(height: 16),

                      // Security Section
                      const OwnerSecuritySection(),
                      const SizedBox(height: 16),

                      // About Section
                      const OwnerAboutSection(),
                      const SizedBox(height: 24),

                      // Logout Button
                      _buildLogoutButton(),
                      const SizedBox(height: 32),
                    ]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogoutButton() {
    return PremiumButton(
      label: context.l10n.logoutTitle,
      onPressed: _handleLogout,
      style: PremiumButtonStyle.outline,
      icon: Icons.logout,
      fullWidth: true,
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(context.l10n.logoutTitle),
        content: Text(context.l10n.logoutMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthCubit>().logout();
            },
            child: Text(
              context.l10n.logoutTitle,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
