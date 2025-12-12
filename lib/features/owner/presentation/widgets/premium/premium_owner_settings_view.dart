import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_settings/owner_settings_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_settings/owner_settings_state.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/premium_owner_settings_section.dart';

/// Premium owner settings view with enhanced UI.
///
/// Features:
/// - Premium curved header
/// - Settings sections with toggles and tiles
/// - Notification preferences
/// - Booking preferences
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
          return Scaffold(
            backgroundColor: AppColors.backgroundLight,
            body: CustomScrollView(
              slivers: [
                // Premium Header
                const SliverToBoxAdapter(
                  child: PremiumCurvedHeader(
                    title: 'Settings',
                    subtitle: 'Customize your experience',
                    showBackButton: true,
                  ),
                ),

                // Settings Content
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Account Section
                      _buildAccountSection(),
                      const SizedBox(height: 16),

                      // Notifications Section
                      _buildNotificationsSection(settingsState),
                      const SizedBox(height: 16),

                      // Booking Preferences Section
                      _buildBookingPreferencesSection(settingsState),
                      const SizedBox(height: 16),

                      // About Section
                      _buildAboutSection(),
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

  Widget _buildAccountSection() {
    return PremiumOwnerSettingsSection(
      title: 'Account',
      icon: Icons.person_outline,
      children: [
        OwnerSettingsTile(
          label: 'Edit Profile',
          icon: Icons.edit_outlined,
          onTap: () {
            HapticFeedback.lightImpact();
            context.pushNamed('ownerProfile');
          },
        ),
        OwnerSettingsTile(
          label: 'Change Password',
          icon: Icons.lock_outline,
          onTap: () {
            HapticFeedback.lightImpact();
            context.pushNamed('changePassword');
          },
        ),
        OwnerSettingsTile(
          label: 'Business Hours',
          icon: Icons.access_time,
          onTap: () {
            HapticFeedback.lightImpact();
            // Navigate to business hours editor
            _showBusinessHoursSheet();
          },
        ),
      ],
    );
  }

  Widget _buildNotificationsSection(OwnerSettingsState state) {
    final cubit = context.read<OwnerSettingsCubit>();
    return PremiumOwnerSettingsSection(
      title: 'Notifications',
      icon: Icons.notifications_outlined,
      children: [
        OwnerSettingsToggle(
          label: 'Email Notifications',
          description: 'Receive booking updates via email',
          icon: Icons.email_outlined,
          value: state.emailNotifications,
          onChanged: (value) {
            HapticFeedback.selectionClick();
            cubit.toggleEmailNotifications(value);
          },
        ),
        OwnerSettingsToggle(
          label: 'Push Notifications',
          description: 'Receive instant push notifications',
          icon: Icons.phone_android,
          value: state.pushNotifications,
          onChanged: (value) {
            HapticFeedback.selectionClick();
            cubit.togglePushNotifications(value);
          },
        ),
        OwnerSettingsToggle(
          label: 'Booking Alerts',
          description: 'Get notified for new bookings',
          icon: Icons.calendar_today_outlined,
          value: state.bookingNotifications,
          onChanged: (value) {
            HapticFeedback.selectionClick();
            cubit.toggleBookingNotifications(value);
          },
        ),
        OwnerSettingsToggle(
          label: 'Instant Notifications',
          description: 'Receive notifications immediately',
          icon: Icons.bolt,
          value: state.instantNotifications,
          onChanged: (value) {
            HapticFeedback.selectionClick();
            cubit.toggleInstantNotifications(value);
          },
        ),
      ],
    );
  }

  Widget _buildBookingPreferencesSection(OwnerSettingsState state) {
    final cubit = context.read<OwnerSettingsCubit>();
    return PremiumOwnerSettingsSection(
      title: 'Booking Preferences',
      icon: Icons.settings_outlined,
      children: [
        OwnerSettingsToggle(
          label: 'Auto-Approve Bookings',
          description: 'Automatically confirm new bookings',
          icon: Icons.check_circle_outline,
          value: state.autoApproveBookings,
          onChanged: (value) {
            HapticFeedback.selectionClick();
            cubit.toggleAutoApproveBookings(value);
          },
        ),
        OwnerSettingsTile(
          label: 'Booking Rules',
          icon: Icons.rule,
          value: 'Configure',
          onTap: () {
            HapticFeedback.lightImpact();
            // Navigate to booking rules
          },
        ),
        OwnerSettingsTile(
          label: 'Pricing Settings',
          icon: Icons.attach_money,
          value: 'Manage',
          onTap: () {
            HapticFeedback.lightImpact();
            // Navigate to pricing settings
          },
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return PremiumOwnerSettingsSection(
      title: 'About',
      icon: Icons.info_outline,
      children: [
        OwnerSettingsTile(
          label: 'Privacy Policy',
          icon: Icons.privacy_tip_outlined,
          onTap: () {
            HapticFeedback.lightImpact();
            context.pushNamed('privacyPolicy');
          },
        ),
        OwnerSettingsTile(
          label: 'Terms of Service',
          icon: Icons.description_outlined,
          onTap: () {
            HapticFeedback.lightImpact();
            context.pushNamed('termsOfService');
          },
        ),
        OwnerSettingsTile(
          label: 'App Version',
          icon: Icons.info_outline,
          value: '1.0.0',
          showArrow: false,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return PremiumButton(
      label: 'Logout',
      onPressed: _handleLogout,
      style: PremiumButtonStyle.outline,
      icon: Icons.logout,
      fullWidth: true,
    );
  }

  void _handleLogout() {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthCubit>().logout();
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showBusinessHoursSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.accentCyan,
                          AppColors.accentCyanDark,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.access_time, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Business Hours',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Set your operating hours',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Content - guidance to access business hours per field
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.accentCyan.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.sports_soccer,
                        size: 40,
                        color: AppColors.accentCyan,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Business Hours per Field',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Business hours are set individually for each field. '
                      'Go to your Fields list and select a field to manage its operating hours.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary.withValues(alpha: 0.8),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          context.pushNamed('ownerFields');
                        },
                        icon: const Icon(Icons.list_alt),
                        label: const Text('Go to My Fields'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentCyan,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
