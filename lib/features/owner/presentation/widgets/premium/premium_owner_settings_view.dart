import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_settings/owner_settings_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_settings/owner_settings_state.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/premium_owner_settings_section.dart';
import 'package:spo_kick/features/settings/domain/entities/user_preferences_entity.dart';
import 'package:spo_kick/features/settings/presentation/constants/settings_constants.dart';
import 'package:spo_kick/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:spo_kick/features/settings/presentation/cubit/settings_state.dart';
import 'package:spo_kick/features/settings/presentation/widgets/dialogs/language_selector_dialog.dart';

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
                      _buildAccountSection(),
                      const SizedBox(height: 16),

                      // Notifications Section
                      _buildNotificationsSection(settingsState),
                      const SizedBox(height: 16),

                      // Booking Preferences Section
                      _buildBookingPreferencesSection(settingsState),
                      const SizedBox(height: 16),

                      // Appearance Section
                      _buildAppearanceSection(),
                      const SizedBox(height: 16),

                      // Security Section
                      _buildSecuritySection(),
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
      title: context.l10n.accountSection,
      icon: Icons.person_outline,
      children: [
        OwnerSettingsTile(
          label: context.l10n.editProfile,
          icon: Icons.edit_outlined,
          onTap: () {
            HapticFeedback.lightImpact();
            context.pushNamed('ownerProfile');
          },
        ),
        OwnerSettingsTile(
          label: context.l10n.changePassword,
          icon: Icons.lock_outline,
          onTap: () {
            HapticFeedback.lightImpact();
            context.pushNamed('changePassword');
          },
        ),
        OwnerSettingsTile(
          label: context.l10n.businessHours,
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
      title: context.l10n.notificationsSection,
      icon: Icons.notifications_outlined,
      children: [
        OwnerSettingsToggle(
          label: context.l10n.emailNotifications,
          description: context.l10n.emailNotificationsDesc,
          icon: Icons.email_outlined,
          value: state.emailNotifications,
          onChanged: (value) {
            HapticFeedback.selectionClick();
            cubit.toggleEmailNotifications(value);
          },
        ),
        OwnerSettingsToggle(
          label: context.l10n.pushNotifications,
          description: context.l10n.pushNotificationsDesc,
          icon: Icons.phone_android,
          value: state.pushNotifications,
          onChanged: (value) {
            HapticFeedback.selectionClick();
            cubit.togglePushNotifications(value);
          },
        ),
        OwnerSettingsToggle(
          label: context.l10n.bookingAlerts,
          description: context.l10n.bookingAlertsDesc,
          icon: Icons.calendar_today_outlined,
          value: state.bookingNotifications,
          onChanged: (value) {
            HapticFeedback.selectionClick();
            cubit.toggleBookingNotifications(value);
          },
        ),
        OwnerSettingsToggle(
          label: context.l10n.instantNotifications,
          description: context.l10n.instantNotificationsDesc,
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
      title: context.l10n.bookingPreferencesSection,
      icon: Icons.settings_outlined,
      children: [
        OwnerSettingsToggle(
          label: context.l10n.autoApproveBookings,
          description: context.l10n.autoApproveBookingsDesc,
          icon: Icons.check_circle_outline,
          value: state.autoApproveBookings,
          onChanged: (value) {
            HapticFeedback.selectionClick();
            cubit.toggleAutoApproveBookings(value);
          },
        ),
        OwnerSettingsTile(
          label: context.l10n.bookingRules,
          icon: Icons.rule,
          value: context.l10n.configure,
          onTap: () {
            HapticFeedback.lightImpact();
            // Navigate to booking rules
          },
        ),
        OwnerSettingsTile(
          label: context.l10n.pricingSettings,
          icon: Icons.attach_money,
          value: context.l10n.manage,
          onTap: () {
            HapticFeedback.lightImpact();
            // Navigate to pricing settings
          },
        ),
      ],
    );
  }

  Widget _buildAppearanceSection() {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        UserPreferencesEntity? preferences;
        if (state is SettingsLoaded) {
          preferences = state.preferences;
        } else if (state is SettingsUpdated) {
          preferences = state.preferences;
        } else if (state is SettingsUpdating) {
          preferences = state.currentPreferences;
        }

        final isLoading = state is SettingsLoading || state is SettingsInitial;
        final languageValue = preferences == null
            ? context.l10n.loading
            : _languageLabel(context, preferences.language);

        return PremiumOwnerSettingsSection(
          title: context.l10n.appearance,
          icon: Icons.palette_outlined,
          children: [
            OwnerSettingsTile(
              label: context.l10n.language,
              icon: Icons.language,
              value: isLoading ? context.l10n.loading : languageValue,
              onTap: () {
                if (preferences == null) {
                  return;
                }
                HapticFeedback.lightImpact();
                showDialog(
                  context: context,
                  builder: (dialogContext) => BlocProvider.value(
                    value: context.read<SettingsCubit>(),
                    child: LanguageSelectorDialog(preferences: preferences!),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSecuritySection() {
    return PremiumOwnerSettingsSection(
      title: context.l10n.securitySection,
      icon: Icons.security_outlined,
      children: [
        OwnerSettingsTile(
          label: context.l10n.loginActivity,
          icon: Icons.history,
          value: context.l10n.viewHistory,
          onTap: () {
            HapticFeedback.lightImpact();
            context.pushNamed('loginActivity');
          },
        ),
        OwnerSettingsTile(
          label: context.l10n.activeSessions,
          icon: Icons.devices,
          value: context.l10n.manage,
          onTap: () {
            HapticFeedback.lightImpact();
            context.pushNamed('loginActivity');
          },
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return PremiumOwnerSettingsSection(
      title: context.l10n.aboutSection,
      icon: Icons.info_outline,
      children: [
        OwnerSettingsTile(
          label: context.l10n.privacyPolicy,
          icon: Icons.privacy_tip_outlined,
          onTap: () {
            HapticFeedback.lightImpact();
            context.pushNamed('privacyPolicy');
          },
        ),
        OwnerSettingsTile(
          label: context.l10n.termsOfService,
          icon: Icons.description_outlined,
          onTap: () {
            HapticFeedback.lightImpact();
            context.pushNamed('termsOfService');
          },
        ),
        OwnerSettingsTile(
          label: context.l10n.appVersion,
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
      label: context.l10n.logoutTitle,
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
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.red),
            ),
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.businessHoursSheetTitle,
                          style: AppTextStyles.titleLarge.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          context.l10n.businessHoursSheetSubtitle,
                          style: AppTextStyles.bodySmall.copyWith(
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
                    Text(
                      context.l10n.businessHoursPerField,
                      style: AppTextStyles.titleLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      context.l10n.businessHoursPerFieldDesc,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(
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
                        label: Text(context.l10n.goToMyFields),
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

  String _languageLabel(BuildContext context, String code) {
    switch (code) {
      case SettingsConstants.languageArabic:
        return context.l10n.languageArabic;
      case SettingsConstants.languageEnglish:
      default:
        return context.l10n.languageEnglish;
    }
  }
}
